import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeType _currentTheme = AppThemeType.ocean;

  AppThemeType get currentTheme => _currentTheme;

  AppThemeColors get colors => AppColors.themes[_currentTheme]!;

  List<Color> get gradientColors => colors.gradientColors;

  Color get primary => colors.primary;
  Color get secondary => colors.secondary;
  Color get darkBg => colors.darkBg;
  Color get accent => colors.accent;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('theme_index') ?? 0;
    _currentTheme = AppThemeType.values[savedIndex];
    notifyListeners();
  }

  Future<void> setTheme(AppThemeType theme) async {
    _currentTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_index', theme.index);
    notifyListeners();
  }
}