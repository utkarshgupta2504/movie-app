import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0F172A);
  static const Color secondary = Color(0xFF1E293B);
  static const Color accent = Color(0xFFFF6B35);
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color cardBackground = Color(0xFF334155);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);

  static const Color shimmerBase = Color(0xFF334155);
  static const Color shimmerHighlight = Color(0xFF475569);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, cardBackground],
  );
}
