import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';

class EmissionsBlock extends StatelessWidget {
  const EmissionsBlock({super.key, required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    final diff = flight.emissionsPercentDiff;
    final diffLabel = '${diff > 0 ? '+' : ''}$diff% emissions';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${flight.carbonEmissionKg} kg CO₂',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Gap(3.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.emissionsBg,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                diffLabel,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emissionsText,
                ),
              ),
            ),
          ],
        ),
        Gap(5.w),
        Icon(
          Icons.info_outline_rounded,
          size: 12.sp,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
