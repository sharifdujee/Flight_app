import 'package:flight_app/core/constants/app_colors.dart';

import 'package:flight_app/core/global/custom_button.dart';
import 'package:flight_app/core/global/custom_text.dart';
import 'package:flight_app/features/routes/app_routes.dart';
import 'package:flight_app/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(40.h),

              ///  Logo Row
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.flight_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                  Gap(10.w),
                  CustomText(
                   text:  'SkySearch',

                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,

                  ),
                ],
              ),

              Gap(28.h),

              ///  Tagline + Title
              CustomText(
               text:  'YOUR JOURNEY STARTS HERE',

                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.5,

              ),
              Gap(10.h),
              CustomText(
                text: "Welcome to\nFlight Service",
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),

              Gap(24.h),

              /// Hero Flight Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFF222222)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    /// Dark banner with plane icon + route
                    Container(
                      height: 160.h,
                      width: double.infinity,
                      decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.gradientOne,
                            AppColors.gradientTwo
                            ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          /// Plane icon centered
                          Center(
                            child: Icon(
                              Icons.flight_rounded,
                              size: 56.sp,
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                          ),
                          /// Bottom fading
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            height: 60.h,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    const Color(0xFF141414),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Route row
                          Positioned(
                            bottom: 12.h, left: 16.w, right: 16.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RoutePoint(code: 'DAC', label: 'From'),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.primary,
                                  size: 20.sp,
                                ),
                                RoutePoint(code: 'DXB', label: 'To', align: CrossAxisAlignment.end),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stats row
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatChip(label: 'Duration', value: '4h 15m'),
                          StatChip(label: 'Class', value: 'Economy'),

                          StatChip(
                            label: 'From',
                            value: '\$349',
                            valueColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Gap(18.h),

              // ── Feature Mini Cards ─────────────────────────────────────
              Row(
                children: [
                  FeatureChip(
                    icon: Icons.verified_user_rounded,
                    iconColor: AppColors.primary,
                    label: 'Safe & Secure',
                    sub: 'Verified flights',
                  ),
                  Gap(10.w),
                  FeatureChip(
                    icon: Icons.bolt_rounded,
                    iconColor: AppColors.success,
                    label: 'Best Prices',
                    sub: 'Real-time deals',
                  ),
                  Gap(10.w),
                  FeatureChip(
                    icon: Icons.access_time_rounded,
                    iconColor: AppColors.warning,
                    label: '24/7 Support',
                    sub: 'Always here',
                  ),
                ],
              ),

              const Spacer(),

              // ── CTA Button ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: CustomButton(
                  textColor: AppColors.primaryLight,

                  prefixIcon: Icons.flight,
                    text: "Let's Fly", onPressed: (){
                  Get.offAllNamed(AppRoutes.home);


                })

              ),

              Gap(12.h),
              Center(
                child: Text(
                  'No account needed · Free to use',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small helpers ────────────────────────────────────────────────────────────

class RoutePoint extends StatelessWidget {
  const RoutePoint({super.key,
    required this.code,
    required this.label,
    this.align = CrossAxisAlignment.start,
  });
  final String code, label;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
        Text(
          code,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
      ],
    );
  }
}

class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.label, required this.value, this.valueColor});
  final String label, value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
        Gap(2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: valueColor ?? AppColors.heading,
          ),
        ),
      ],
    );
  }
}

class FeatureChip extends StatelessWidget {
  const FeatureChip({super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sub,
  });
  final IconData icon;
  final Color iconColor;
  final String label, sub;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF222222)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18.sp, color: iconColor),
            Gap(6.h),
            Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
            Gap(2.h),
            Text(sub, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.heading)),
          ],
        ),
      ),
    );
  }
}