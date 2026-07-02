import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../flight/controller/flight_controller.dart';
import '../../../flight/screen/flight_result_screen.dart';
import '../../controller/airport_controller.dart';
import 'airport_picker_sheet.dart';
import 'airport_selector.dart';

class SelectorCard extends StatelessWidget {
  const SelectorCard({
    super.key,
    required this.airportCtrl,
    required this.flightCtrl,
  });

  final AirportController airportCtrl;
  final FlightController flightCtrl;

  void _openPicker(BuildContext context, {required bool isDeparture}) {
    airportCtrl.clearSearch();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AirportPickerSheet(isDeparture: isDeparture),
    );
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final initial = airportCtrl.departureDate.value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      airportCtrl.setDepartureDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // From
          AirportSelectorTile(
            label: 'FROM',
            icon: Icons.flight_takeoff_rounded,
            airportObs: airportCtrl.departureAirport,
            onTap: () => _openPicker(context, isDeparture: true),
            onClear: airportCtrl.clearDeparture,
          ),
          // Divider + Swap
          Container(
            margin: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[200],
                    thickness: 1,
                    indent: 8,
                    endIndent: 12,
                  ),
                ),
                GestureDetector(
                  onTap: airportCtrl.swapAirports,
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.swap_vert_rounded,
                      size: 20.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[200],
                    thickness: 1,
                    indent: 12,
                    endIndent: 8,
                  ),
                ),
              ],
            ),
          ),
          // To
          AirportSelectorTile(
            label: 'TO',
            icon: Icons.flight_land_rounded,
            airportObs: airportCtrl.arrivalAirport,
            onTap: () => _openPicker(context, isDeparture: false),
            onClear: airportCtrl.clearArrival,
          ),
          Gap(12.h),
          // Departure Date
          Obx(() {
            final date = airportCtrl.departureDate.value;
            return GestureDetector(
              onTap: () => _openDatePicker(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14.r),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 20.sp,
                      color: AppColors.primary,
                    ),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'DEPARTURE DATE',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        CustomText(
                          text: date != null
                              ? DateFormat('EEE, MMM d, yyyy').format(date)
                              : 'Select date',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          Gap(16.h),
          // Search Button
          Obx(() {
            final canSearch =
                airportCtrl.departureAirport.value != null &&
                    airportCtrl.arrivalAirport.value != null &&
                    airportCtrl.departureDate.value != null;
            return SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: canSearch ? () => _onSearch(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.textSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: canSearch ? 2 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 20.sp,
                      color: canSearch ? Colors.white : Colors.grey[400],
                    ),
                    Gap(8.w),
                    CustomText(
                      text: 'Search Flights',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: canSearch
                          ? AppColors.primaryLight
                          : AppColors.primaryLight,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _onSearch(BuildContext context) {
    final dep = airportCtrl.departureAirport.value;
    final arr = airportCtrl.arrivalAirport.value;
    final date = airportCtrl.departureDate.value;
    if (dep == null || arr == null || date == null) return;

    flightCtrl.clearResults();

    // Pass the selected date so it can be used to build
    // outbound_date in the search_parameters, e.g.:
    // "outbound_date": DateFormat('yyyy-MM-dd').format(date)
    Get.to(
          () => FlightResultsScreen(
        departure: dep,
        arrival: arr,
        outboundDate: date,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}