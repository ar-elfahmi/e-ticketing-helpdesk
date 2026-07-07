import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Primary colors - Forest Green palette
  static const Color primary = Color(0xFF5C7A52); // Medium Forest Green
  static const Color primaryDark = Color(0xFF2F4530); // Deep Forest Green
  static const Color primaryLight = Color(0xFF3E5A37); // Forest Green Dark
  static const Color secondary = Color(0xFFE9C97B); // Golden Warm accent
  static const Color authGradientStart = primaryDark;
  static const Color authGradientEnd = primary;
  static const Color authGlowDark = Color(0x332F4530);
  static const Color authGlowPrimary = Color(0x335C7A52);
  static const Color authGlowAccent = Color(0x33E9C97B);

  // Semantic colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF5A524);
  static const Color danger = Color(0xFFEF4444);

  // Light theme colors
  static const Color bgLight = Color(0xFFF4EEDD); // Warm Cream background
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color cardWarmLight = Color(0xFFEFE7D5); // Light Cream
  static const Color textLight = Color(0xFF1A2E1F); // Darker Forest Green for better contrast
  static const Color textSecondary = Color(0xFF3E4D43); // Medium text color
  static const Color borderLight = Color(0xFF2F4530); // Deep Forest Green at opacity

  // Dark theme colors
  static const Color bgDark = Color(0xFF111827);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textDark = Color(0xFFF8FAFC);

  static const Color statusOpen = Color(0xFF2F80ED);
  static const Color statusInProgress = Color(0xFFF2C94C);
  static const Color statusClosed = Color(0xFF27AE60);
}
