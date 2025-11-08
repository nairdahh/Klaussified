import 'package:flutter/material.dart';

/// Klaussified Color Palette - Christmas Theme
/// Modify these values to change the app's color scheme
class AppColors {
  // Primary Colors - Christmas Theme
  static const Color christmasRed = Color(0xFFD32F2F);
  static const Color christmasGreen = Color(0xFF388E3C);
  static const Color snowWhite = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color goldAccent = Color(0xFFFFD700);

  // Secondary Colors
  static const Color lightRed = Color(0xFFEF5350);
  static const Color paleGreen = Color(0xFFC8E6C9);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnRed = Color(0xFFFFFFFF);
  static const Color textOnGreen = Color(0xFFFFFFFF);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // Dividers & Borders
  static const Color divider = Color(0xFFBDBDBD);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);

  // Shadows
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);

  // Overlay Colors
  static const Color overlayLight = Color(0x0D000000);
  static const Color overlayMedium = Color(0x1F000000);
  static const Color overlayDark = Color(0x66000000);

  // Disabled Colors
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledText = Color(0xFF9E9E9E);

  // Special Colors
  static const Color picked = lightGreen; // Green checkmark for picked status
  static const Color pending = warning;   // Orange for pending actions
  static const Color closed = textSecondary; // Gray for closed groups
}
