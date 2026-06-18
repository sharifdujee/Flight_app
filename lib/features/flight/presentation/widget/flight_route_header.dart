import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../airport/data/airport_data.dart';

class FlightRouteHeader extends StatelessWidget {
  const FlightRouteHeader({super.key, required this.departure, required this.arrival});
  final Airport departure;
  final Airport arrival;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          departure.code,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Icon(Icons.arrow_forward_rounded, size: 16.sp, color: Colors.white70),
        ),
        Text(
          arrival.code,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        Gap(8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'One way',
            style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}