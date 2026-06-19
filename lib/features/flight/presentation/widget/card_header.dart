import 'package:flight_app/core/global/custom_text.dart';
import 'package:flight_app/features/flight/presentation/widget/select_flight_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';
import 'airline_logo_badge.dart';
import 'emission_block.dart';


class CardHeader extends StatelessWidget {
  const CardHeader({super.key,
    required this.flight,
    required this.expanded,
    required this.onSelect,
  });

  final FlightResult flight;
  final bool expanded;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AirlineLogoBadge(logoUrl: flight.airlineLogo),
            Gap(10.w),
            Expanded(
              child: Row(
                children: [
                  if (flight.isBestFlight) ...[
                    Icon(Icons.star_rounded, size: 13.sp, color: AppColors.bestAccent),
                    Gap(4.w),
                  ],
                  Flexible(
                    child: CustomText(
                     text:  'Departure · ${flight.dateLabel}',

                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8.w),
            CustomText(
              text: '\$${flight.price}',

                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,

            ),

            Gap(6.w),
            Icon(
              expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              size: 20.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        Gap(5.h),
        Container(
          margin: EdgeInsets.only(left: 50.w),
            child: CustomText(text: _footerText(flight,), textAlign: TextAlign.center,color: AppColors.blackColor,)),
        Gap(10.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: EmissionsBlock(flight: flight)),
              Gap(8.w),
              SelectFlightButton(onTap: onSelect),
            ],
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