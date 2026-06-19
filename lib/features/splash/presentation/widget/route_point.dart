import 'package:flight_app/core/global/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class RoutePoint extends StatelessWidget {
  const RoutePoint({super.key,
    required this.code,
    required this.label,
    this.align = CrossAxisAlignment.start,
  });
  final String code, label;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        CustomText(text: label, fontSize: 10.sp, color: AppColors.textSecondary),
        CustomText(
         text:  code,

            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),

      ],
    );
  }
}