import 'package:flight_app/features/flight/presentation/widget/time_line_dot.dart';
import 'package:flight_app/features/flight/presentation/widget/time_line_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';



class SegmentTimeline extends StatelessWidget {
  const SegmentTimeline({super.key, required this.segment});
  final FlightSegment segment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TimelineDots(),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineText(
                time: segment.departureAirport.timeFormatted,
                label: '${segment.departureAirport.name} (${segment.departureAirport.id})',
              ),
              Gap(5.h),
              Text(
                'Travel time: ${segment.durationFormatted}',
                style: TextStyle(fontSize: 10.5.sp, color: AppColors.textSecondary),
              ),
              Gap(5.h),
              TimelineText(
                time: segment.arrivalAirport.timeFormatted,
                label: '${segment.arrivalAirport.name} (${segment.arrivalAirport.id})',
              ),
            ],
          ),
        ),
      ],
    );
  }
}