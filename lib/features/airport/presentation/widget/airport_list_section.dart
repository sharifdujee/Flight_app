import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/airport_data.dart';

class AirportListSection extends StatelessWidget {
  const AirportListSection({
    super.key,
    required this.airport,
    required this.onTap,
    required this.isSelected,
  });

  final Airport airport;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primaryLight,
      highlightColor: AppColors.primaryLight.withValues(alpha: 0.5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 52.w,
              padding: EdgeInsets.symmetric(vertical: 7.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: CustomText(
               text:  airport.code,

                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.primary,
                  letterSpacing: 0.5,

              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                   text:  airport.airportName,

                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(2.h),
                  CustomText(
                    text:
                        '${airport.airportCity}${airport.airportCountry.isNotEmpty ? ' · ${airport.airportCountry}' : ''}',
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 20.sp,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
