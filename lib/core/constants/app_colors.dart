import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Nexed AI Brand Palette
  static const Color primaryNavy = Color(0xFF0B0F19);
  static const Color background = Color(0xFF0B0F19);
  static const Color surfaceCard = Color(0xFF1E293B);
  static const Color surfaceCardMuted = Color(0xFF161E2E);
  static const Color border = Color(0xFF334155);

  // Accents
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color xpGold = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Text Colors
  static const Color textWhite = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textSubtle = Color(0xFF64748B);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient xpGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
