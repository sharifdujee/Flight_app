import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';

class PriceInsightBanner extends StatelessWidget {
  const PriceInsightBanner({super.key, required this.insights});
  final PriceInsights insights;

  Color get _levelColor {
    switch (insights.priceLevel) {
      case 'low':
        return AppColors.success;
      case 'high':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String get _levelLabel {
    switch (insights.priceLevel) {
      case 'low':
        return 'Low prices now';
      case 'high':
        return 'Prices are high';
      default:
        return 'Typical prices';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _levelColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _levelColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            insights.priceLevel == 'low'
                ? Icons.trending_down_rounded
                : insights.priceLevel == 'high'
                ? Icons.trending_up_rounded
                : Icons.trending_flat_rounded,
            size: 18.sp,
            color: _levelColor,
          ),
          Gap(8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: _levelLabel,

                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: _levelColor,
                ),
                if (insights.typicalPriceRange.length == 2)
                  CustomText(
                    text:
                        'Typical: \$${insights.typicalPriceRange[0]}–\$${insights.typicalPriceRange[1]}',
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
          ),
          CustomText(
            text: 'from \$${insights.lowestPrice}',

            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
