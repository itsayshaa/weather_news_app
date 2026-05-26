import 'package:flutter/material.dart';

enum AppThemeType {
  ocean,
  sunset,
  forest,
  midnight,
  aurora,
}

class AppThemeColors {
  final String name;
  final Color primary;
  final Color secondary;
  final Color darkBg;
  final Color lightBg;
  final Color accent;
  final List<Color> gradientColors;
  final IconData icon;

  const AppThemeColors({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.darkBg,
    required this.lightBg,
    required this.accent,
    required this.gradientColors,
    required this.icon,
  });
}

class AppColors {

  static const Color primary = Color(0xff4facfe);
  static const Color secondary = Color(0xff00f2fe);
  static const Color darkBlue = Color(0xff0f172a);
  static const Color lightBlue = Color(0xff38bdf8);
  static const Color background = Color(0xfff8fafc);
  static const Color cardColor = Colors.white;
  static const Color glassColor = Colors.white24;
  static const Color textPrimary = Color(0xff0f172a);
  static const Color textSecondary = Color(0xff64748b);
  static const Color white = Colors.white;
  static const Color success = Color(0xff22c55e);
  static const Color warning = Color(0xfff59e0b);
  static const Color error = Color(0xffef4444);
  static const Color sunny = Color(0xffffb703);
  static const Color cloudy = Color(0xff94a3b8);
  static const Color rainy = Color(0xff3b82f6);
  static const Color storm = Color(0xff7c3aed);

  static const Map<AppThemeType, AppThemeColors> themes = {
    AppThemeType.ocean: AppThemeColors(
      name: 'Ocean',
      primary: Color(0xff4facfe),
      secondary: Color(0xff00f2fe),
      darkBg: Color(0xff0a1628),
      lightBg: Color(0xfff0f8ff),
      accent: Color(0xff00f2fe),
      gradientColors: [Color(0xff0a1628), Color(0xff1e3a5f), Color(0xff4facfe)],
      icon: Icons.water,
    ),
    AppThemeType.sunset: AppThemeColors(
      name: 'Sunset',
      primary: Color(0xffff6b6b),
      secondary: Color(0xfffeca57),
      darkBg: Color(0xff1a0a0a),
      lightBg: Color(0xfffff5f5),
      accent: Color(0xffff9f43),
      gradientColors: [Color(0xff1a0a0a), Color(0xff4a1942), Color(0xffff6b6b)],
      icon: Icons.wb_sunny,
    ),
    AppThemeType.forest: AppThemeColors(
      name: 'Forest',
      primary: Color(0xff2ed573),
      secondary: Color(0xff7bed9f),
      darkBg: Color(0xff0a1a0e),
      lightBg: Color(0xfff0fff4),
      accent: Color(0xff00b894),
      gradientColors: [Color(0xff0a1a0e), Color(0xff1a3d24), Color(0xff2ed573)],
      icon: Icons.forest,
    ),
    AppThemeType.midnight: AppThemeColors(
      name: 'Midnight',
      primary: Color(0xffa29bfe),
      secondary: Color(0xfffd79a8),
      darkBg: Color(0xff0d0d1a),
      lightBg: Color(0xfff5f0ff),
      accent: Color(0xffe17055),
      gradientColors: [Color(0xff0d0d1a), Color(0xff2d1b69), Color(0xffa29bfe)],
      icon: Icons.nightlight_round,
    ),
    AppThemeType.aurora: AppThemeColors(
      name: 'Aurora',
      primary: Color(0xff00cec9),
      secondary: Color(0xff6c5ce7),
      darkBg: Color(0xff050e1a),
      lightBg: Color(0xfff0ffff),
      accent: Color(0xffe84393),
      gradientColors: [Color(0xff050e1a), Color(0xff0a2a3a), Color(0xff00cec9)],
      icon: Icons.auto_awesome,
    ),
  };
}
