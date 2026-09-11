import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The small rounded-rect "back" chip reused on Login and Goal screens:
/// 40x20, white background, 1px controlBorder, radius 12.
class PillBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double width;
  final double height;
  final Color background;
  const PillBackButton({
    super.key,
    this.onTap,
    this.width = 40,
    this.height = 20,
    this.background = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: AppColors.controlBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 12, color: AppColors.textDark),
      ),
    );
  }
}
