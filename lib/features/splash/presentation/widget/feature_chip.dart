import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

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
          color: AppColors.textColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18.sp, color: iconColor),
            Gap(6.h),
            CustomText(text: label, fontSize: 10.sp, color: AppColors.textSecondary),
            Gap(2.h),
            CustomText(text: sub, fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.heading),
          ],
        ),
      ),
    );
  }
}