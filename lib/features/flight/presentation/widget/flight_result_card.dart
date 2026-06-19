
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controller/flight_controller.dart';
import '../../data/flight_data.dart';
import 'card_details.dart';
import 'card_header.dart';

class FlightResultCard extends StatelessWidget {
  const FlightResultCard({
    super.key,
    required this.flight,
    required this.index,
    this.onSelect,
  });

  final FlightResult flight;
  final int index;
  final ValueChanged<FlightResult>? onSelect;

  void _handleSelect() {
    if (onSelect != null) {
      onSelect!(flight);
      return;
    }
    Get.snackbar(
      'Flight selected',
      '${flight.airlineName} · \$${flight.price}',
      backgroundColor: AppColors.background,
      colorText: AppColors.textPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(12.w),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final expanded = controller.isCardExpanded(index);
        return Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: () => controller.toggleCardExpanded(index),
              child: Container(
                padding: EdgeInsets.all(12.w),
                child: CardHeader(
                  flight: flight,
                  expanded: expanded,
                  onSelect: _handleSelect,
                ),
              ),
            ),
            if (expanded) ...[
              Container(height: 1, color: AppColors.divider),
              Container(
                padding: EdgeInsets.all(14.w),
                child: CardDetails(flight: flight),
              ),
            ],
          ],
        );
      }),
    );
  }
}








