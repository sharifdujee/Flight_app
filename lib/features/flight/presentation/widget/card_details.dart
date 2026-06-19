

import 'package:flight_app/features/flight/presentation/widget/time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';
import 'airline_logo_badge.dart';
import 'amenities_coloum.dart';


class CardDetails extends StatelessWidget {
  const CardDetails({super.key, required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Gap(10.w),
            Expanded(flex: 3, child: CustomTimeline(flight: flight)),
            Gap(12.w),
            Expanded(flex: 2, child: AmenitiesColumn(flight: flight)),
          ],
        ),
        Gap(12.h),

      ],
    );
  }


}