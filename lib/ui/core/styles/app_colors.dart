import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color.fromRGBO(94, 114, 228, 1);
  static const Color primaryGradientEnd = Color.fromRGBO(130, 94, 228, 1);

  // Semantic Colors
  static const Color success = Color.fromRGBO(76, 175, 80, 1);
  static const Color warning = Color.fromRGBO(255, 152, 0, 1);
  static const Color error = Color.fromRGBO(244, 67, 54, 1);
  static const Color errorLight = Color.fromRGBO(239, 83, 80, 1);
  static const Color errorBackground = Color.fromRGBO(255, 235, 238, 1);

  // Background Colors
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color softWhite = Color.fromRGBO(248, 249, 251, 1);
  static const Color background = Color.fromRGBO(245, 245, 245, 1);

  // Text Colors
  static const Color textPrimary = Color.fromRGBO(33, 33, 33, 1);
  static const Color textSecondary = Color.fromRGBO(97, 97, 97, 1);
  static const Color textTertiary = Color.fromRGBO(117, 117, 117, 1);
  static const Color textHint = Color.fromRGBO(158, 158, 158, 1);
  static const Color textDisabled = Color.fromRGBO(189, 189, 189, 1);

  // Grey Scale
  static const Color gray = Color.fromRGBO(73, 74, 76, 1);
  static const Color darkGray = Color.fromRGBO(50, 50, 52, 1);
  static const Color softGray = Color.fromRGBO(151, 151, 151, 1);
  static const Color grey200 = Color.fromRGBO(238, 238, 238, 1);
  static const Color grey300 = Color.fromRGBO(224, 224, 224, 1);

  // Border (usa grey300)
  static const Color border = grey300;

  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.04);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.2);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
