import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/global/custom_text.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.flight_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
        Gap(10.w),
        CustomText(
          text:  'SkySearch',

          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.3,

        ),
      ],
    );
  }
}