import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flight_app/core/services/network_caller.dart';
import 'package:flight_app/core/utils/contants/app_url.dart';
import 'package:flight_app/features/flight/data/flight_dummy_data.dart';
import 'package:get/get.dart';

import '../data/flight_data.dart';

enum FlightFilter { all, fastest }

class FlightController extends GetxController {
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final hasSearched = false.obs;
  final activeFilterIndex = 0.obs;

  final RxList<FlightResult> bestFlights = <FlightResult>[].obs;
  final RxList<FlightResult> otherFlights = <FlightResult>[].obs;
  final RxList<FlightResult> displayedFlights = <FlightResult>[].obs;
  final Rx<PriceInsights?> priceInsights = Rx<PriceInsights?>(null);

  final RxList<Map<String, String>> apiLogs = <Map<String, String>>[].obs;

  FlightFilter get activeFilter => FlightFilter.values[activeFilterIndex.value];
  final NetworkCaller networkCaller = NetworkCaller();

  String _lastDep = '';
  String _lastArr = '';
  String _lastDate = '';

  final RxSet<int> expandedCardIndices = <int>{}.obs;

  bool isCardExpanded(int index) => expandedCardIndices.contains(index);

  void toggleCardExpanded(int index) {
    if (expandedCardIndices.contains(index)) {
      expandedCardIndices.remove(index);
    } else {
      expandedCardIndices.add(index);
    }
  }

