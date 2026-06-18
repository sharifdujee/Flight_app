import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/airport_data.dart';

const _airportApiUrl =
    'https://innotraveltech.mynetworkfiles.org/profile_picture/1320260617T182840_YCcqOAKb.json';

class AirportController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final RxList<Airport> allAirports = <Airport>[].obs;
  final RxList<Airport> filteredAirports = <Airport>[].obs;

  final Rx<Airport?> departureAirport = Rx<Airport?>(null);
  final Rx<Airport?> arrivalAirport = Rx<Airport?>(null);

  // ── Search ─────────────────────────────────────────────────────────────────
  final searchText = ''.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAirports();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  // ── API ────────────────────────────────────────────────────────────────────
  Future<void> fetchAirports() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await http.get(Uri.parse(_airportApiUrl));
      if (response.statusCode == 200) {
        final parsed = airportResponseFromJson(response.body);
        final sorted = parsed.airports
          ..sort((a, b) => a.airportName.compareTo(b.airportName));
        allAirports.assignAll(sorted);
        filteredAirports.assignAll(sorted);
        log('Airports loaded: ${allAirports.length}');
      } else {
        _setError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Failed to load airports: $e');
      log('Airport fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  void _onSearchChanged() {
    final query = searchController.text.trim();
    searchText.value = searchController.text;
    if (query.isEmpty) {
      filteredAirports.assignAll(allAirports);
    } else {
      filteredAirports.assignAll(
        allAirports.where((a) => a.matchesQuery(query)).toList(),
      );
    }
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    filteredAirports.assignAll(allAirports);
  }

  // ── Selection ──────────────────────────────────────────────────────────────
  void selectAsDeparture(Airport airport) {
    departureAirport.value = airport;
    Get.back();
  }

  void selectAsArrival(Airport airport) {
    arrivalAirport.value = airport;
    Get.back();
  }

  void swapAirports() {
    final temp = departureAirport.value;
    departureAirport.value = arrivalAirport.value;
    arrivalAirport.value = temp;
  }

  void clearDeparture() => departureAirport.value = null;
  void clearArrival() => arrivalAirport.value = null;

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _setError(String msg) {
    hasError.value = true;
    errorMessage.value = msg;
  }
}