import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

class FlightFilterBar extends StatelessWidget {
  const FlightFilterBar({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final int active;
  final ValueChanged<int> onChanged;

  static const _labels = ['All', 'Fastest'];
  static const _icons = [Icons.grid_view_rounded, Icons.bolt_rounded];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => Gap(8.w),
        itemBuilder: (_, i) {
          final isActive = active == i;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[i],
                    size: 14.sp,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                  Gap(5.w),
                  CustomText(
                  text:   _labels[i],

                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textSecondary,

                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}