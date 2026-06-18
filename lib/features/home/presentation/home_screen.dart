/*
import 'package:flight_app/features/home/controller/home_controller.dart';
import 'package:flight_app/features/home/data/flight_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DAC → DXB',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              'Thu, Jun 18 · One way · Economy',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final allFlights = [
          ...controller.bestFlights,
          ...controller.otherFlights,
        ];

        if (allFlights.isEmpty) {
          return const Center(child: Text('No flights available'));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          itemCount: allFlights.length,
          itemBuilder: (context, index) {
            final isBest = index < controller.bestFlights.length;
            return FlightCard(
              flight: allFlights[index],
              isBestFlight: isBest && index == 0,
            );
          },
        );
      }),
    );
  }
}

class FlightCard extends StatefulWidget {
  final BestFlight flight;
  final bool isBestFlight;

  const FlightCard({
    super.key,
    required this.flight,
    required this.isBestFlight,
  });

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool _isExpanded = false;

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}m';
  }

  String _formatTime(String dateTime) {
    if (dateTime.isEmpty) return '--';
    final parts = dateTime.split(' ');
    if (parts.length < 2) return dateTime;
    final timeParts = parts[1].split(':');
    final hour = int.parse(timeParts[0]);
    final min = timeParts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$h:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;
    final firstLeg = flight.flights.first;
    final lastLeg = flight.flights.last;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header Row ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                // Airline logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.network(
                    flight.airlineLogo,
                    width: 28.w,
                    height: 28.w,
                    errorBuilder: (_, __, ___) => Icon(Icons.flight, size: 24.sp),
                  ),
                ),
                Gap(8.w),
                Text(
                  'Departure · Thu, Jun 18',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                // Carbon badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${flight.flights.fold(0, (sum, f) => sum + (f.duration * 0))} '
                        '${_carbonLabel(flight)}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Gap(8.w),
                // Select flight button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(color: Color(0xFF1A73E8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    'Select flight',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF1A73E8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gap(8.w),
                Text(
                  '\$${flight.price}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),

          // ── Flight Summary ──
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline dot + line
                  Column(
                    children: [
                      _dot(),
                      Container(width: 1.5, height: 36.h, color: Colors.grey[300]),
                      _dot(),
                    ],
                  ),
                  Gap(12.w),
                  // Airport info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _airportRow(
                          time: _formatTime(firstLeg.departureAirport.time),
                          code: firstLeg.departureAirport.id,
                          name: firstLeg.departureAirport.name,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Text(
                            'Travel time: ${_formatDuration(flight.totalDuration)}'
                                '${flight.hasLayover ? ' · ${flight.layovers.length} stop' : ''}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        _airportRow(
                          time: _formatTime(lastLeg.arrivalAirport.time),
                          code: lastLeg.arrivalAirport.id,
                          name: lastLeg.arrivalAirport.name,
                        ),
                      ],
                    ),
                  ),
                  // Expand icon
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey[500],
                    size: 22.sp,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Details ──
          if (_isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                children: [
                  // Airline + class info
                  Row(
                    children: [
                      Icon(Icons.flight_takeoff, size: 14.sp, color: Colors.grey[500]),
                      Gap(6.w),
                      Text(
                        '${firstLeg.airline} · ${firstLeg.travelClass} · ${firstLeg.airplane} · ${firstLeg.flightNumber}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Gap(10.h),
                  // Feature tags
                  ..._buildExtensions(firstLeg.extensions),
                  // Layover info
                  if (flight.hasLayover) ...[
                    Gap(10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 14.sp, color: Colors.orange[700]),
                          Gap(6.w),
                          Text(
                            '${_formatDuration(flight.layovers.first.duration)} layover · ${flight.layovers.first.name}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Multi-leg details
                  if (flight.flights.length > 1) ...[
                    Gap(10.h),
                    ...flight.flights.skip(1).map((leg) => _buildLegDetail(leg)),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _carbonLabel(BestFlight flight) {
    final diff = flight.carbonEmissions?.differencePercent ?? 0;
    final kg = ((flight.carbonEmissions?.thisFlight ?? 0) / 1000).round();
    final sign = diff < 0 ? '' : '+';
    return '$kg kg CO₂  $sign$diff%';
  }

  Widget _dot() => Container(
    width: 8.w,
    height: 8.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey[400]!, width: 1.5),
    ),
  );

  Widget _airportRow({
    required String time,
    required String code,
    required String name,
  }) {
    return Row(
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        Gap(8.w),
        Text(
          code,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Gap(4.w),
        Expanded(
          child: Text(
            name,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildExtensions(List<String> extensions) {
    return extensions.map((e) {
      IconData icon = Icons.check_circle_outline;
      if (e.toLowerCase().contains('wi-fi')) icon = Icons.wifi;
      if (e.toLowerCase().contains('usb') || e.toLowerCase().contains('power')) {
        icon = Icons.usb;
      }
      if (e.toLowerCase().contains('video')) icon = Icons.ondemand_video;
      if (e.toLowerCase().contains('legroom')) icon = Icons.airline_seat_legroom_normal;
      if (e.toLowerCase().contains('carbon')) icon = Icons.eco;

      return Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Row(
          children: [
            Icon(icon, size: 13.sp, color: Colors.grey[500]),
            Gap(6.w),
            Expanded(
              child: Text(
                e,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildLegDetail(FlightLeg leg) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Image.network(
            leg.airlineLogo,
            width: 20.w,
            height: 20.w,
            errorBuilder: (_, __, ___) => Icon(Icons.flight, size: 16.sp),
          ),
          Gap(8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${leg.airline} · ${leg.flightNumber}',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${leg.departureAirport.id} → ${leg.arrivalAirport.id} · ${_formatDuration(leg.duration)}',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
