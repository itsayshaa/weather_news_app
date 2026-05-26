import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/theme_provider.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData buildTheme(ThemeProvider themeProvider) {
    final colors = themeProvider.colors;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.lightBg,
      primaryColor: colors.primary,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: colors.primary),
      cardTheme: CardThemeData(
        elevation: 10,
        color: AppColors.cardColor,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.primary,
        selectedColor: colors.secondary,
        disabledColor: Colors.grey,
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}
