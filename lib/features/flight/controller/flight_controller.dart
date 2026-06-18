import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flight_app/core/utils/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/flight_data.dart';

const _flightApiUrl = '';

enum FlightFilter { all, best, cheapest, fastest }

// ─── Airline catalogue used for mock route generation ────────────────────────
const _airlines = [
  _AirlineInfo(
    'Emirates',
    'EK',
    'https://www.gstatic.com/flights/airline_logos/70px/EK.png',
  ),
  _AirlineInfo(
    'Qatar Airways',
    'QR',
    'https://www.gstatic.com/flights/airline_logos/70px/QR.png',
  ),
  _AirlineInfo(
    'flydubai',
    'FZ',
    'https://www.gstatic.com/flights/airline_logos/70px/FZ.png',
  ),
  _AirlineInfo(
    'Turkish Airlines',
    'TK',
    'https://www.gstatic.com/flights/airline_logos/70px/TK.png',
  ),
  _AirlineInfo(
    'Lufthansa',
    'LH',
    'https://www.gstatic.com/flights/airline_logos/70px/LH.png',
  ),
  _AirlineInfo(
    'British Airways',
    'BA',
    'https://www.gstatic.com/flights/airline_logos/70px/BA.png',
  ),
  _AirlineInfo(
    'Singapore Airlines',
    'SQ',
    'https://www.gstatic.com/flights/airline_logos/70px/SQ.png',
  ),
  _AirlineInfo(
    'Air France',
    'AF',
    'https://www.gstatic.com/flights/airline_logos/70px/AF.png',
  ),
  _AirlineInfo(
    'KLM',
    'KL',
    'https://www.gstatic.com/flights/airline_logos/70px/KL.png',
  ),
  _AirlineInfo(
    'Etihad Airways',
    'EY',
    'https://www.gstatic.com/flights/airline_logos/70px/EY.png',
  ),
];

class _AirlineInfo {
  final String name;
  final String code;
  final String logo;
  const _AirlineInfo(this.name, this.code, this.logo);
}

// ─── Hub airports used for layover generation ─────────────────────────────────
const _hubs = [
  ('DXB', 'Dubai International Airport'),
  ('DOH', 'Hamad International Airport'),
  ('IST', 'Istanbul Airport'),
  ('LHR', 'London Heathrow Airport'),
  ('CDG', 'Charles de Gaulle Airport'),
  ('AMS', 'Amsterdam Airport Schiphol'),
  ('FRA', 'Frankfurt Airport'),
  ('SIN', 'Singapore Changi Airport'),
  ('AUH', 'Abu Dhabi International Airport'),
  ('KUL', 'Kuala Lumpur International Airport'),
];

class FlightController extends GetxController {
  // ── Observable state ───────────────────────────────────────────────────────
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final hasSearched = false.obs;
  final activeFilterIndex = 0.obs;

  final RxList<FlightResult> bestFlights = <FlightResult>[].obs;
  final RxList<FlightResult> otherFlights = <FlightResult>[].obs;
  final RxList<FlightResult> displayedFlights = <FlightResult>[].obs;
  final Rx<PriceInsights?> priceInsights = Rx<PriceInsights?>(null);

  // ── Raw API debug log (shown in UI) ───────────────────────────────────────
  // Each entry: { 'ts': '11:54:03', 'label': '...', 'body': '...' }
  final RxList<Map<String, String>> apiLogs = <Map<String, String>>[].obs;

  FlightFilter get activeFilter => FlightFilter.values[activeFilterIndex.value];

  // ── Stored route for re-use ───────────────────────────────────────────────
  String _lastDep = '';
  String _lastArr = '';