  Future<void> searchFlights({
    required String departure,
    required String arrival,
    required String outboundDate,
  }) async {
    _lastDep = departure;
    _lastArr = arrival;
    _lastDate = outboundDate;

    isLoading.value = true;
    hasError.value = false;
    hasSearched.value = false;
    apiLogs.clear();

/// use query param


    final uri = Uri.parse(AppUrl.flight).replace(
      queryParameters: {
        ...Uri.parse(AppUrl.flight).queryParameters,
        'departure_id': departure,
        'arrival_id': arrival,
        'outbound_date': outboundDate,
        'currency': "USD"
      }
    );




    try {
      final response = await networkCaller.getRequest(uri.toString());

      final rawResponse = response.responseData;

      if (response.statusCode == 200) {
        final decoded = json.decode(rawResponse) as Map<String, dynamic>;

        final parsed = FlightSearchResponse.fromJson(decoded);

        final generated = _generateFlightsForRoute(
          departure: departure,
          arrival: arrival,
          date: outboundDate,
          seed: parsed,
        );

        bestFlights.assignAll(generated.best);
        otherFlights.assignAll(generated.other);
        priceInsights.value = parsed.priceInsights;

        _applyFilterInternal(FlightFilter.all);
        activeFilterIndex.value = 0;
        hasSearched.value = true;

        log(
          'Flights ready: best=${bestFlights.length}, other=${otherFlights.length}',
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

  /// Re-runs the last search (departure/arrival/date) — handy for retry buttons.
  Future<void> retryLastSearch() async {
    if (_lastDep.isEmpty || _lastArr.isEmpty || _lastDate.isEmpty) return;
    await searchFlights(
      departure: _lastDep,
      arrival: _lastArr,
      outboundDate: _lastDate,
    );
  }

  ({List<FlightResult> best, List<FlightResult> other})
  _generateFlightsForRoute({
    required String departure,
    required String arrival,
    required String date,
    required FlightSearchResponse seed,
  }) {
    final rng = math.Random(departure.hashCode ^ arrival.hashCode ^ date.hashCode);

    final shuffledAirlines = List<AirlineInfo>.from(airlines)..shuffle(rng);

    final availableHubs =
    hubs.where((h) => h.$1 != departure && h.$1 != arrival).toList()
      ..shuffle(rng);

    List<FlightResult> buildBatch(List<FlightResult> source, bool isBest) {
      return source.asMap().entries.map((entry) {
        final i = entry.key;
        final seedFlt = entry.value;
        final airline = shuffledAirlines[i % shuffledAirlines.length];
        final isNonstop = seedFlt.flights.length == 1;

        final depTime = _restampDate(seedFlt.departureTime, date);
        final arrTime = _restampDate(seedFlt.arrivalTime, date);

        if (isNonstop) {
          return _buildNonstop(
            dep: departure,
            arr: arrival,
            airline: airline,
            flightNo: '${airline.code} ${100 + rng.nextInt(900)}',
            depTime: depTime,
            arrTime: arrTime,
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
            date: date,
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
    required AirlineInfo airline,
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
    final emissions = _estimateEmissionsKg(duration, 0);
    return FlightResult(
      flights: [segment],
      layovers: [],
      totalDuration: duration,
      price: price,
      type: 'One way',
      airlineLogo: airline.logo,
      isBestFlight: isBest,
      carbonEmissionKg: emissions,
      emissionsPercentDiff: _estimateEmissionsDiffPercent(emissions, duration),
    );
  }

  FlightResult _buildOneStop({
    required String dep,
    required String arr,
    required (String, String) hub,
    required AirlineInfo airline,
    required String flightNoA,
    required String flightNoB,
    required FlightResult seedFlt,
    required String date,
    required int price,
    required bool isBest,
  }) {
    // Split total duration roughly 60/40 between leg A and leg B
    final legA = (seedFlt.totalDuration * 0.45).round();
    final layMin = seedFlt.layovers.isNotEmpty
        ? seedFlt.layovers.first.duration
        : 90;
    final legB = seedFlt.totalDuration - legA - layMin;

    // Use the user-selected date, keep the seed's time-of-day
    final depTime = _restampDate(seedFlt.departureTime, date);
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
    final emissions = _estimateEmissionsKg(seedFlt.totalDuration, 1);
    return FlightResult(
      flights: [segA, segB],
      layovers: [layover],
      totalDuration: seedFlt.totalDuration,
      price: price,
      type: 'One way',
      airlineLogo: airline.logo,
      isBestFlight: isBest,
      carbonEmissionKg: emissions,
      emissionsPercentDiff: _estimateEmissionsDiffPercent(
        emissions,
        seedFlt.totalDuration,
      ),
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



  /// Replaces the date portion of a "yyyy-MM-dd HH:mm" string with
  /// [newDate] (also "yyyy-MM-dd"), keeping the original time-of-day.
  String _restampDate(String dateTime, String newDate) {
    try {
      final parts = dateTime.split(' ');
      if (parts.length < 2) return dateTime;
      return '$newDate ${parts[1]}';
    } catch (_) {
      return dateTime;
    }
  }

  /// Adds [minutes] to a datetime string like "2026-06-18 08:10"
  /// and returns the same format. Rolls over to the next day if needed.
  String _addMinutes(String dateTime, int minutes) {
    try {
      final parts = dateTime.split(' ');
      if (parts.length < 2) return dateTime;
      final datePart = parts[0];
      final timeParts = parts[1].split(':');
      final h = int.parse(timeParts[0]);
      final m = int.parse(timeParts[1]);

      final base = DateTime.parse(datePart);
      final result = DateTime(base.year, base.month, base.day, h, m)
          .add(Duration(minutes: minutes));

      final y = result.year.toString().padLeft(4, '0');
      final mo = result.month.toString().padLeft(2, '0');
      final d = result.day.toString().padLeft(2, '0');
      final newH = result.hour.toString().padLeft(2, '0');
      final newM = result.minute.toString().padLeft(2, '0');
      return '$y-$mo-$d $newH:$newM';
    } catch (_) {
      return dateTime;
    }
  }

  int get lowestPrice {
    if (displayedFlights.isEmpty) return 0;
    return displayedFlights.map((f) => f.price).reduce((a, b) => a < b ? a : b);
  }

  /// Rough mock CO2 estimate for the card UI: ~47kg per hour of flight time,
  /// plus a small overhead per stop for the extra takeoff/landing cycle.
  /// This is illustrative only — the underlying API has no real emissions data.
  int _estimateEmissionsKg(int durationMinutes, int stops) {
    final hours = durationMinutes / 60;
    final base = hours * 47;
    final stopOverhead = stops * 18;
    return (base + stopOverhead).round();
  }

  /// Percent difference vs a "typical" route average (61kg/hr baseline).
  /// Negative = below typical (greener), positive = above typical.
  int _estimateEmissionsDiffPercent(int emissionsKg, int durationMinutes) {
    final hours = durationMinutes / 60;
    final typical = (hours * 61).round();
    if (typical <= 0) return 0;
    return (((emissionsKg - typical) / typical) * 100).round();
  }
}