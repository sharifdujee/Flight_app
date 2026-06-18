import 'package:flight_app/features/flight/presentation/widget/price_insight_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/flight_data.dart';
import 'flight_result_card.dart';

class FlightList extends StatelessWidget {
  const FlightList({super.key, required this.flights, this.priceInsights});
  final List<FlightResult> flights;
  final PriceInsights? priceInsights;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
      itemCount: flights.length + (priceInsights != null ? 1 : 0),
      itemBuilder: (_, i) {
        // Price insight banner at the top
        if (i == 0 && priceInsights != null) {
          return PriceInsightBanner(insights: priceInsights!);
        }
        final flightIndex = priceInsights != null ? i - 1 : i;
        return FlightResultCard(
          flight: flights[flightIndex],
          index: flightIndex,
        );
      },
    );
  }
}