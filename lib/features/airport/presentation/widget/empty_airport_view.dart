import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/global/custom_text.dart';

class EmptyAirport extends StatelessWidget {
  const EmptyAirport({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 52.sp,
            color: AppColors.textSecondary,
          ),
          Gap(12.h),
          CustomText(
            text: 'No airports found',

            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          Gap(4.h),
          CustomText(
            text: 'Try a different name or IATA code',
            fontSize: 12.sp,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }
}