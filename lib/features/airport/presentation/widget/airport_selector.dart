import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';

import '../../data/airport_data.dart';

class AirportSelectorTile extends StatelessWidget {
  const AirportSelectorTile({
    super.key,
    required this.label,
    required this.icon,
    required this.airportObs,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final IconData icon;
  final Rx<Airport?> airportObs;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(() {
        final airport = airportObs.value;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.sp, color: AppColors.primary),
              ),
              Gap(12.w),
              Expanded(
                child: airport == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: label,

                            fontSize: 11.sp,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          Gap(3.h),
                          CustomText(
                            text: 'Select airport',

                            fontSize: 14.sp,
                            color: AppColors.textHint,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: label,

                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          Gap(3.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              CustomText(
                                text: airport.code,

                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                              Gap(8.w),
                              Expanded(
                                child: CustomText(
                                  text: airport.airportName,

                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (airport.airportCity.isNotEmpty)
                            CustomText(
                              text:
                                  '${airport.airportCity}, ${airport.airportCountry}',

                              fontSize: 11.sp,
                              color: AppColors.textHint,
                            ),
                        ],
                      ),
              ),
              if (airport != null)
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
