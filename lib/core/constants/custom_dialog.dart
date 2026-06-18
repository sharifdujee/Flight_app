

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../global/custom_button.dart';
import '../global/custom_text.dart';
import 'app_colors.dart';

void showCustomDialog(
    BuildContext context, {
      required String imagePath,
      required String title,
      String? message,
      required String buttonText,
      String? secondButtonText, // Optional second button label
      void Function()? onPressed,
      void Function()? onSecondPressed,
      bool isDoubleButton = false, // ✅ new parameter
    }) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  showDialog(

    /// Rounded the corner
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 20.r),
          decoration: BoxDecoration(
            color:
            Get.isDarkMode
                ? const Color.fromARGB(255, 37, 37, 37)
                : Colors.white,
            borderRadius: BorderRadius.circular(32.r),
          ),
          width: 320.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, height: 122.h, width: 200.w),

              SizedBox(height: 20.h),

              CustomText(
                text: title,
                textAlign: TextAlign.center,
                fontSize: 20.spMin,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.heading : AppColors.textColor,
              ),

              if (message != null && message.isNotEmpty) ...[
                SizedBox(height: 10.h),
                CustomText(
                  text: message,

                  ///color: const Color(0xff636F85),
                  textAlign: TextAlign.center,
                  fontSize: 14.spMin,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? AppColors.heading : AppColors.textColor,
                ),
              ],

              SizedBox(height: 20.h),

              isDoubleButton
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      isOutlined: true,
                      textColor: AppColors.primary,
                      text: buttonText,
                      onPressed: onPressed ?? () {},
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      textColor: Colors.white,
                      text: secondButtonText ?? 'Cancel',
                      onPressed:
                      onSecondPressed ??
                              () {
                            Navigator.pop(context);
                          },
                    ),
                  ),
                ],
              )
                  : CustomButton(
                text: buttonText,
                textColor: Colors.white,
                onPressed: onPressed ?? () {},
              ),
            ],
          ),
        ),
      );
    },
  );
}