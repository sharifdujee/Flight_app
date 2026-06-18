import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controller/airport_controller.dart';
import 'airport_list_section.dart';


class AirportPickerSheet extends StatelessWidget {
  const AirportPickerSheet({super.key, required this.isDeparture});

  final bool isDeparture;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AirportController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Gap(10.h),
              // Drag handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(14.h),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDeparture ? 'Departure Airport' : 'Arrival Airport',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Search or scroll to select',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, size: 18.sp, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(14.h),
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  controller: ctrl.searchController,
                  autofocus: true,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search airport name or IATA code…',
                    hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: Obx(() => ctrl.searchText.value.isNotEmpty
                        ? GestureDetector(
                      onTap: ctrl.clearSearch,
                      child: Icon(Icons.close, size: 18.sp, color: AppColors.textHint),
                    )
                        : const SizedBox.shrink()),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Gap(10.h),
              // Results count
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() => Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 13.sp, color: AppColors.textHint),
                    Gap(4.w),
                    Text(
                      '${ctrl.filteredAirports.length} airports',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                )),
              ),
              Gap(6.h),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              // List
              Expanded(
                child: Obx(() {
                  if (ctrl.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    );
                  }
                  if (ctrl.hasError.value) {
                    return _ErrorView(
                      message: ctrl.errorMessage.value,
                      onRetry: ctrl.fetchAirports,
                    );
                  }
                  if (ctrl.filteredAirports.isEmpty) {
                    return const _EmptyState();
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: ctrl.filteredAirports.length,
                    itemBuilder: (_, i) {
                      final airport = ctrl.filteredAirports[i];
                      return AirportListSection(
                        airport: airport,
                        onTap: () => isDeparture
                            ? ctrl.selectAsDeparture(airport)
                            : ctrl.selectAsArrival(airport),
                        isSelected: isDeparture
                            ? ctrl.departureAirport.value?.code == airport.code
                            : ctrl.arrivalAirport.value?.code == airport.code,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty / Error States
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 52.sp, color: Colors.grey[300]),
          Gap(12.h),
          Text(
            'No airports found',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Gap(4.h),
          Text(
            'Try a different name or IATA code',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 52.sp, color: Colors.grey[300]),
            Gap(12.h),
            Text(
              'Could not load airports',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Gap(6.h),
            Text(
              message,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
            Gap(20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded, size: 18.sp),
              label: Text('Retry', style: TextStyle(fontSize: 13.sp)),
            ),
          ],
        ),
      ),
    );
  }
}