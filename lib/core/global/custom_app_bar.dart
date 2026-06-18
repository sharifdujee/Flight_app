import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.bottom,
    this.backgroundColor = AppColors.primary,
    this.leading,
    this.centerTitle = false,
    this.bottomHeight = 0,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? bottom;
  final Color backgroundColor;
  final Widget? leading;
  final bool centerTitle;
  final double bottomHeight;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + bottomHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
      title: titleWidget ??
          (title != null
              ? Text(
            title!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
              : null),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
        preferredSize: Size.fromHeight(bottomHeight),
        child: bottom!,
      )
          : null,
    );
  }
}