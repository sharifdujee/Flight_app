import 'package:flight_app/features/flight/presentation/widget/segment_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/flight_data.dart';
import 'flight_result_card.dart';
import 'layoverRow.dart';


class CustomTimeline extends StatelessWidget {
  const CustomTimeline({super.key, required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    final segments = flight.flights;
    final layovers = flight.layovers;
    final children = <Widget>[];

    for (int i = 0; i < segments.length; i++) {
      children.add(SegmentTimeline(segment: segments[i]));
      if (i < layovers.length) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: LayoverRow(layover: layovers[i]),
          ),
        );
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}