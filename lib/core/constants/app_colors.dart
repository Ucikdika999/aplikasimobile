import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background & Cards (Sesuai Web NexedAI - Next.js Slate/Cyan Theme)
  static const Color primaryNavy = Color(0xFF070B14);
  static const Color background = Color(0xFF070B14); // Deep Midnight Canvas
  static const Color cardBackground = Color(0xFF0F172A); // Slate 900
  static const Color surfaceCard = Color(0xFF0F172A); // Slate 900
  static const Color surfaceCardMuted = Color(0xFF161E2E);
  static const Color cardBorder = Color(0xFF1E293B); // Slate 800
  static const Color border = Color(0xFF1E293B); // Slate 800
  static const double cardBorderWidth = 1.0;
  // ignore: deprecated_member_use
  static final Color surfaceGlowBorder = const Color(0xFF38BDF8).withOpacity(0.15);

  // Aksen & Gradien Karakteristik
  static const Color electricSky = Color(0xFF0EA5E9); // Primary
  static const Color accentCyan = Color(0xFF0EA5E9); // Primary alias
  static const Color skyLight = Color(0xFF38BDF8); // Sky 400
  static const Color deepRoyal = Color(0xFF2563EB); // Secondary
  static const Color aiCognitiveAccent = Color(0xFF8B5CF6); // Purple/Indigo
  static const Color gamificationGold = Color(0xFFF59E0B);
  static const Color xpGold = Color(0xFFF59E0B); // Alias
  static const Color successMint = Color(0xFF10B981);
  static const Color success = Color(0xFF10B981); // Alias
  static const Color error = Color(0xFFEF4444);

  // Text Colors
  static const Color textWhite = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textSubtle = Color(0xFF64748B);

  // Linear Gradient XP & Primary
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
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
