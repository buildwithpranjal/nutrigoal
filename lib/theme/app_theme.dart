import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette pulled directly from the Figma CSS export (screen 01).
/// These are treated as global design tokens since the same values
/// (background, text colors, card border, primary green) are reused
/// consistently across a single design system rather than being
/// one-off choices for a single screen.
class AppColors {
  static const Color primaryGreen = Color(0xFF0F8A5F);
  static const Color background = Color(0xFFF4F6F1);
  static const Color card = Colors.white;
  static const Color cardTint = Color(0xFFE4F3EC);

  static const Color textDark = Color(0xFF16241C);
  static const Color textGrey = Color(0xFF66756B);
  static const Color labelDark = Color(0xFF33413A);

  /// Border used on large content cards (feature card, dashboard ring
  /// card, meal-item cards).
  static const Color cardBorder = Color(0xFFECEEE7);

  /// Border used on smaller interactive controls (inputs, buttons,
  /// back-button chip, bottom-nav divider, unselected goal option).
  static const Color controlBorder = Color(0xFFE4E7DE);

  /// Neutral fill used for progress-bar tracks and unselected icon chips.
  static const Color trackGrey = Color(0xFFEEF1E9);

  static const Color carbs = Color(0xFFF2884B);
  static const Color fat = Color(0xFF7B6EF0);

  static const Color successText = Color(0xFF0B6E4C);
  static const Color doneGreen = Color(0xFF2FA36B);
  static const Color coachDark = Color(0xFF123A2B);
  static const Color coachBody = Color(0xFFD8ECE0);
  static const Color peachTint = Color(0xFFFDEADD);
  static const Color logoutRed = Color(0xFFE5533D);
  static const Color avatarGradientStart = Color(0xFFCDE7A9);
  static const Color avatarTextDark = Color(0xFF0B3826);

  static const Color streak = Color(0xFFFF7A45);
  static const Color goalHit = Color(0xFF0F8A5F);
}

/// Text style helpers matching the two typefaces named in the Figma
/// export: Bricolage Grotesque for display/heading text, Plus Jakarta
/// Sans for everything else. Both are fetched via google_fonts at
/// runtime (requires internet on first load; cached after).
class AppText {
  static TextStyle display({
    double size = 34,
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.textDark,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing ?? (size * -0.02),
        height: height,
      );

  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textDark,
    double? height,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppText.body(size: 18, weight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: AppText.body(size: 16, weight: FontWeight.w700, color: Colors.white),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: AppColors.controlBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: AppText.body(size: 15, weight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.controlBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.controlBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.4),
        ),
        hintStyle: AppText.body(size: 15, color: AppColors.textGrey),
      ),
    );
  }
}

/// Shared card decoration used everywhere instead of ThemeData.cardTheme,
/// so this file has no dependency on the CardTheme/CardThemeData type that
/// changed between Flutter versions.
BoxDecoration softCard({Color? color, double radius = 18}) => BoxDecoration(
      color: color ?? AppColors.card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.cardBorder),
    );
