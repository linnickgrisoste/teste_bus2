import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppThemes {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.robotFamily,
      scaffoldBackgroundColor: AppColors.background,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.grey200,
      ),
    );
  }
}
