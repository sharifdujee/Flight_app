/*
import 'dart:convert';

FlightInformation flightInformationFromJson(String str) =>
    FlightInformation.fromJson(json.decode(str));

class FlightInformation {
  final List<BestFlight> bestFlights;
  final List<BestFlight> otherFlights;
  final PriceInsights? priceInsights;

  FlightInformation({
    required this.bestFlights,
    required this.otherFlights,
    this.priceInsights,
  });

  factory FlightInformation.fromJson(Map<String, dynamic> json) =>
      FlightInformation(
        bestFlights: (json["best_flights"] as List? ?? [])
            .map((e) => BestFlight.fromJson(e))
            .toList(),
        otherFlights: (json["other_flights"] as List? ?? [])
            .map((e) => BestFlight.fromJson(e))
            .toList(),
        priceInsights: json["price_insights"] != null
            ? PriceInsights.fromJson(json["price_insights"])
            : null,
      );
}

class BestFlight {
  final List<FlightLeg> flights;
  final List<Layover> layovers;
  final int totalDuration;
  final int price;
  final String type;
  final String airlineLogo;
  final CarbonEmissions? carbonEmissions;  // ← NEW

  BestFlight({
    required this.flights,
    required this.layovers,
    required this.totalDuration,
    required this.price,
    required this.type,
    required this.airlineLogo,
    this.carbonEmissions,                  // ← NEW
  });

  factory BestFlight.fromJson(Map<String, dynamic> json) => BestFlight(
    flights: (json["flights"] as List? ?? [])
        .map((e) => FlightLeg.fromJson(e))
        .toList(),
    layovers: (json["layovers"] as List? ?? [])
        .map((e) => Layover.fromJson(e))
        .toList(),
    totalDuration: json["total_duration"] ?? 0,
    price: json["price"] ?? 0,
    type: json["type"] ?? '',
    airlineLogo: json["airline_logo"] ?? '',
    carbonEmissions: json["carbon_emissions"] != null  // ← NEW
        ? CarbonEmissions.fromJson(json["carbon_emissions"])
        : null,
  );

  // Convenience getters
  String get departureTime =>
      flights.isNotEmpty ? flights.first.departureAirport.time : '';
  String get arrivalTime =>
      flights.isNotEmpty ? flights.last.arrivalAirport.time : '';
  String get fromCode =>
      flights.isNotEmpty ? flights.first.departureAirport.id : '';
  String get toCode =>
      flights.isNotEmpty ? flights.last.arrivalAirport.id : '';
  String get airline => flights.isNotEmpty ? flights.first.airline : '';
  bool get hasLayover => layovers.isNotEmpty;

  // Carbon convenience getters
  String get carbonKg =>
      '${((carbonEmissions?.thisFlight ?? 0) / 1000).round()} kg CO₂';
  String get carbonDiffLabel {
    final diff = carbonEmissions?.differencePercent ?? 0;
    return diff < 0 ? '$diff%' : '+$diff%';
  }
  bool get isLowCarbon => (carbonEmissions?.differencePercent ?? 0) < 0;
}

class FlightLeg {
  final Airport departureAirport;
  final Airport arrivalAirport;
  final int duration;
  final String airplane;
  final String airline;
  final String airlineLogo;
  final String travelClass;
  final String flightNumber;
  final String legroom;
  final List<String> extensions;  // ← NEW
  final bool overnight;           // ← NEW

  FlightLeg({
    required this.departureAirport,
    required this.arrivalAirport,
    required this.duration,
    required this.airplane,
    required this.airline,
    required this.airlineLogo,
    required this.travelClass,
    required this.flightNumber,
    required this.legroom,
    required this.extensions,     // ← NEW
    required this.overnight,      // ← NEW
  });

  factory FlightLeg.fromJson(Map<String, dynamic> json) => FlightLeg(
    departureAirport: Airport.fromJson(json["departure_airport"] ?? {}),
    arrivalAirport: Airport.fromJson(json["arrival_airport"] ?? {}),
    duration: json["duration"] ?? 0,
    airplane: json["airplane"] ?? '',
    airline: json["airline"] ?? '',
    airlineLogo: json["airline_logo"] ?? '',
    travelClass: json["travel_class"] ?? '',
    flightNumber: json["flight_number"] ?? '',
    legroom: json["legroom"] ?? '',
    extensions: List<String>.from(json["extensions"] ?? []),  // ← NEW
    overnight: json["overnight"] ?? false,                    // ← NEW
  );

  // Convenience getter
  String get formattedDuration {
    final h = duration ~/ 60;
    final m = duration % 60;
    return '${h}h ${m}m';
  }
}

class Airport {
  final String name;
  final String id;
  final String time;

  Airport({
    required this.name,
    required this.id,
    required this.time,
  });

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
    name: json["name"] ?? '',
    id: json["id"] ?? '',
    time: json["time"] ?? '',
  );

  // Convenience getter — returns "8:10 AM" from "2026-06-18 08:10"
  String get formattedTime {
    if (time.isEmpty) return '--';
    final parts = time.split(' ');
    if (parts.length < 2) return time;
    final timeParts = parts[1].split(':');
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final min = timeParts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$h:$min $period';
  }
}

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
    duration: json["duration"] ?? 0,
    name: json["name"] ?? '',
    id: json["id"] ?? '',
  );

  String get formattedDuration {
    final h = duration ~/ 60;
    final m = duration % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

class CarbonEmissions {
  final int thisFlight;
  final int typicalForThisRoute;
  final int differencePercent;

  CarbonEmissions({
    required this.thisFlight,
    required this.typicalForThisRoute,
    required this.differencePercent,
  });

  factory CarbonEmissions.fromJson(Map<String, dynamic> json) =>
      CarbonEmissions(
        thisFlight: json["this_flight"] ?? 0,
        typicalForThisRoute: json["typical_for_this_route"] ?? 0,
        differencePercent: json["difference_percent"] ?? 0,
      );
}

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
    lowestPrice: json["lowest_price"] ?? 0,
    priceLevel: json["price_level"] ?? '',
    typicalPriceRange: List<int>.from(json["typical_price_range"] ?? []),
  );
}*/
