import 'dart:developer';
import 'package:flight_app/core/services/network_caller.dart';
import 'package:flight_app/core/utils/contants/app_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/airport_data.dart';

class AirportController extends GetxController {
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  /// network caller represent the class of api calling structure
  /// it prevent repeated import and called http functions.
  final NetworkCaller networkCaller = NetworkCaller();

  /// list of airport
  final RxList<Airport> allAirports = <Airport>[].obs;
  final RxList<Airport> filteredAirports = <Airport>[].obs;

  final Rx<Airport?> departureAirport = Rx<Airport?>(null);
  final Rx<Airport?> arrivalAirport = Rx<Airport?>(null);

  /// variable for searching
  RxString searchText = ''.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    getAirPortList();
    searchController.addListener(_onSearchChanged);
    clearSearch();
  }

  static const tips = [
    (Icons.swap_vert_rounded, 'Tap the swap icon to quickly reverse routes'),
    (Icons.search_rounded, 'Search airports by name, city, or IATA code'),
    (Icons.bolt_rounded, 'Fastest tab finds the quickest travel option'),
  ];

  /// fetch airport
  Future<void> getAirPortList() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      var response = await networkCaller.getRequest(AppUrl.getAllAirportData);
      if (response.isSuccess) {
        final parsed = airportResponseFromJson(response.responseData);
        final sorted = parsed.airports
          ..sort((a, b) => a.airportName.compareTo(b.airportName));
        allAirports.assignAll(sorted);
        filteredAirports.assignAll(sorted);
      }
    } catch (e) {
      log("The exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Search
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

  /// selection section
  void selectAsDeparture(Airport airport) {
    departureAirport.value = airport;
    Get.back();
  }

  void selectAsArrival(Airport airport) {
    arrivalAirport.value = airport;
    Get.back();
  }

  /// airport swap function

  void swapAirports() {
    final temp = departureAirport.value;
    departureAirport.value = arrivalAirport.value;
    arrivalAirport.value = temp;
  }

  void clearDeparture() => departureAirport.value = null;
  void clearArrival() => arrivalAirport.value = null;

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.clear();
    super.onClose();
  }
}
