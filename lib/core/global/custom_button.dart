import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final double height;
  final double width;
  final Widget? image;
  final TextStyle? textStyle;
  final bool isOutlined;
  final bool isCircle;
  final Color? outlineColor;
  final IconData? prefixIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.textColor,
    this.borderRadius = 99,
    this.elevation = 4.0,
    this.height = 50,
    this.width = double.infinity,
    this.textStyle,
    this.isOutlined = false,
    this.isCircle = false,
    this.image,
    this.outlineColor,
    this.prefixIcon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _scale = 0.95;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() {
        _scale = 1.0;
      });
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      setState(() {
        _scale = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    final bgColor = widget.isOutlined
        ? Colors.transparent
        : (isDisabled
              ? widget.backgroundColor.withValues(alpha: 0.5)
              : widget.backgroundColor);

    final borderColor = widget.isOutlined
        ? (isDisabled
              ? (widget.outlineColor ?? AppColors.primary).withValues(
                  alpha: 0.5,
                )
              : widget.outlineColor ?? AppColors.primary)
        : Colors.transparent;

    final textColor = widget.isOutlined
        ? (isDisabled
              ? (widget.outlineColor ?? AppColors.primary).withValues(
                  alpha: 0.5,
                )
              : widget.outlineColor ?? AppColors.primary)
        : (isDisabled ? widget.textColor.withValues(alpha: 0.5) : widget.textColor);

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: widget.height,
            width: widget.isCircle ? widget.height : widget.width,
            padding: EdgeInsets.symmetric(vertical: 5.r, horizontal: 12.w),
            decoration: BoxDecoration(
              color: bgColor,
              shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: widget.isCircle
                  ? null
                  : BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: widget.isCircle
                ? Center(child: widget.image)
                : Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.prefixIcon != null) ...[
                    Icon(
                      widget.prefixIcon,
                      size: 20.sp,
                      color: AppColors.primaryLight,
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(                          // ← removed Expanded wrapper
                    widget.text,
                    textAlign: TextAlign.center,
                    style:
                    widget.textStyle ??
                        GoogleFonts.poppins(
                          decoration: TextDecoration.none,
                          color: textColor,
                          fontSize: 16.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
                  ),
          ),
        ),
      ),
    );
  }
}
