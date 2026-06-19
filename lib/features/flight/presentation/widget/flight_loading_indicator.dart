import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/global/custom_loading.dart';

class FlightLoadingWidget extends StatelessWidget {
  const FlightLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomLoading(color: AppColors.primary, size: 50),
          Gap(20.h),
          CustomText(
            text: 'Searching flights…',

            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          Gap(6.h),
          CustomText(
            text: 'Finding the best deals for you',
            fontSize: 12.sp,
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }
}
