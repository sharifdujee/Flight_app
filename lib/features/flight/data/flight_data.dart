import 'dart:convert';

// ─── Parse helpers ────────────────────────────────────────────────────────────
FlightSearchResponse flightSearchResponseFromJson(String str) =>
    FlightSearchResponse.fromJson(json.decode(str));

// ─── Root response ────────────────────────────────────────────────────────────
class FlightSearchResponse {
  final List<FlightResult> bestFlights;
  final List<FlightResult> otherFlights;
  final PriceInsights? priceInsights;

  FlightSearchResponse({
    required this.bestFlights,
    required this.otherFlights,
    this.priceInsights,
  });

  factory FlightSearchResponse.fromJson(Map<String, dynamic> json) {
    return FlightSearchResponse(
      bestFlights: (json['best_flights'] as List<dynamic>? ?? [])
          .map((e) => FlightResult.fromJson(e))
          .toList(),
      otherFlights: (json['other_flights'] as List<dynamic>? ?? [])
          .map((e) => FlightResult.fromJson(e))
          .toList(),
      priceInsights: json['price_insights'] != null
          ? PriceInsights.fromJson(json['price_insights'])
          : null,
    );
  }

  List<FlightResult> get allFlights => [...bestFlights, ...otherFlights];
}

// ─── Single flight result (may have multiple segments + layovers) ─────────────
class FlightResult {
  final List<FlightSegment> flights;
  final List<Layover> layovers;
  final int totalDuration;
  final int price;
  final String type;
  final String airlineLogo;
  final bool isBestFlight;

  /// Mock CO2 estimate in kg for the whole trip (used by the result card UI).
  final int carbonEmissionKg;

  /// Percent difference vs a "typical" emissions baseline for the route.
  /// Negative = below typical (greener), positive = above typical.
  final int emissionsPercentDiff;

  FlightResult({
    required this.flights,
    required this.layovers,
    required this.totalDuration,
    required this.price,
    required this.type,
    required this.airlineLogo,
    this.isBestFlight = false,
    this.carbonEmissionKg = 0,
    this.emissionsPercentDiff = 0,
  });

  factory FlightResult.fromJson(Map<String, dynamic> json,
      {bool isBest = false}) {
    return FlightResult(
      flights: (json['flights'] as List<dynamic>? ?? [])
          .map((e) => FlightSegment.fromJson(e))
          .toList(),
      layovers: (json['layovers'] as List<dynamic>? ?? [])
          .map((e) => Layover.fromJson(e))
          .toList(),
      totalDuration: json['total_duration'] ?? 0,
      price: json['price'] ?? 0,
      type: json['type'] ?? 'One way',
      airlineLogo: json['airline_logo'] ?? '',
      isBestFlight: isBest,
      carbonEmissionKg: json['carbon_emission_kg'] ?? 0,
      emissionsPercentDiff: json['emissions_percent_diff'] ?? 0,
    );
  }

  /// First segment departure time
  String get departureTime =>
      flights.isNotEmpty ? flights.first.departureAirport.time : '';

  /// Last segment arrival time
  String get arrivalTime =>
      flights.isNotEmpty ? flights.last.arrivalAirport.time : '';

  /// Departure airport code
  String get departureCode =>
      flights.isNotEmpty ? flights.first.departureAirport.id : '';

  /// Arrival airport code
  String get arrivalCode =>
      flights.isNotEmpty ? flights.last.arrivalAirport.id : '';

  /// Primary airline name (first segment)
  String get airlineName =>
      flights.isNotEmpty ? flights.first.airline : '';

  /// Number of stops
  int get stops => flights.length - 1;

  /// Stop label
  String get stopsLabel {
    if (stops == 0) return 'Nonstop';
    if (stops == 1) return '1 stop';
    return '$stops stops';
  }

  /// Duration formatted as "5h 5m"
  String get durationFormatted {
    final h = totalDuration ~/ 60;
    final m = totalDuration % 60;
    return '${h}h ${m}m';
  }

  /// Human-readable departure time "HH:mm"
  String get departureTimeFormatted => _formatTime(departureTime);

  /// Human-readable arrival time "HH:mm"
  String get arrivalTimeFormatted => _formatTime(arrivalTime);

