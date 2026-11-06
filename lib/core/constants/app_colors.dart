import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============================================================================
  // 1. LIGHT MODE TOKENS (Sesuai Web NexedAI - Ultra-Clean Minimalist SaaS)
  // ============================================================================
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  static const Color lightPillBg = Color(0xFFF1F5F9);
  static const Color lightButtonPrimary = Color(0xFF0F172A); // Tombol hitam solid
  static const Color lightButtonText = Color(0xFFFFFFFF);

  // ============================================================================
  // 2. DARK MODE TOKENS (Elegan & Modern Minimalist)
  // ============================================================================
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkBorder = Color(0xFF1F2937);
  static const Color darkBorderSubtle = Color(0xFF374151);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF64748B);
  static const Color darkPillBg = Color(0xFF1E293B);
  static const Color darkButtonPrimary = Color(0xFFF8FAFC);
  static const Color darkButtonText = Color(0xFF0F172A);

  // ============================================================================
  // 3. UNIVERSAL ACCENTS (Halus, tidak norak)
  // ============================================================================
  static const Color electricSky = Color(0xFF0284C7);
  static const Color violetAi = Color(0xFF7C3AED);
  static const Color successGreen = Color(0xFF10B981);
  static const Color amberBadge = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ============================================================================
  // 4. ADAPTIVE DUAL-THEME HELPERS
  // ============================================================================
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bg(bool isDark) => isDark ? darkBackground : lightBackground;
  static Color surface(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color borderColor(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color borderSubtle(bool isDark) =>
      isDark ? darkBorderSubtle : lightBorderSubtle;
  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;
  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;
  static Color textMutedColor(bool isDark) =>
      isDark ? darkTextMuted : lightTextMuted;
  static Color pillBg(bool isDark) => isDark ? darkPillBg : lightPillBg;
  static Color buttonPrimary(bool isDark) =>
      isDark ? darkButtonPrimary : lightButtonPrimary;
  static Color buttonText(bool isDark) =>
      isDark ? darkButtonText : lightButtonText;

  // ============================================================================
  // 5. COMPATIBILITY ALIASES FOR LEGACY MODULES
  // ============================================================================
  static const Color primaryNavy = darkBackground;
  static const Color background = lightBackground;
  static const Color cardBackground = lightSurface;
  static const Color surfaceCard = darkSurface;
  static const Color surfaceCardMuted = darkPillBg;
  static const Color cardBorder = lightBorder;
  static const Color border = darkBorder;
  static const double cardBorderWidth = 1.0;
  // ignore: deprecated_member_use
  static final Color surfaceGlowBorder = electricSky.withOpacity(0.15);

  static const Color accentCyan = electricSky;
  static const Color skyLight = electricSky;
  static const Color deepRoyal = Color(0xFF2563EB);
  static const Color aiCognitiveAccent = violetAi;
  static const Color gamificationGold = amberBadge;
  static const Color xpGold = amberBadge;
  static const Color successMint = successGreen;
  static const Color success = successGreen;

  static const Color textWhite = darkTextPrimary;
  static const Color textMuted = lightTextSecondary;
  static const Color textSubtle = lightTextMuted;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF090D16)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient xpGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
