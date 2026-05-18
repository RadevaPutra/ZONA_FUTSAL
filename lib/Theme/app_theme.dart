import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color darkGreen = Color(0xFF0F3D2E);
  static const Color medGreen = Color(0xFF1A5A3E);
  static const Color accent = Color(0xFF4ADE80);
  static const Color accentDim = Color(0xFF86EFAC);

  // Neutrals
  static const Color bg = Color(0xFFF5F5F0);
  static const Color white = Colors.white;
  static const Color border = Color(0xFFE5E5E0);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary =
  Color(0xFF888888);
  static const Color cardBg = Color(0xFFF0F0EA);

  // Semantic
  static const Color available = Color(0xFF4ADE80);
  static const Color busy = Color(0xFFFACC15);
  static const Color busyText = Color(0xFF3D2E0F);
  static const Color availText = Color(0xFF0F3D2E);
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: -0.3,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );

  static const TextStyle price = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.accent,
  );
}