import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../flight/controller/flight_controller.dart';

import '../../controller/airport_controller.dart';

import '../widget/selector_card.dart';
import '../widget/tips_row.dart';

class AirportScreen extends StatelessWidget {
  AirportScreen({super.key});

  final AirportController airportCtrl = Get.put(AirportController());
  final FlightController flightCtrl = Get.put(FlightController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.flight_rounded, color: Colors.white, size: 22.sp),
            Gap(8.w),
            CustomText(
              text: 'SkySearch',

              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(28.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'Where would you like to fly?',

                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectorCard(airportCtrl: airportCtrl, flightCtrl: flightCtrl),
            Gap(20.h),
            CustomText(
              text: 'Tips',

              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            Gap(10.h),
            ...AirportController.tips.map(
              (t) => TipsRow(icon: t.$1, text: t.$2),
            ),
          ],
        ),
      ),
    );
  }
}
