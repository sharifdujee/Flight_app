import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';

class LayoverRow extends StatelessWidget {
  const LayoverRow({super.key, required this.layover});
  final Layover layover;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 18.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 12.sp, color: AppColors.textSecondary),
          Gap(4.w),
          CustomText(
            text: '${layover.durationFormatted} in ${layover.id}',

              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,

          ),
        ],
      ),
    );
  }
}