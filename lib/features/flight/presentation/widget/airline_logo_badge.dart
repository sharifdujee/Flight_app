import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class AirlineLogoBadge extends StatelessWidget {
  const AirlineLogoBadge({super.key, required this.logoUrl});
  final String logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: AppColors.logoBg,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: logoUrl.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: Image.network(
          logoUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.flight_rounded, size: 16.sp, color: Colors.black54),
        ),
      )
          : Icon(Icons.flight_rounded, size: 16.sp, color: Colors.black54),
    );
  }
}