import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../airport/data/airport_data.dart';
import '../controller/flight_controller.dart';
import '../presentation/widget/empty_flight_card.dart';
import '../presentation/widget/flight_error_view.dart';
import '../presentation/widget/flight_filter_tab_bar.dart';
import '../presentation/widget/flight_list.dart';
import '../presentation/widget/flight_loading_indicator.dart';
import '../presentation/widget/flight_route_header.dart';

class FlightResultsScreen extends StatelessWidget {
   FlightResultsScreen({
    super.key,


  });

  final Airport departure = Get.arguments['departure'];
  final Airport arrival = Get.arguments['arrival'];
  final DateTime outboundDate = Get.arguments['date'];

  void _onFilterChanged(FlightController ctrl, int index) {
    ctrl.applyFilter(FlightFilter.values[index]);
  }

  String get _formattedDate => DateFormat('yyyy-MM-dd').format(outboundDate);

  void _search(FlightController ctrl) {
    ctrl.searchFlights(
      departure: departure.code,
      arrival: arrival.code,
      outboundDate: _formattedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final FlightController ctrl = Get.find();

    // Trigger search once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _search(ctrl);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: FlightRouteHeader(departure: departure, arrival: arrival),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Obx(() {
                  if (!ctrl.hasSearched.value && !ctrl.isLoading.value) {
                    return const SizedBox.shrink();
                  }
                  return FlightFilterBar(
                    active: ctrl.activeFilterIndex.value,
                    onChanged: (index) => _onFilterChanged(ctrl, index),
                  );
                }),
              ),
            ),
          ),
        ],
        body: Obx(() {
          if (ctrl.isLoading.value) {
            return const FlightLoadingWidget();
          }
          if (ctrl.hasError.value) {
            return FlightErrorView(
              message: ctrl.errorMessage.value,
              onRetry: () => _search(ctrl),
            );
          }
          if (ctrl.hasSearched.value && ctrl.displayedFlights.isEmpty) {
            return const FlightNoResultsWidget();
          }
          if (!ctrl.hasSearched.value) {
            return const SizedBox.shrink();
          }
          return FlightList(
            flights: ctrl.displayedFlights,
            priceInsights: ctrl.priceInsights.value,
          );
        }),
      ),
    );
  }
}