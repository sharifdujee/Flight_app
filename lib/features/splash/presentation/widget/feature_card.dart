import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import 'feature_chip.dart';


class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FeatureChip(
          icon: Icons.verified_user_rounded,
          iconColor: AppColors.primary,
          label: 'Safe & Secure',
          sub: 'Verified flights',
        ),
        Gap(10.w),
        FeatureChip(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.success,
          label: 'Best Prices',
          sub: 'Real-time deals',
        ),
        Gap(10.w),
        FeatureChip(
          icon: Icons.access_time_rounded,
          iconColor: AppColors.warning,
          label: '24/7 Support',
          sub: 'Always here',
        ),
      ],
    );
  }
}