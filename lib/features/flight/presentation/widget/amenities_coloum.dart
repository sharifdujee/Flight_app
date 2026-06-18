import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';

class AmenitiesColumn extends StatelessWidget {
  const AmenitiesColumn({super.key, required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    final lines = <String>[];
    final legroom = flight.flights.isNotEmpty ? flight.flights.first.legroom : null;
    if (legroom != null && legroom.isNotEmpty) {
      lines.add('Average legroom ($legroom)');
    }
    final seen = <String>{};
    for (final seg in flight.flights) {
      for (final ext in seg.extensions) {
        if (ext.toLowerCase().contains('legroom')) continue;
        if (seen.add(ext)) lines.add(ext);
      }
    }
    lines.add('Carbon emissions estimate: ${flight.carbonEmissionKg} kg');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Text(
              line,
              style: TextStyle(fontSize: 10.5.sp, color: AppColors.textSecondary),
            ),
          ),
      ],
    );
  }
}