import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/global/custom_button.dart';
import '../../../../core/global/custom_text.dart';

class AirportErrorView extends StatelessWidget {
  const AirportErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 52.sp, color: Colors.grey[300]),
            Gap(12.h),
            CustomText(
              text: 'Could not load airports',

              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            Gap(6.h),
            CustomText(
              text: message,
              fontSize: 12.sp,
              color: AppColors.textHint,
              textAlign: TextAlign.center,
            ),
            Gap(20.h),
            CustomButton(
              prefixIcon: Icons.refresh_outlined,
              text: "Retry",
              onPressed: () {
                onRetry;
              },
            ),
          ],
        ),
      ),
    );
  }
}