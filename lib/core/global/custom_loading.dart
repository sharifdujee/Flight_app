

import 'package:flight_app/core/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/custom_dialog.dart';

class CustomLoading extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;

  const CustomLoading({
    super.key,
    this.color = AppColors.textColor,
    this.size = 60.0,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(color: color, size: size, duration: duration);
  }
}


// your existing custom dialog widget

class CustomErrorDialog {
  static void show(
      String title, [
        String? message,
        VoidCallback? onPressed,
      ]) {
    // Ensure any loading dialog is closed first
    if (Get.isDialogOpen ?? false) Get.back();

    showCustomDialog(
      Get.context!,
      imagePath: ImagePath.failure,
      title: title,
      message: message ?? "Please try again later.",
      buttonText: "OK",
      onPressed: onPressed ?? () => Get.back(),
    );
  }

  /// Optional: For API errors specifically
  static void showApiError(String? message) {
    show(
      "Request Failed",
      message ?? "Unable to connect to the server. Please try again.",
    );
  }

  /// Optional: For network or unexpected exceptions
  static void showException(Object error) {
    show(
      "Unexpected Error",
      error.toString(),
    );
  }
}
