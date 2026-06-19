import 'package:flight_app/core/constants/app_colors.dart';
import 'package:flight_app/core/global/custom_button.dart';
import 'package:flight_app/core/global/custom_text.dart';
import 'package:flight_app/features/routes/app_routes.dart';
import 'package:flight_app/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../widget/feature_card.dart';
import '../widget/flight_card.dart';
import '../widget/logo_section.dart';

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
              LogoSection(),

              Gap(28.h),

              ///  Tagline + Title
              CustomText(
                text: 'YOUR JOURNEY STARTS HERE',

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
              FlightCard(),

              Gap(18.h),

              // ── Feature Mini Cards ─────────────────────────────────────
              FeatureCard(),

              const Spacer(),

              // ── CTA Button ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: CustomButton(
                  textColor: AppColors.primaryLight,

                  prefixIcon: Icons.flight,
                  text: "Let's Fly",
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.home);
                  },
                ),
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
