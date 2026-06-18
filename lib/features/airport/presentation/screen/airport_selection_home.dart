import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../flight/controller/flight_controller.dart';

import '../../../flight/screen/flight_result_screen.dart';
import '../../controller/airport_controller.dart';
import '../widget/airport_widget.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AirportController airportCtrl = Get.put(AirportController());
  final FlightController flightCtrl = Get.put(FlightController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF1A73E8),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flight_rounded,
                                color: Colors.white, size: 22.sp),
                            Gap(8.w),
                            Text(
                              'SkySearch',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Gap(8.h),
                        Text(
                          'Where would you like to fly?',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ── Body ───────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Selector Card ────────────────────────────────────────
                  _SelectorCard(
                    airportCtrl: airportCtrl,
                    flightCtrl: flightCtrl,
                  ),
                  Gap(20.h),
                  // ── Quick Tips ───────────────────────────────────────────
                  Text(
                    'Tips',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(10.h),
                  ..._tips.map((t) => _TipRow(icon: t.$1, text: t.$2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _tips = [
    (Icons.swap_vert_rounded, 'Tap the swap icon to quickly reverse routes'),
    (Icons.search_rounded, 'Search airports by name, city, or IATA code'),
    (Icons.bolt_rounded, 'Fastest tab finds the quickest travel option'),
  ];
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: AppColors.primary),
          ),
          Gap(10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Selector Card (From / Swap / To + Search Button)
// ─────────────────────────────────────────────────────────────────────────────
class _SelectorCard extends StatelessWidget {
  const _SelectorCard({
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
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
          Gap(16.h),
          // Search Button
          Obx(() {
            final canSearch = airportCtrl.departureAirport.value != null &&
                airportCtrl.arrivalAirport.value != null;
            return SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: canSearch
                    ? () => _onSearch(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[200],
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
                    Text(
                      'Search Flights',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: canSearch ? Colors.white : Colors.grey[400],
                      ),
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
    if (dep == null || arr == null) return;

    flightCtrl.clearResults();

    Get.to(
          () => FlightResultsScreen(
        departure: dep,
        arrival: arr,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}