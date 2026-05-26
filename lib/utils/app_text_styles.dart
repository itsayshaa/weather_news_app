import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {

  static const TextStyle heading =
  TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subHeading =
  TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body =
  TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle small =
  TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle whiteHeading =
  TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle whiteBody =
  TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  static const TextStyle cardTitle =
  TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle chipText =
  TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}