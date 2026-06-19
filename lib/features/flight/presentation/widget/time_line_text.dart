import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class TimelineText extends StatelessWidget {
  const TimelineText({super.key, required this.time, required this.label});
  final String time;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: '$time · ',

          fontSize: 12.5.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        Expanded(
          child: CustomText(
            text: label,

            fontSize: 12.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