  /// Date label for card headers, e.g. "Thu, Jun 18"
  String get dateLabel => _formatDateLabel(departureTime);

  /// Check if flight goes overnight (arrives next day)
  bool get isOvernight {
    if (flights.isEmpty) return false;
    return flights.any((f) => f.overnight == true);
  }

  String _formatTime(String dateTime) {
    if (dateTime.isEmpty) return '';
    final parts = dateTime.split(' ');
    if (parts.length < 2) return dateTime;
    return parts[1];
  }

  String _formatDateLabel(String dateTime) {
    if (dateTime.isEmpty) return '';
    try {
      final iso = dateTime.contains('T') ? dateTime : dateTime.replaceFirst(' ', 'T');
      final dt = DateTime.parse(iso);
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final wd = weekdays[dt.weekday - 1];
      final mo = months[dt.month - 1];
      return '$wd, $mo ${dt.day}';
    } catch (_) {
      return '';
    }
  }
}

// ─── Single flight segment ────────────────────────────────────────────────────
class FlightSegment {
  final FlightAirport departureAirport;
  final FlightAirport arrivalAirport;
  final int duration;
  final String airplane;
  final String airline;
  final String airlineLogo;
  final String travelClass;
  final String flightNumber;
  final String? legroom;
  final List<String> extensions;
  final bool overnight;

  FlightSegment({
    required this.departureAirport,
    required this.arrivalAirport,
    required this.duration,
    required this.airplane,
    required this.airline,
    required this.airlineLogo,
    required this.travelClass,
    required this.flightNumber,
    this.legroom,
    required this.extensions,
    this.overnight = false,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      departureAirport:
      FlightAirport.fromJson(json['departure_airport'] ?? {}),
      arrivalAirport: FlightAirport.fromJson(json['arrival_airport'] ?? {}),
      duration: json['duration'] ?? 0,
      airplane: json['airplane'] ?? '',
      airline: json['airline'] ?? '',
      airlineLogo: json['airline_logo'] ?? '',
      travelClass: json['travel_class'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      legroom: json['legroom'],
      extensions: List<String>.from(json['extensions'] ?? []),
      overnight: json['overnight'] ?? false,
    );
  }

  String get durationFormatted {
    final h = duration ~/ 60;
    final m = duration % 60;
    return '${h}h ${m}m';
  }
}

// ─── Airport reference inside flight ─────────────────────────────────────────
class FlightAirport {
  final String name;
  final String id;
  final String time;

  FlightAirport({
    required this.name,
    required this.id,
    required this.time,
  });

  factory FlightAirport.fromJson(Map<String, dynamic> json) => FlightAirport(
    name: json['name'] ?? '',
    id: json['id'] ?? '',
    time: json['time'] ?? '',
  );

  String get timeFormatted {
    if (time.isEmpty) return '';
    final parts = time.split(' ');
    return parts.length >= 2 ? parts[1] : time;
  }
}

// ─── Layover ──────────────────────────────────────────────────────────────────
class Layover {
  final int duration;
  final String name;
  final String id;

  Layover({
    required this.duration,
    required this.name,
    required this.id,
  });

  factory Layover.fromJson(Map<String, dynamic> json) => Layover(
    duration: json['duration'] ?? 0,
    name: json['name'] ?? '',
    id: json['id'] ?? '',
  );

  String get durationFormatted {
    final h = duration ~/ 60;
    final m = duration % 60;
    if (h == 0) return '${m}m layover';
    if (m == 0) return '${h}h layover';
    return '${h}h ${m}m layover';
  }
}

// ─── Price insights ───────────────────────────────────────────────────────────
class PriceInsights {
  final int lowestPrice;
  final String priceLevel;
  final List<int> typicalPriceRange;

  PriceInsights({
    required this.lowestPrice,
    required this.priceLevel,
    required this.typicalPriceRange,
  });

  factory PriceInsights.fromJson(Map<String, dynamic> json) => PriceInsights(
    lowestPrice: json['lowest_price'] ?? 0,
    priceLevel: json['price_level'] ?? '',
    typicalPriceRange:
    List<int>.from(json['typical_price_range'] ?? []),
  );
}