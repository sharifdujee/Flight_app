
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/flight_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Main Flight Result Card
// ─────────────────────────────────────────────────────────────────────────────
class FlightResultCard extends StatefulWidget {
  const FlightResultCard({
    super.key,
    required this.flight,
    required this.index,
  });

  final FlightResult flight;
  final int index;

  @override
  State<FlightResultCard> createState() => _FlightResultCardState();
}

class _FlightResultCardState extends State<FlightResultCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.flight;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: f.isBestFlight
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          // ── Best Flight Badge ──────────────────────────────────────────────
          if (f.isBestFlight)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.5.r)),
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, size: 13.sp, color: Colors.white),
                  Gap(4.w),
                  Text(
                    'Best flight',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          // ── Card Body ─────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _FlightMainRow(flight: f),
                Gap(14.h),
                _FlightTimelineRow(flight: f),
                Gap(14.h),
                const Divider(height: 1, color: AppColors.divider),
                Gap(12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PriceChip(price: f.price),
                    Row(
                      children: [
                        if (f.stops > 0) ...[
                          _StopsChip(stops: f.stopsLabel),
                          Gap(8.w),
                        ],
                        GestureDetector(
                          onTap: () => setState(() => _expanded = !_expanded),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: _expanded
                                  ? AppColors.primaryLight
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _expanded ? 'Less' : 'Details',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _expanded
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                Gap(3.w),
                                Icon(
                                  _expanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 16.sp,
                                  color: _expanded
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ── Expanded: Segments ────────────────────────────────────────────
          if (_expanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.divider,
            ),
            _ExpandedSegments(flight: f),
          ],
        ],
      ),
    );
  }
}

