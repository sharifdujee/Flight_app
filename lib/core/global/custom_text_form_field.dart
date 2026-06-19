

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final String? prefixIconPath;
  final ValueChanged<String>? onChanged;
  final bool readonly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final int? maxLines;
  final InputBorder? focusedBorder;
  final Color? containerColor;
  final Color? hintTextColor;
  final double? hintTextSize;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final double? borderRadius;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.readonly = false,
    this.prefixIconPath,
    this.maxLines = 1,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.containerColor = const Color(0xffF9FAFB),
    this.hintTextColor = AppColors.profileTextColor,
    this.hintTextSize = 15,
    this.suffixText,
    this.suffixTextStyle,
    this.validator,
    this.prefixIcon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        ///borderRadius: BorderRadius.circular(borderRadius??4)
      ),
      /*decoration: BoxDecoration(
        color:isDarkMode?Color(0xff171717) : Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(4),
      ),*/
      child: TextFormField(
        controller: controller,
        readOnly: readonly,
        obscureText: obscureText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.poppins(
          fontSize: 16.w,
          fontWeight: FontWeight.w400,
          color:isDarkMode?AppColors.primaryLight: AppColors.headerColor,
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: isDarkMode? AppColors.textSecondary : Colors.white ,
          prefixIcon:
          prefixIcon ??
              ((prefixIconPath != null)
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  SizedBox(width: getWidth(20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      prefixIconPath!,
                      height: 26.h,
                      width: 26.w,
                    ),
                  ),
                  //  SizedBox(width: getWidth(10)),
                ],
              )
                  : null),
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          suffixStyle:
          suffixTextStyle ??
              GoogleFonts.poppins(
                fontSize: 12.w,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: hintTextSize ?? 15.w,
            fontWeight: FontWeight.w400,
            color: hintTextColor ?? AppColors.headerColor,
          ),
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
          focusedErrorBorder: focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                borderSide: BorderSide(color: AppColors.error),
              ),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),

          errorBorder: InputBorder.none,

          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }
}