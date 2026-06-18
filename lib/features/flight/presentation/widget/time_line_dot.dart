import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';

class TimelineDots extends StatelessWidget {
  const TimelineDots();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Column(
        children: [
          _ring(),
          Gap(4.h),
          _dot(),
          Gap(3.h),
          _dot(),
          Gap(3.h),
          _dot(),
          Gap(4.h),
          _ring(),
        ],
      ),
    );
  }

  Widget _ring() => Container(
    width: 8.w,
    height: 8.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.textSecondary, width: 1.4),
    ),
  );

  Widget _dot() => Container(
    width: 3.w,
    height: 3.w,
    decoration:  BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.textSecondary,
    ),
  );
}