  // ─────────────────────────────────────────────────────────────────────────
  // MAIN SEARCH
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> searchFlights({
    required String departure,
    required String arrival,
    String? date,
  }) async {
    _lastDep = departure;
    _lastArr = arrival;

    isLoading.value = true;
    hasError.value = false;
    hasSearched.value = false;
    apiLogs.clear();

    _addLog('REQUEST', 'GET ${AppUrl.flight}\nroute: $departure → $arrival');

    try {
      final response = await http.get(Uri.parse(AppUrl.flight));

      // ── Log raw response ─────────────────────────────────────────────────
      final apiResponse = response.body;
      _addLog(
        'RESPONSE [${response.statusCode}]',
        'Headers: ${response.headers.entries.take(4).map((e) => '${e.key}: ${e.value}').join(', ')}\n\n'
            'Body (first 800 chars):\n${apiResponse.length > 800 ? '${apiResponse.substring(0, 800)}…' : apiResponse}',
      );

      if (response.statusCode == 200) {
        /// decode the api response
        final decoded = json.decode(apiResponse) as Map<String, dynamic>;

        final parsed = FlightSearchResponse.fromJson(decoded);

        // Generate realistic flights FOR THE ACTUAL SELECTED ROUTE
        // using the mock API's structure/prices as a seed.
        final generated = _generateFlightsForRoute(
          departure: departure,
          arrival: arrival,
          seed: parsed,
        );

        _addLog(
          'ADAPTED',
          'Generated ${generated.best.length} best flights\n'
              'Generated ${generated.other.length} other flights\n'
              'All segments now show: $departure → $arrival',
        );

        bestFlights.assignAll(generated.best);
        otherFlights.assignAll(generated.other);
        priceInsights.value = parsed.priceInsights;

        _applyFilterInternal(FlightFilter.all);
        activeFilterIndex.value = 0;
        hasSearched.value = true;

        log(
          '✅ Flights ready: best=${bestFlights.length}, other=${otherFlights.length}',
        );
      } else {
        final msg = 'Server error ${response.statusCode}';
        _addLog('ERROR', msg);
        _setError(msg);
      }
    } catch (e, st) {
      final msg = 'Network error: $e';
      _addLog('ERROR', '$msg\n$st');
      _setError(msg);
      log('❌ Flight fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ({List<FlightResult> best, List<FlightResult> other})
  _generateFlightsForRoute({
    required String departure,
    required String arrival,
    required FlightSearchResponse seed,
  }) {
    final rng = math.Random(departure.hashCode ^ arrival.hashCode);

    // Pick airlines seeded by route so the same route always shows same airlines
    final shuffledAirlines = List<_AirlineInfo>.from(_airlines)..shuffle(rng);

    // Pick hub airports (exclude dep/arr themselves)
    final availableHubs =
        _hubs.where((h) => h.$1 != departure && h.$1 != arrival).toList()
          ..shuffle(rng);

    List<FlightResult> buildBatch(List<FlightResult> source, bool isBest) {
      return source.asMap().entries.map((entry) {
        final i = entry.key;
        final seedFlt = entry.value;
        final airline = shuffledAirlines[i % shuffledAirlines.length];
        final isNonstop = seedFlt.flights.length == 1;

        if (isNonstop) {
          return _buildNonstop(
            dep: departure,
            arr: arrival,
            airline: airline,
            flightNo: '${airline.code} ${100 + rng.nextInt(900)}',
            depTime: seedFlt.departureTime,
            arrTime: seedFlt.arrivalTime,
            duration: seedFlt.totalDuration,
            price: seedFlt.price,
            isBest: isBest,
          );
        } else {
          // 1-stop: use a hub airport
          final hub = availableHubs[i % availableHubs.length];
          return _buildOneStop(
            dep: departure,
            arr: arrival,
            hub: hub,
            airline: airline,
            flightNoA: '${airline.code} ${100 + rng.nextInt(900)}',
            flightNoB: '${airline.code} ${100 + rng.nextInt(900)}',
            seedFlt: seedFlt,
            price: seedFlt.price,
            isBest: isBest,
          );
        }
      }).toList();
    }

    return (
      best: buildBatch(seed.bestFlights, true),
      other: buildBatch(seed.otherFlights, false),
    );
  }

  FlightResult _buildNonstop({
    required String dep,
    required String arr,
    required _AirlineInfo airline,
    required String flightNo,
    required String depTime,
    required String arrTime,
    required int duration,
    required int price,
    required bool isBest,
  }) {
    final segment = FlightSegment(
      departureAirport: FlightAirport(name: dep, id: dep, time: depTime),
      arrivalAirport: FlightAirport(name: arr, id: arr, time: arrTime),
      duration: duration,
      airplane: 'Boeing 737',
      airline: airline.name,
      airlineLogo: airline.logo,
      travelClass: 'Economy',
      flightNumber: flightNo,
      legroom: '30 in',
      extensions: ['Average legroom (30 in)', 'On-demand video'],
      overnight: false,
    );
    return FlightResult(
      flights: [segment],
      layovers: [],
      totalDuration: duration,
      price: price,
      type: 'One way',
      airlineLogo: airline.logo,
      isBestFlight: isBest,
    );
  }

  FlightResult _buildOneStop({
    required String dep,
    required String arr,
    required (String, String) hub,
    required _AirlineInfo airline,
    required String flightNoA,
    required String flightNoB,
    required FlightResult seedFlt,
    required int price,
    required bool isBest,
  }) {
    // Split total duration roughly 60/40 between leg A and leg B
    final legA = (seedFlt.totalDuration * 0.45).round();
    final layMin = seedFlt.layovers.isNotEmpty
        ? seedFlt.layovers.first.duration
        : 90;
    final legB = seedFlt.totalDuration - legA - layMin;

    // Parse departure time from seedFlt and compute arrival times
    final depTime = seedFlt.departureTime; // e.g. "2026-06-18 08:10"
    final hubArrTime = _addMinutes(depTime, legA);
    final hubDepTime = _addMinutes(hubArrTime, layMin);
    final finalArr = _addMinutes(hubDepTime, legB);

    final segA = FlightSegment(
      departureAirport: FlightAirport(name: dep, id: dep, time: depTime),
      arrivalAirport: FlightAirport(name: hub.$2, id: hub.$1, time: hubArrTime),
      duration: legA,
      airplane: 'Boeing 777',
      airline: airline.name,
      airlineLogo: airline.logo,
      travelClass: 'Economy',
      flightNumber: flightNoA,
      legroom: '31 in',
      extensions: ['Average legroom (31 in)', 'In-seat power & USB outlets'],
      overnight: false,
    );
    final segB = FlightSegment(
      departureAirport: FlightAirport(
        name: hub.$2,
        id: hub.$1,
        time: hubDepTime,
      ),
      arrivalAirport: FlightAirport(name: arr, id: arr, time: finalArr),
      duration: legB,
      airplane: 'Airbus A320',
      airline: airline.name,
      airlineLogo: airline.logo,
      travelClass: 'Economy',
      flightNumber: flightNoB,
      legroom: '30 in',
      extensions: ['Average legroom (30 in)', 'On-demand video'],
      overnight: false,
    );
    final layover = Layover(duration: layMin, name: hub.$2, id: hub.$1);
    return FlightResult(
      flights: [segA, segB],
      layovers: [layover],
      totalDuration: seedFlt.totalDuration,
      price: price,
      type: 'One way',
      airlineLogo: airline.logo,
      isBestFlight: isBest,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FILTER
  // ─────────────────────────────────────────────────────────────────────────
  void applyFilter(FlightFilter filter) {
    activeFilterIndex.value = filter.index;
    _applyFilterInternal(filter);
  }

  void _applyFilterInternal(FlightFilter filter) {
    final all = [...bestFlights, ...otherFlights];
    switch (filter) {
      case FlightFilter.all:
        displayedFlights.assignAll(all);
        break;
      case FlightFilter.best:
        final best = all.where((f) => f.isBestFlight).toList();
        displayedFlights.assignAll(best.isNotEmpty ? best : all);
        break;
      case FlightFilter.cheapest:
        displayedFlights.assignAll(
          List<FlightResult>.from(all)
            ..sort((a, b) => a.price.compareTo(b.price)),
        );
        break;
      case FlightFilter.fastest:
        displayedFlights.assignAll(
          List<FlightResult>.from(all)
            ..sort((a, b) => a.totalDuration.compareTo(b.totalDuration)),
        );
        break;
    }
  }

  void clearResults() {
    bestFlights.clear();
    otherFlights.clear();
    displayedFlights.clear();
    hasSearched.value = false;
    hasError.value = false;
    activeFilterIndex.value = 0;
    apiLogs.clear();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────
  void _setError(String msg) {
    hasError.value = true;
    errorMessage.value = msg;
  }

  void _addLog(String label, String body) {
    final now = DateTime.now();
    final ts =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    apiLogs.add({'ts': ts, 'label': label, 'body': body});
    log('[$label] $body');
  }

  String _extractRawRoute(Map<String, dynamic> json, String key) {
    try {
      final airports = json['airports'] as List?;
      if (airports == null || airports.isEmpty) return 'unknown';
      final first = airports.first as Map?;
      if (first == null) return 'unknown';
      final list = first[key] as List?;
      if (list == null || list.isEmpty) return 'unknown';
      final entry = list.first as Map?;
      final city = entry?['city'] ?? '';
      final code = (entry?['airport'] as Map?)?['id'] ?? '';
      return '$city ($code)';
    } catch (_) {
      return 'parse error';
    }
  }

  /// Adds [minutes] to a datetime string like "2026-06-18 08:10"
  /// and returns the same format.
  String _addMinutes(String dateTime, int minutes) {
    try {
      final parts = dateTime.split(' ');
      if (parts.length < 2) return dateTime;
      final timeParts = parts[1].split(':');
      final h = int.parse(timeParts[0]);
      final m = int.parse(timeParts[1]);
      final total = h * 60 + m + minutes;
      final newH = (total ~/ 60) % 24;
      final newM = total % 60;
      return '${parts[0]} ${newH.toString().padLeft(2, '0')}:${newM.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateTime;
    }
  }

  int get lowestPrice {
    if (displayedFlights.isEmpty) return 0;
    return displayedFlights.map((f) => f.price).reduce((a, b) => a < b ? a : b);
  }
}
