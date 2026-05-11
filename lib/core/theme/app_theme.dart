import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdg_campus_coffee/core/theme/app_fonts.dart';

class AppColors {
  static const Color bgDark = Color(0xFF1A1008);
  static const Color bgCard = Color(0xFF231A0E);
  static const Color bgElevated = Color(0xFF2A1F10);
  static const Color gold = Color(0xFFC8922A);
  static const Color goldLight = Color(0xFFE0A83A);
  static const Color textPrimary = Color(0xFFF5ECD7);
  static const Color textSecondary = Color(0xFF9A8A74);
  static const Color textMuted = Color(0xFF5A4A38);
  static const Color border = Color(0xFF3A2A18);
  static const Color navBg = Color(0xFF160E04);

  // Functional Palette
  static const Color tagBold = Color(0xFFC8922A); // Gold
  static const Color tagIntense = Color(0xFF9E5434); // Burnt Siena / Coffee Brick
  static const Color tagSmooth = Color(0xFF4E6B8A); // Muted Slate Blue
  static const Color tagMild = Color(0xFF6B7D5D); // Muted Sage
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      fontFamily: 'Inter',
      textTheme: const TextTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
        fontFamily: 'Inter',
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        surface: AppColors.bgCard,
        onPrimary: AppColors.bgDark,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppFonts.playfairDisplay(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navBg,
        indicatorColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppFonts.inter(
            color: selected ? AppColors.gold : AppColors.textMuted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.gold : AppColors.textMuted,
            size: 22,
          );
        }),
      ),
    );
  }
}
