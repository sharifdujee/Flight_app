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

  final AirportController airportCtrl = Get.find();
  final FlightController flightCtrl = Get.find();

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
                            Icon(
                              Icons.flight_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                            Gap(8.w),
                            CustomText(
                             text:  'SkySearch',

                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,

                            ),
                          ],
                        ),
                        Gap(8.h),
                        CustomText(
                         text:  'Where would you like to fly?',

                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.85),

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
                  SelectorCard(
                    airportCtrl: airportCtrl,
                    flightCtrl: flightCtrl,
                  ),
                  Gap(20.h),
                  // ── Quick Tips ───────────────────────────────────────────
                  CustomText(text:
                    'Tips',

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
          ),
        ],
      ),
    );
  }
}
