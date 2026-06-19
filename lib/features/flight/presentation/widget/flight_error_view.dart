import 'package:flight_app/core/global/custom_button.dart';
import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

class FlightErrorView extends StatelessWidget {
  const FlightErrorView({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64.sp, color: AppColors.grey300),
            Gap(16.h),
            CustomText(
             text:  'Could not load flights',

                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,

            ),
            Gap(6.h),
            CustomText(
                textAlign: TextAlign.center,
             text:  message,
              fontSize: 12.sp, color: AppColors.textHint),


            Gap(24.h),
            CustomButton(text: "Try Again", onPressed: (){
              onRetry;
            }, prefixIcon: Icons.refresh_outlined)
            
          ],
        ),
      ),
    );
  }
}