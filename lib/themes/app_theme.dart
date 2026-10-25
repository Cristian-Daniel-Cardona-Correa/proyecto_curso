import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de diseño Zeris con paleta índigo-violeta sobre neutros fríos.
class AppTheme {
  AppTheme._();

  // ─── Paleta de Colores Zeris ───────────────────────────────────────────────
  static const Color pageDark = Color(0xFF0B0B12);
  static const Color surfacePanel = Color(0xFF151625);
  static const Color surfacePanelElevated = Color(0xFF1E2038);
  static const Color borderSubtle = Color(0x337C3AED);
  static const Color borderSubtleHover = Color(0x666366F1);

  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color primaryIndigoDeep = Color(0xFF4F46E5);
  static const Color accentViolet = Color(0xFF7C3AED);

  static const Color textPrimary = Color(0xFFEEEDF7);
  static const Color textSecondary = Color(0xFF8E8EA8);
  static const Color kickerText = Color(0xFFA5A0F0);

  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);

  // ─── Radios Zeris ──────────────────────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusPill = 9999.0;

  // ─── Gradiente CTA Zeris ───────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryIndigo, accentViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Sombras ───────────────────────────────────────────────────────────────
  static const List<BoxShadow> panelShadow = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  // ─── Estilos de Texto Kicker ───────────────────────────────────────────────
  static TextStyle get kickerStyle => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
        color: kickerText,
      );

  // ─── ThemeData Oficial de la App ───────────────────────────────────────────
  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final textTheme = GoogleFonts.interTextTheme(baseTextTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pageDark,
      primaryColor: primaryIndigo,
      canvasColor: pageDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryIndigo,
        secondary: accentViolet,
        surface: surfacePanel,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.4,
        ),
        labelSmall: kickerStyle,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: pageDark.withAlpha(235),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfacePanel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryIndigoDeep,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
