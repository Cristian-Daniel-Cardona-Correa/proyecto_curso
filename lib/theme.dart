import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tokens de diseño extraídos fielmente de Zeris Fitness Platform (SvelteKit).
/// Traducidos de OKLCH y CSS custom properties a constantes ARGB en Flutter.
class ZerisColors {
  ZerisColors._();

  // ─── Colores de Superficie y Página (Dark Mode) ───────────────────────────
  /// --fp-page oscuro: oklch(0.12 0.028 274) ≈ #0B0B12
  static const Color page = Color(0xFF0B0B12);

  /// --fp-panel-bg oscuro: oklch(0.155 0.035 278 / 0.88) ≈ #1B1C2E con 88% de opacidad
  static const Color panelBg = Color(0xE01B1C2E);

  /// --fp-panel-border: oklch(0.54 0.11 280 / 0.22) ≈ #7C3AED con 22% de opacidad
  static const Color panelBorder = Color(0x387C3AED);

  /// --fp-panel-shadow: 0 10px 40px oklch(0.06 0.025 274 / 0.38)
  static const BoxShadow panelShadow = BoxShadow(
    color: Color(0x61000000),
    blurRadius: 40,
    offset: Offset(0, 10),
  );

  /// --fp-topbar-bg: oklch(0.12 0.03 274 / 0.88) ≈ #0B0B12 al 88%
  static const Color topbarBg = Color(0xE00B0B12);

  /// --fp-topbar-border: oklch(0.52 0.1 280 / 0.22) ≈ violeta al 22%
  static const Color topbarBorder = Color(0x387C3AED);

  // ─── Capas de Primer Plano (Foreground) ──────────────────────────────────
  /// --fp-fg: oklch(0.94 0.012 274) ≈ #EEEDF7 (texto principal sobre oscuro)
  static const Color fg = Color(0xFFEEEDF7);

  /// --fp-fg-strong: oklch(0.97 0.01 274) ≈ #F7F6FB (títulos y énfasis)
  static const Color fgStrong = Color(0xFFF7F6FB);

  /// --fp-ui-muted: oklch(0.55 0.03 270) ≈ #84849B (metadatos e iconos secundarios)
  static const Color uiMuted = Color(0xFF84849B);

  /// --fp-kicker: oklch(0.73 0.12 274) ≈ #A5A0F0 (etiquetas kickers en mayúsculas)
  static const Color kicker = Color(0xFFA5A0F0);

  // ─── Marca y Acento Índigo-Violeta ───────────────────────────────────────
  /// primary-indigo: #6366F1
  static const Color primaryIndigo = Color(0xFF6366F1);

  /// primary-indigo-deep: #4F46E5
  static const Color primaryIndigoDeep = Color(0xFF4F46E5);

  /// accent-violet: #7C3AED
  static const Color accentViolet = Color(0xFF7C3AED);

  /// cta-button text color: #F4F4FF
  static const Color buttonText = Color(0xFFF4F4FF);

  /// Glow shadow índigo al 45% para el CTA de entrenamiento
  static const BoxShadow ctaGlowShadow = BoxShadow(
    color: Color(0x736366F1), // #6366F1 con ~45% de opacidad (0x73)
    blurRadius: 32,
    offset: Offset(0, 8),
  );
}

/// Espaciados estandarizados del sistema Zeris
class ZerisSpacing {
  ZerisSpacing._();
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Radios de borde estandarizados del sistema Zeris
class ZerisRadius {
  ZerisRadius._();
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 9999.0;
}

/// Gradiente oficial de acción principal (CTA) de Zeris.
/// "The One Accent Gradient Rule": Este gradiente full sólo se reserva para
/// el botón de acción principal y elementos prioritarios.
const LinearGradient zerisCtaGradient = LinearGradient(
  colors: [ZerisColors.primaryIndigo, ZerisColors.accentViolet],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Decoración para paneles (`.fp-panel`) de Zeris:
/// Fondo panel translúcido + borde violeta 1px + radio 16 + sombra profunda suave.
BoxDecoration zerisPanelDecoration({
  BorderRadiusGeometry? borderRadius,
  Color? color,
}) {
  return BoxDecoration(
    color: color ?? ZerisColors.panelBg,
    borderRadius: borderRadius ?? BorderRadius.circular(ZerisRadius.lg),
    border: Border.all(
      color: ZerisColors.panelBorder,
      width: 1.0,
    ),
    boxShadow: const [ZerisColors.panelShadow],
  );
}

/// Decoración para el botón principal de entreno (`.fp-cta-training`):
/// Gradiente índigo a violeta + radio 16 + resplandor índigo 45%.
BoxDecoration zerisCtaButtonDecoration() {
  return BoxDecoration(
    gradient: zerisCtaGradient,
    borderRadius: BorderRadius.circular(ZerisRadius.lg),
    boxShadow: const [ZerisColors.ctaGlowShadow],
  );
}

/// Estilos tipográficos del Design System de Zeris usando `Manrope`.
class ZerisTypography {
  ZerisTypography._();

  /// Kickers: Mayúsculas, 10px, weight 700, letterSpacing amplio (0.14em ≈ 1.4px)
  static TextStyle kicker({Color? color}) => GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: color ?? ZerisColors.kicker,
      );

  /// Headline: 18px (1.125rem), weight 800, line-height compacta
  static TextStyle headline({Color? color}) => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.18,
        color: color ?? ZerisColors.fgStrong,
      );

  /// Title: 14px (0.875rem), weight 700
  static TextStyle title({Color? color}) => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.14,
        color: color ?? ZerisColors.fgStrong,
      );

  /// Body: 14px (0.875rem), weight 500, line-height 1.58
  static TextStyle body({Color? color}) => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.58,
        color: color ?? ZerisColors.fg,
      );

  /// Label: 10px, weight 700, letter-spacing amplio
  static TextStyle label({Color? color}) => GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: color ?? ZerisColors.uiMuted,
      );
}

/// Configuración del tema general para la aplicación Flutter
class ZerisTheme {
  ZerisTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: ZerisColors.page,
      colorScheme: const ColorScheme.dark(
        primary: ZerisColors.primaryIndigo,
        secondary: ZerisColors.accentViolet,
        surface: ZerisColors.panelBg,
        onSurface: ZerisColors.fg,
        onPrimary: ZerisColors.buttonText,
      ),
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).apply(
        bodyColor: ZerisColors.fg,
        displayColor: ZerisColors.fgStrong,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ZerisColors.topbarBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ZerisColors.fgStrong),
        titleTextStyle: ZerisTypography.headline(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ZerisColors.panelBg,
        contentTextStyle: ZerisTypography.body(color: ZerisColors.fgStrong),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZerisRadius.md),
          side: const BorderSide(color: ZerisColors.panelBorder, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
