import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

class FlightNoResultsWidget extends StatelessWidget {
  const FlightNoResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flight_outlined, size: 64.sp, color: AppColors.grey300),
          Gap(16.h),
          CustomText(
            text: 'No flights found',

            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          Gap(6.h),
          CustomText(
            text: 'Try different dates or airports',
            fontSize: 13.sp,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }
}
