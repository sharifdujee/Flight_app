
import 'package:flight_app/core/global/custom_loading.dart';
import 'package:flight_app/core/global/custom_text.dart';
import 'package:flight_app/core/global/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/airport_controller.dart';
import 'airport_error_view.dart';
import 'airport_list_section.dart';
import 'empty_airport_view.dart';

class AirportPickerSheet extends StatelessWidget {
  AirportPickerSheet({super.key, required this.isDeparture});

  final bool isDeparture;
  final AirportController airportController = Get.find<AirportController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
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
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(14.h),
              // Header
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: isDeparture
                              ? 'Departure Airport'
                              : 'Arrival Airport',

                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        CustomText(
                          text: 'Search or scroll to select',

                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(14.h),
              // Search bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextFormField(
                  containerColor: AppColors.primary,
                  hintTextColor: AppColors.primaryLight,
                  prefixIcon: Icon(Icons.search),
                  controller: airportController.searchController,
                  hintText: "Search airport name or IATA code",
                ),
              ),
              Gap(10.h),
              // Results count
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(
                  () => Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 13.sp,
                        color: AppColors.textHint,
                      ),
                      Gap(4.w),
                      CustomText(
                        text:
                            '${airportController.filteredAirports.length} airports',

                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              Gap(6.h),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),

              Expanded(
                child: Obx(() {
                  if (airportController.isLoading.value) {
                    return Center(
                      child: CustomLoading(color: AppColors.primary),
                    );
                  }
                  if (airportController.hasError.value) {
                    return AirportErrorView(
                      message: airportController.errorMessage.value,
                      onRetry: airportController.getAirPortList,
                    );
                  }
                  if (airportController.filteredAirports.isEmpty) {
                    return const EmptyAirport();
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: airportController.filteredAirports.length,
                    itemBuilder: (_, i) {
                      final airport = airportController.filteredAirports[i];
                      final selected = isDeparture
                          ? airportController.departureAirport.value?.code ==
                                airport.code
                          : airportController.arrivalAirport.value?.code ==
                                airport.code;
                      return AirportListSection(
                        airport: airport,
                        isSelected: selected,
                        onTap: () {
                          if (isDeparture) {
                            airportController.selectAsDeparture(airport);
                          } else {
                            airportController.selectAsArrival(airport);
                          }
                        },
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


