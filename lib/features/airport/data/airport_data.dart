import 'dart:convert';

// ─── Top-level parse helper ───────────────────────────────────────────────────
AirportResponse airportResponseFromJson(String str) =>
    AirportResponse.fromJson(json.decode(str));

// ─── Root response ────────────────────────────────────────────────────────────
class AirportResponse {
  final String jsonFileType;
  final int totalData;
  final Map<String, Airport> data;

  AirportResponse({
    required this.jsonFileType,
    required this.totalData,
    required this.data,
  });

  factory AirportResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>? ?? {};
    final airports = rawData.map(
          (key, value) => MapEntry(key, Airport.fromJson(value)),
    );
    return AirportResponse(
      jsonFileType: json['json_file_type'] ?? '',
      totalData: json['total_data'] ?? 0,
      data: airports,
    );
  }

  List<Airport> get airports => data.values.toList();
}

// ─── Airport model ────────────────────────────────────────────────────────────
class Airport {
  final String code;
  final String airportName;
  final String airportCity;
  final String airportCityCode;
  final String airportCountry;
  final String airportCountryCode;
  final String? airportTimezone;

  Airport({
    required this.code,
    required this.airportName,
    required this.airportCity,
    required this.airportCityCode,
    required this.airportCountry,
    required this.airportCountryCode,
    this.airportTimezone,
  });

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
    code: json['code'] ?? '',
    airportName: json['airport_name'] ?? '',
    airportCity: json['airport_city'] ?? '',
    airportCityCode: json['airport_city_code'] ?? '',
    airportCountry: json['airport_country'] ?? '',
    airportCountryCode: json['airport_country_code'] ?? '',
    airportTimezone: json['airport_timezone'],
  );

  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return airportName.toLowerCase().contains(q) ||
        code.toLowerCase().contains(q) ||
        airportCity.toLowerCase().contains(q);
  }

  @override
  String toString() => '$airportName ($code)';
}