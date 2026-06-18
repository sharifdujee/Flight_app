/*
import 'dart:developer';
import 'package:flight_app/core/utils/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/flight_data.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  RxList<BestFlight> bestFlights = <BestFlight>[].obs;
  RxList<BestFlight> otherFlights = <BestFlight>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllFlightData();
  }

  Future<void> getAllFlightData() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(AppUrl.getAllFlightData));

      if (response.statusCode == 200) {
        print("The All Flight Information is ${response.body}");
        final flightInfo = flightInformationFromJson(response.body);
        bestFlights.assignAll(flightInfo.bestFlights);
        otherFlights.assignAll(flightInfo.otherFlights);
        log("Best Flights: ${bestFlights.length}");
        log("Other Flights: ${otherFlights.length}");
      }
    } catch (e) {
      log("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

*/
