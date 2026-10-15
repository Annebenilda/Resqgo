import 'package:flutter/material.dart';

class AppColors {
  // ResQGo Brand Red Primary
  static const Color primaryRed = Color(0xFFE53935);
  static const Color redDark = Color(0xFFC62828);
  static const Color redLight = Color(0xFFFFEBEE);
  static const Color redAccent = Color(0xFFFF5252);
  static const Color redGlow = Color(0x33E53935);

  // Eco & EV Green Primary
  static const Color evGreen = Color(0xFF00C853);
  static const Color evGreenDark = Color(0xFF1B5E20);
  static const Color evGreenLight = Color(0xFFE8F5E9);
  static const Color evGreenAccent = Color(0xFF00E676);
  static const Color evGreenGlow = Color(0x3300C853);

  // Light Theme Palette (Active Default)
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Colors.white;
  static const Color surfaceLight = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Active Screen Tokens (Configured for Light Theme)
  static const Color bgDark = Color(0xFFF8FAFC); // Light canvas
  static const Color cardDark = Colors.white; // Pure white card
  static const Color surfaceDark = Color(0xFFF1F5F9); // Light slate inputs/chips
  static const Color borderDark = Color(0xFFE2E8F0); // Crisp subtle border

  // Text Colors (Light Theme Active)
  static const Color textPrimary = Color(0xFF0F172A); // High contrast dark slate
  static const Color textSecondary = Color(0xFF64748B); // Muted slate secondary
  static const Color textLight = Color(0xFF0F172A); // Primary reading text
  static const Color textLightSecondary = Color(0xFF64748B); // Subtitle & helper text

  // True Dark Theme Palette (Preserved for darkTheme)
  static const Color trueBgDark = Color(0xFF0F172A);
  static const Color trueCardDark = Color(0xFF1E293B);
  static const Color trueSurfaceDark = Color(0xFF334155);
  static const Color trueBorderDark = Color(0xFF475569);
  static const Color trueTextLight = Color(0xFFF8FAFC);
  static const Color trueTextLightSecondary = Color(0xFF94A3B8);

  // Accents & Statuses
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color infoBlue = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color purple = Color(0xFF7C3AED);
}
