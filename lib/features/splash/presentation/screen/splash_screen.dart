import 'package:flight_app/core/constants/app_colors.dart';
import 'package:flight_app/core/constants/image_path.dart';
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(50.h),

              // Tagline
              Text(
                'YOUR JOURNEY STARTS HERE',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),

              Gap(8.h),

              // Title
              CustomText(
                text: "Welcome to\nOur Flight Service",
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.heading,
              ),

              Gap(20.h),

              // Hero Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  children: [
                    Image.asset(
                      ImagePath.splashImage,
                      width: double.infinity,
                      height: 240.h,
                      fit: BoxFit.cover,
                    ),
                    // Bottom fade overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF0D0D0D).withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              CustomButton(text: "Let's Fly", onPressed: (){
                Get.offAllNamed(AppRoutes.home);
              },),



              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }
}