// ─── Airline logo + name row ──────────────────────────────────────────────────
class _FlightMainRow extends StatelessWidget {
  const _FlightMainRow({required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    // Collect unique airlines
    final airlines = flight.flights.map((f) => f.airline).toSet().toList();
    final logoUrl = flight.airlineLogo;

    return Row(
      children: [
        // Airline logo
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: logoUrl.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(9.r),
            child: Image.network(
              logoUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.flight_rounded,
                size: 20.sp,
                color: AppColors.primary,
              ),
            ),
          )
              : Icon(Icons.flight_rounded, size: 20.sp, color: AppColors.primary),
        ),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                airlines.join(' · '),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(2.h),
              Text(
                flight.flights.map((f) => f.flightNumber).join(', '),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Economy badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            flight.flights.isNotEmpty
                ? flight.flights.first.travelClass
                : 'Economy',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Time + route timeline ────────────────────────────────────────────────────
class _FlightTimelineRow extends StatelessWidget {
  const _FlightTimelineRow({required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Departure
        _TimeBlock(
          time: flight.departureTimeFormatted,
          code: flight.departureCode,
          align: CrossAxisAlignment.start,
        ),
        // Middle: duration + line
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                Text(
                  flight.durationFormatted,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(4.h),
                _RouteBar(flight: flight),
                Gap(4.h),
                Text(
                  flight.stopsLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: flight.stops == 0
                        ? AppColors.success
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        // Arrival
        _TimeBlock(
          time: flight.arrivalTimeFormatted,
          code: flight.arrivalCode,
          align: CrossAxisAlignment.end,
          showNextDay: flight.isOvernight,
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.time,
    required this.code,
    required this.align,
    this.showNextDay = false,
  });

  final String time;
  final String code;
  final CrossAxisAlignment align;
  final bool showNextDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            if (showNextDay) ...[
              Gap(2.w),
              Text(
                '+1',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
            ],
          ],
        ),
        Gap(2.h),
        Text(
          code,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _RouteBar extends StatelessWidget {
  const _RouteBar({required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dot(),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(height: 1.5, color: AppColors.border),
              // Stop dots along the line
              if (flight.stops > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    flight.stops,
                        (_) => Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        _dot(),
      ],
    );
  }

  Widget _dot() => Container(
    width: 7.w,
    height: 7.w,
    decoration: BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
    ),
  );
}

// ─── Price chip ───────────────────────────────────────────────────────────────
class _PriceChip extends StatelessWidget {
  const _PriceChip({required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'from',
          style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
        ),
        Text(
          '\$$price',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// ─── Stops chip ───────────────────────────────────────────────────────────────
class _StopsChip extends StatelessWidget {
  const _StopsChip({required this.stops});
  final String stops;

  @override
  Widget build(BuildContext context) {
    final isNonstop = stops == 'Nonstop';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isNonstop ? AppColors.successLight : AppColors.warningLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        stops,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: isNonstop ? AppColors.success : const Color(0xFF795548),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Expanded Segments View
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandedSegments extends StatelessWidget {
  const _ExpandedSegments({required this.flight});
  final FlightResult flight;

  @override
  Widget build(BuildContext context) {
    final segments = flight.flights;
    final layovers = flight.layovers;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          for (int i = 0; i < segments.length; i++) ...[
            _SegmentDetail(segment: segments[i]),
            if (i < layovers.length) ...[
              Gap(8.h),
              _LayoverBadge(layover: layovers[i]),
              Gap(8.h),
            ],
          ],
        ],
      ),
    );
  }
}

class _SegmentDetail extends StatelessWidget {
  const _SegmentDetail({required this.segment});
  final FlightSegment segment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Airline + flight number
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: segment.airlineLogo.isNotEmpty
                    ? Image.network(
                  segment.airlineLogo,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.flight, size: 14.sp, color: AppColors.primary),
                )
                    : Icon(Icons.flight, size: 14.sp, color: AppColors.primary),
              ),
              Gap(8.w),
              Text(
                segment.airline,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Gap(6.w),
              Text(
                segment.flightNumber,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                segment.durationFormatted,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Gap(10.h),
          // Route detail
          Row(
            children: [
              // Left column: times
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    segment.departureAirport.timeFormatted,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    segment.departureAirport.id,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Gap(2.h),
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      segment.departureAirport.name,
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.arrow_forward_rounded, size: 18.sp, color: AppColors.primary),
                    Text(
                      segment.airplane,
                      style: TextStyle(fontSize: 9.sp, color: AppColors.textHint),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    segment.arrivalAirport.timeFormatted,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    segment.arrivalAirport.id,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Gap(2.h),
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      segment.arrivalAirport.name,
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (segment.legroom != null) ...[
            Gap(8.h),
            Row(
              children: [
                Icon(Icons.airline_seat_recline_normal_rounded,
                    size: 13.sp, color: AppColors.textHint),
                Gap(4.w),
                Text(
                  segment.legroom!,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LayoverBadge extends StatelessWidget {
  const _LayoverBadge({required this.layover});
  final Layover layover;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.divider,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, size: 13.sp,
                  color: const Color(0xFF795548)),
              Gap(4.w),
              Text(
                '${layover.durationFormatted} in ${layover.id}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF795548),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.divider),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Tab Bar
// ─────────────────────────────────────────────────────────────────────────────
class FlightFilterBar extends StatelessWidget {
  const FlightFilterBar({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final int active;
  final ValueChanged<int> onChanged;

  static const _labels = ['All', 'Best', 'Cheapest', 'Fastest'];
  static const _icons = [
    Icons.grid_view_rounded,
    Icons.star_rounded,
    Icons.sell_rounded,
    Icons.bolt_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => Gap(8.w),
        itemBuilder: (_, i) {
          final isActive = active == i;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[i],
                    size: 14.sp,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                  Gap(5.w),
                  Text(
                    _labels[i],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class FlightLoadingWidget extends StatelessWidget {
  const FlightLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          Gap(20.h),
          Text(
            'Searching flights…',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Gap(6.h),
          Text(
            'Finding the best deals for you',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class FlightNoResultsWidget extends StatelessWidget {
  const FlightNoResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flight_outlined, size: 64.sp, color: Colors.grey[300]),
          Gap(16.h),
          Text(
            'No flights found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          Gap(6.h),
          Text(
            'Try different dates or airports',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}