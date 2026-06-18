

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
            AirlineLogoBadge(logoUrl: flight.airlineLogo),
            Gap(10.w),
            Expanded(flex: 3, child: CustomTimeline(flight: flight)),
            Gap(12.w),
            Expanded(flex: 2, child: AmenitiesColumn(flight: flight)),
          ],
        ),
        Gap(12.h),
        Padding(
          padding: EdgeInsets.only(left: 40.w),
          child: Text(
            _footerText(flight),
            style: TextStyle(fontSize: 10.5.sp, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  String _footerText(FlightResult f) {
    if (f.flights.length == 1) {
      final s = f.flights.first;
      return '${s.airline} · ${s.travelClass} · ${s.airplane} · ${s.flightNumber}';
    }
    final airlineNames = f.flights.map((s) => s.airline).toSet().join(' · ');
    final cls = f.flights.first.travelClass;
    final flightNos = f.flights.map((s) => s.flightNumber).join(', ');
    return '$airlineNames · $cls · $flightNos';
  }
}