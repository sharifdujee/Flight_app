import 'package:flight_app/features/splash/presentation/widget/route_point.dart';
import 'package:flight_app/features/splash/presentation/widget/stat_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class FlightCard extends StatelessWidget {
  const FlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          /// Dark banner with plane icon + route
          Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.gradientOne, AppColors.gradientTwo],
              ),
            ),
            child: Stack(
              children: [
                /// Plane icon centered
                Center(
                  child: Icon(
                    Icons.flight_rounded,
                    size: 56.sp,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),

                /// Bottom fading
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, const Color(0xFF141414)],
                      ),
                    ),
                  ),
                ),
                // Route row
                Positioned(
                  bottom: 12.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RoutePoint(code: 'DAC', label: 'From'),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                      RoutePoint(
                        code: 'DXB',
                        label: 'To',
                        align: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatChip(label: 'Duration', value: '4h 15m'),
                StatChip(label: 'Class', value: 'Economy'),

                StatChip(
                  label: 'From',
                  value: '\$349',
                  valueColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
