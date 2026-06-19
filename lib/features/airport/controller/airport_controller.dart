import 'dart:developer';
import 'package:flight_app/core/services/network_caller.dart';
import 'package:flight_app/core/utils/contants/app_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/airport_data.dart';



class AirportController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final NetworkCaller networkCaller = NetworkCaller();

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
    ///fetchAirports();
    getAirPortList();
    searchController.addListener(_onSearchChanged);
    clearSearch();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.clear();
    super.onClose();
  }

  static const tips = [
    (Icons.swap_vert_rounded, 'Tap the swap icon to quickly reverse routes'),
    (Icons.search_rounded, 'Search airports by name, city, or IATA code'),
    (Icons.bolt_rounded, 'Fastest tab finds the quickest travel option'),
  ];



  /// fetch airport
   Future<void> getAirPortList()async{
    isLoading.value = true;
    hasError.value = false;
    try{
      var response = await networkCaller.getRequest(AppUrl.getAllAirportData);
      if(response.isSuccess){
        final parsed = airportResponseFromJson(response.responseData);
        final sorted = parsed.airports
          ..sort((a, b) => a.airportName.compareTo(b.airportName));
        allAirports.assignAll(sorted);
        filteredAirports.assignAll(sorted);

      }

    }
    catch(e){
      log("The exception is ${e.toString()}");
    }
    finally{
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