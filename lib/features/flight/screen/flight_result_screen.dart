import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../airport/data/airport_data.dart';
import '../controller/flight_controller.dart';
import '../data/flight_data.dart';
import '../presentation/widget/flight_widget.dart';

class FlightResultsScreen extends StatefulWidget {
  const FlightResultsScreen({
    super.key,
    required this.departure,
    required this.arrival,
  });

  final Airport departure;
  final Airport arrival;

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  final FlightController ctrl = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.searchFlights(
        departure: widget.departure.code,
        arrival: widget.arrival.code,
      );
    });
  }

  // FIX: no local _activeFilter setState — delegate entirely to controller
  void _onFilterChanged(int index) {
    ctrl.applyFilter(FlightFilter.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: _RouteHeader(
              departure: widget.departure,
              arrival: widget.arrival,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Obx(() {
                  if (!ctrl.hasSearched.value && !ctrl.isLoading.value) {
                    return const SizedBox.shrink();
                  }
                  // FIX: reads ctrl.activeFilterIndex.value (RxInt) so Obx
                  // re-renders the bar whenever the active chip changes.
                  return FlightFilterBar(
                    active: ctrl.activeFilterIndex.value,
                    onChanged: _onFilterChanged,
                  );
                }),
              ),
            ),
          ),
        ],
        body: Obx(() {
          if (ctrl.isLoading.value) {
            return const FlightLoadingWidget();
          }
          if (ctrl.hasError.value) {
            return _ErrorView(
              message: ctrl.errorMessage.value,
              onRetry: () => ctrl.searchFlights(
                departure: widget.departure.code,
                arrival: widget.arrival.code,
              ),
            );
          }
          if (ctrl.hasSearched.value && ctrl.displayedFlights.isEmpty) {
            return const FlightNoResultsWidget();
          }
          if (!ctrl.hasSearched.value) {
            return const SizedBox.shrink();
          }
          return _FlightList(
            flights: ctrl.displayedFlights,
            priceInsights: ctrl.priceInsights.value,
          );
        }),
      ),
    );
  }
}

// ─── Header showing route ─────────────────────────────────────────────────────
class _RouteHeader extends StatelessWidget {
  const _RouteHeader({required this.departure, required this.arrival});
  final Airport departure;
  final Airport arrival;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          departure.code,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Icon(Icons.arrow_forward_rounded, size: 16.sp, color: Colors.white70),
        ),
        Text(
          arrival.code,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        Gap(8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'One way',
            style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ─── Flight list with price summary banner ────────────────────────────────────
class _FlightList extends StatelessWidget {
  const _FlightList({required this.flights, this.priceInsights});
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
          return _PriceInsightBanner(insights: priceInsights!);
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

// ─── Price insights banner ────────────────────────────────────────────────────
class _PriceInsightBanner extends StatelessWidget {
  const _PriceInsightBanner({required this.insights});
  final PriceInsights insights;

  Color get _levelColor {
    switch (insights.priceLevel) {
      case 'low':
        return AppColors.success;
      case 'high':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String get _levelLabel {
    switch (insights.priceLevel) {
      case 'low':
        return 'Low prices now';
      case 'high':
        return 'Prices are high';
      default:
        return 'Typical prices';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _levelColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _levelColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            insights.priceLevel == 'low'
                ? Icons.trending_down_rounded
                : insights.priceLevel == 'high'
                ? Icons.trending_up_rounded
                : Icons.trending_flat_rounded,
            size: 18.sp,
            color: _levelColor,
          ),
          Gap(8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _levelLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: _levelColor,
                  ),
                ),
                if (insights.typicalPriceRange.length == 2)
                  Text(
                    'Typical: \$${insights.typicalPriceRange[0]}–\$${insights.typicalPriceRange[1]}',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          Text(
            'from \$${insights.lowestPrice}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────
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
            Icon(Icons.wifi_off_rounded, size: 64.sp, color: Colors.grey[300]),
            Gap(16.h),
            Text(
              'Could not load flights',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            Gap(6.h),
            Text(
              message,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
            Gap(24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}