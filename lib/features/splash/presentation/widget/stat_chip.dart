import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });
  final String label, value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 10.sp,
          color: AppColors.textSecondary,
        ),
        Gap(2.h),
        CustomText(
          text: value,

          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: valueColor ?? AppColors.heading,
        ),
      ],
    );
  }
}
