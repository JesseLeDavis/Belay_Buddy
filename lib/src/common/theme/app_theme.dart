import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// AppColorsExtension — ThemeExtension carrying every app-specific color.
// Light and dark instances below; access via `context.appColors`.
// ---------------------------------------------------------------------------

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.darkNavy,
    required this.dullOrange,
    required this.oliveGreen,
    required this.amber,
    required this.white,
    required this.dimWhite,
    required this.darkGrey,
    required this.sageLight,
    required this.orangeLight,
    required this.accentBlue,
    required this.blueLight,
    required this.chipBg,
    required this.tanStrip,
    required this.yellowFill,
    required this.primary,
    required this.primaryLight,
    required this.primaryContainer,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.canvas,
    required this.cardSurface,
    required this.noteImmediate,
    required this.noteScheduled,
    required this.cork,
    required this.corkDark,
    required this.inputFill,
    required this.success,
    required this.successContainer,
    required this.error,
    required this.errorContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnPrimary,
    required this.textOnSecondary,
    required this.textOnCork,
    required this.teal,
    required this.pink,
    required this.borderColor,
    required this.shadowColor,
  });

  // Core
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color darkNavy;
  final Color dullOrange;
  final Color oliveGreen;
  final Color amber;
  final Color white;
  final Color dimWhite;
  final Color darkGrey;

  // Soft tints
  final Color sageLight;
  final Color orangeLight;
  final Color accentBlue;
  final Color blueLight;
  final Color chipBg;
  final Color tanStrip;
  final Color yellowFill;

  // Semantic aliases
  final Color primary;
  final Color primaryLight;
  final Color primaryContainer;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryContainer;
  final Color tertiary;
  final Color tertiaryContainer;

  final Color canvas;
  final Color cardSurface;

  // Notes
  final Color noteImmediate;
  final Color noteScheduled;

  // Cork board
  final Color cork;
  final Color corkDark;
  final Color inputFill;

  // Semantic
  final Color success;
  final Color successContainer;
  final Color error;
  final Color errorContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color textOnPrimary;
  final Color textOnSecondary;
  final Color textOnCork;

  // Legacy aliases
  final Color teal;
  final Color pink;

  // Neobrutalist structural colors (borders & shadows flip in dark mode)
  final Color borderColor;
  final Color shadowColor;

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? darkNavy,
    Color? dullOrange,
    Color? oliveGreen,
    Color? amber,
    Color? white,
    Color? dimWhite,
    Color? darkGrey,
    Color? sageLight,
    Color? orangeLight,
    Color? accentBlue,
    Color? blueLight,
    Color? chipBg,
    Color? tanStrip,
    Color? yellowFill,
    Color? primary,
    Color? primaryLight,
    Color? primaryContainer,
    Color? secondary,
    Color? secondaryLight,
    Color? secondaryContainer,
    Color? tertiary,
    Color? tertiaryContainer,
    Color? canvas,
    Color? cardSurface,
    Color? noteImmediate,
    Color? noteScheduled,
    Color? cork,
    Color? corkDark,
    Color? inputFill,
    Color? success,
    Color? successContainer,
    Color? error,
    Color? errorContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? textOnPrimary,
    Color? textOnSecondary,
    Color? textOnCork,
    Color? teal,
    Color? pink,
    Color? borderColor,
    Color? shadowColor,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      darkNavy: darkNavy ?? this.darkNavy,
      dullOrange: dullOrange ?? this.dullOrange,
      oliveGreen: oliveGreen ?? this.oliveGreen,
      amber: amber ?? this.amber,
      white: white ?? this.white,
      dimWhite: dimWhite ?? this.dimWhite,
      darkGrey: darkGrey ?? this.darkGrey,
      sageLight: sageLight ?? this.sageLight,
      orangeLight: orangeLight ?? this.orangeLight,
      accentBlue: accentBlue ?? this.accentBlue,
      blueLight: blueLight ?? this.blueLight,
      chipBg: chipBg ?? this.chipBg,
      tanStrip: tanStrip ?? this.tanStrip,
      yellowFill: yellowFill ?? this.yellowFill,
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondary: secondary ?? this.secondary,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      canvas: canvas ?? this.canvas,
      cardSurface: cardSurface ?? this.cardSurface,
      noteImmediate: noteImmediate ?? this.noteImmediate,
      noteScheduled: noteScheduled ?? this.noteScheduled,
      cork: cork ?? this.cork,
      corkDark: corkDark ?? this.corkDark,
      inputFill: inputFill ?? this.inputFill,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textOnSecondary: textOnSecondary ?? this.textOnSecondary,
      textOnCork: textOnCork ?? this.textOnCork,
      teal: teal ?? this.teal,
      pink: pink ?? this.pink,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      darkNavy: Color.lerp(darkNavy, other.darkNavy, t)!,
      dullOrange: Color.lerp(dullOrange, other.dullOrange, t)!,
      oliveGreen: Color.lerp(oliveGreen, other.oliveGreen, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      white: Color.lerp(white, other.white, t)!,
      dimWhite: Color.lerp(dimWhite, other.dimWhite, t)!,
      darkGrey: Color.lerp(darkGrey, other.darkGrey, t)!,
      sageLight: Color.lerp(sageLight, other.sageLight, t)!,
      orangeLight: Color.lerp(orangeLight, other.orangeLight, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      blueLight: Color.lerp(blueLight, other.blueLight, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      tanStrip: Color.lerp(tanStrip, other.tanStrip, t)!,
      yellowFill: Color.lerp(yellowFill, other.yellowFill, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryLight: Color.lerp(secondaryLight, other.secondaryLight, t)!,
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryContainer: Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      noteImmediate: Color.lerp(noteImmediate, other.noteImmediate, t)!,
      noteScheduled: Color.lerp(noteScheduled, other.noteScheduled, t)!,
      cork: Color.lerp(cork, other.cork, t)!,
      corkDark: Color.lerp(corkDark, other.corkDark, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textOnSecondary: Color.lerp(textOnSecondary, other.textOnSecondary, t)!,
      textOnCork: Color.lerp(textOnCork, other.textOnCork, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// Light & Dark color instances
// ---------------------------------------------------------------------------

const lightColors = AppColorsExtension(
  // Core
  background: Color(0xFFF7EDD8),
  surface: Color(0xFFFFFFFF),
  surfaceLight: Color(0xFFFFFFFF),
  darkNavy: Color(0xFF0F0F0F),
  dullOrange: Color(0xFFFF6B2B),
  oliveGreen: Color(0xFF2D9B4E),
  amber: Color(0xFFFFD000),
  white: Color(0xFFFFFFFF),
  dimWhite: Color(0xFF5A5048),
  darkGrey: Color(0xFFD6CEC4),

  // Soft tints
  sageLight: Color(0xFFB2DFBB),
  orangeLight: Color(0xFFFFBE9D),
  accentBlue: Color(0xFF1D63D4),
  blueLight: Color(0xFFBBD1F5),
  chipBg: Color(0xFFFFF8EE),
  tanStrip: Color(0xFFD4AA7D),
  yellowFill: Color(0xFFFFF0A0),

  // Semantic
  primary: Color(0xFFFF6B2B),
  primaryLight: Color(0xFFFF9966),
  primaryContainer: Color(0xFFFFBE9D),
  secondary: Color(0xFF2D9B4E),
  secondaryLight: Color(0xFF5BBF6E),
  secondaryContainer: Color(0xFFB2DFBB),
  tertiary: Color(0xFFFFD000),
  tertiaryContainer: Color(0xFFFFF0A0),

  canvas: Color(0xFFF7EDD8),
  cardSurface: Color(0xFFFFFFFF),

  noteImmediate: Color(0xFFFFBE9D),
  noteScheduled: Color(0xFFB2DFBB),

  cork: Color(0xFFE8D5B0),
  corkDark: Color(0xFFD4AA7D),
  inputFill: Color(0xFFFFF8EE),

  success: Color(0xFF2D9B4E),
  successContainer: Color(0xFFB2DFBB),
  error: Color(0xFFE03030),
  errorContainer: Color(0xFFFFBE9D),
  warning: Color(0xFFFFD000),
  warningContainer: Color(0xFFFFF0A0),
  info: Color(0xFF1D63D4),

  textPrimary: Color(0xFF0F0F0F),
  textSecondary: Color(0xFF5A5048),
  textDisabled: Color(0xFF9A8E84),
  textOnPrimary: Color(0xFFFFFFFF),
  textOnSecondary: Color(0xFFFFFFFF),
  textOnCork: Color(0xFF0F0F0F),

  teal: Color(0xFF1D63D4),
  pink: Color(0xFFFF6B2B),

  borderColor: Color(0xFF0F0F0F),
  shadowColor: Color(0xFF0F0F0F),
);

const darkColors = AppColorsExtension(
  // Core — warm charcoal, never cold grey
  background: Color(0xFF1A1612),
  surface: Color(0xFF2A2420),
  surfaceLight: Color(0xFF332C26),
  darkNavy: Color(0xFFE8DFD0),       // flipped to light for visibility
  dullOrange: Color(0xFFFF7A3D),     // slightly lighter for dark bg contrast
  oliveGreen: Color(0xFF3AB85E),     // bumped luminance
  amber: Color(0xFFFFD000),          // unchanged — reads well on dark
  white: Color(0xFF1A1612),          // inverted: "white" areas become dark bg
  dimWhite: Color(0xFFA89A8C),       // muted warm tan
  darkGrey: Color(0xFF3E3830),       // dividers

  // Soft tints — low-opacity washes over dark surfaces
  sageLight: Color(0xFF1E2E20),
  orangeLight: Color(0xFF3D2518),
  accentBlue: Color(0xFF4A8AF5),     // lightened so blue is visible on dark
  blueLight: Color(0xFF1A2436),
  chipBg: Color(0xFF332C26),
  tanStrip: Color(0xFF4A3D2E),
  yellowFill: Color(0xFF332C14),

  // Semantic
  primary: Color(0xFFFF7A3D),
  primaryLight: Color(0xFFFF9966),
  primaryContainer: Color(0xFF3D2518),
  secondary: Color(0xFF3AB85E),
  secondaryLight: Color(0xFF5BBF6E),
  secondaryContainer: Color(0xFF1E2E20),
  tertiary: Color(0xFFFFD000),
  tertiaryContainer: Color(0xFF332C14),

  canvas: Color(0xFF1A1612),
  cardSurface: Color(0xFF2A2420),

  noteImmediate: Color(0xFF3D2518),
  noteScheduled: Color(0xFF1E2E20),

  cork: Color(0xFF3D3228),
  corkDark: Color(0xFF4A3D2E),
  inputFill: Color(0xFF332C26),

  success: Color(0xFF3AB85E),
  successContainer: Color(0xFF1E2E20),
  error: Color(0xFFF04848),
  errorContainer: Color(0xFF3D2518),
  warning: Color(0xFFFFD000),
  warningContainer: Color(0xFF332C14),
  info: Color(0xFF4A8AF5),

  textPrimary: Color(0xFFEDE6DA),
  textSecondary: Color(0xFFA89A8C),
  textDisabled: Color(0xFF5E554C),
  textOnPrimary: Color(0xFFFFFFFF),
  textOnSecondary: Color(0xFFFFFFFF),
  textOnCork: Color(0xFFEDE6DA),

  teal: Color(0xFF4A8AF5),
  pink: Color(0xFFFF7A3D),

  borderColor: Color(0xFFE8DFD0),    // light borders on dark bg
  shadowColor: Color(0xFF0D0A08),    // solid dark shadow
);

// ---------------------------------------------------------------------------
// Convenience extension — `context.appColors`
// ---------------------------------------------------------------------------

extension AppColorsX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

// ---------------------------------------------------------------------------
// Legacy static class — kept for backward compatibility during migration.
// Prefer `context.appColors.X` in all new code.
// ---------------------------------------------------------------------------

/// Neobrutalist color palette — saturated, punchy, bold.
class AppColors {
  AppColors._();

  // Core palette
  static const Color background = Color(0xFFF7EDD8);   // warm cream
  static const Color surface = Color(0xFFFFFFFF);       // pure white
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color darkNavy = Color(0xFF0F0F0F);      // near-black ink
  static const Color dullOrange = Color(0xFFFF6B2B);     // vivid climbing orange
  static const Color oliveGreen = Color(0xFF2D9B4E);     // forest green
  static const Color amber = Color(0xFFFFD000);          // electric gold
  static const Color white = Color(0xFFFFFFFF);
  static const Color dimWhite = Color(0xFF5A5048);
  static const Color darkGrey = Color(0xFFD6CEC4);

  // Card header strips — softer fills
  static const Color sageLight = Color(0xFFB2DFBB);     // soft green tint
  static const Color orangeLight = Color(0xFFFFBE9D);   // soft orange tint

  // Accent colors
  static const Color accentBlue = Color(0xFF1D63D4);    // cobalt blue
  static const Color blueLight = Color(0xFFBBD1F5);     // soft blue tint

  // Chip / off-white background
  static const Color chipBg = Color(0xFFFFF8EE);        // off-white cream

  // Tan strip
  static const Color tanStrip = Color(0xFFD4AA7D);

  // Yellow fill
  static const Color yellowFill = Color(0xFFFFF0A0);    // soft yellow tint

  // Semantic aliases
  static const Color primary = dullOrange;
  static const Color primaryLight = Color(0xFFFF9966);
  static const Color primaryContainer = orangeLight;
  static const Color secondary = oliveGreen;
  static const Color secondaryLight = Color(0xFF5BBF6E);
  static const Color secondaryContainer = sageLight;
  static const Color tertiary = amber;
  static const Color tertiaryContainer = Color(0xFFFFF0A0);

  static const Color canvas = background;
  static const Color cardSurface = surface;

  // Note colors
  static const Color noteImmediate = orangeLight;
  static const Color noteScheduled = sageLight;

  // Cork board -> warm background
  static const Color cork = Color(0xFFE8D5B0);          // warm tan
  static const Color corkDark = Color(0xFFD4AA7D);
  static const Color inputFill = Color(0xFFFFF8EE);

  // Semantic
  static const Color success = Color(0xFF2D9B4E);
  static const Color successContainer = sageLight;
  static const Color error = Color(0xFFE03030);
  static const Color errorContainer = orangeLight;
  static const Color warning = amber;
  static const Color warningContainer = Color(0xFFFFF0A0);
  static const Color info = accentBlue;

  // Text
  static const Color textPrimary = Color(0xFF0F0F0F);
  static const Color textSecondary = Color(0xFF5A5048);
  static const Color textDisabled = Color(0xFF9A8E84);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);
  static const Color textOnCork = darkNavy;

  // Legacy aliases
  static const Color teal = accentBlue;
  static const Color pink = dullOrange;
}

/// Spacing constants (4dp base grid).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border radius tokens — subtle rounding, keeps the neo-brutalist edge.
class AppRadius {
  AppRadius._();

  static const double xs = 3.0;   // badges, chips, small tags
  static const double sm = 4.0;   // buttons, inputs, small cards
  static const double md = 6.0;   // panels, cards
  static const double lg = 8.0;   // bottom sheets, large containers
  static const double xl = 12.0;  // modals
  static const double full = 999.0; // avatars only
}

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme({required Color primary, required Color secondary}) {
    final cabin = GoogleFonts.cabinTextTheme();
    final spaceMono = GoogleFonts.spaceMonoTextTheme();

    return TextTheme(
      displayLarge: spaceMono.displayLarge?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: primary,
      ),
      headlineLarge: spaceMono.headlineLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: primary,
      ),
      headlineMedium: spaceMono.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: primary,
      ),
      headlineSmall: spaceMono.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: primary,
      ),
      titleMedium: cabin.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: primary,
      ),
      titleSmall: spaceMono.titleSmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: primary,
      ),
      bodyLarge: cabin.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primary,
      ),
      bodyMedium: cabin.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primary,
      ),
      bodySmall: cabin.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondary,
      ),
      labelLarge: spaceMono.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: primary,
      ),
      labelSmall: spaceMono.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: primary,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Light theme
  // -------------------------------------------------------------------------
  static ThemeData get light => _buildTheme(lightColors, Brightness.light);

  // -------------------------------------------------------------------------
  // Dark theme
  // -------------------------------------------------------------------------
  static ThemeData get dark => _buildTheme(darkColors, Brightness.dark);

  static ThemeData _buildTheme(AppColorsExtension c, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: c.dullOrange,
      onPrimary: c.textOnPrimary,
      primaryContainer: c.primaryContainer,
      onPrimaryContainer: c.dullOrange,
      secondary: c.oliveGreen,
      onSecondary: c.textOnSecondary,
      secondaryContainer: c.secondaryContainer,
      onSecondaryContainer: c.oliveGreen,
      tertiary: c.amber,
      onTertiary: c.textOnPrimary,
      tertiaryContainer: c.tertiaryContainer,
      onTertiaryContainer: c.amber,
      error: c.error,
      onError: Colors.white,
      errorContainer: c.errorContainer,
      onErrorContainer: c.error,
      surface: c.surface,
      onSurface: c.textPrimary,
      surfaceContainerHighest: c.inputFill,
      onSurfaceVariant: c.textSecondary,
      outline: c.borderColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.background,
      textTheme: _buildTextTheme(primary: c.textPrimary, secondary: c.textSecondary),
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.borderColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceMono(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: c.borderColor,
        ),
        iconTheme: IconThemeData(color: c.borderColor),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 3),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: c.surface,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: c.borderColor, width: 2.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.chipBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: c.borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: c.borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: c.dullOrange, width: 2.5),
        ),
        labelStyle: TextStyle(color: c.textSecondary),
        hintStyle: TextStyle(color: c.textDisabled),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.borderColor,
          foregroundColor: c.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            side: BorderSide(color: c.borderColor, width: 2.5),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: GoogleFonts.spaceMono(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.dullOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: c.borderColor, width: 2.5),
        ),
        extendedTextStyle: GoogleFonts.spaceMono(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.chipBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          side: BorderSide(color: c.borderColor, width: 2),
        ),
        labelStyle: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: c.borderColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surface,
        selectedItemColor: c.dullOrange,
        unselectedItemColor: c.textDisabled,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.orangeLight,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.spaceMono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: c.dullOrange,
            );
          }
          return GoogleFonts.spaceMono(
            fontSize: 11,
            color: c.textDisabled,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.dullOrange);
          }
          return IconThemeData(color: c.textDisabled);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: c.darkGrey,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.borderColor,
        contentTextStyle: GoogleFonts.cabin(color: c.background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return c.dullOrange;
            }
            return c.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return c.textOnPrimary;
            }
            return c.borderColor;
          }),
          side: WidgetStateProperty.all(
            BorderSide(color: c.borderColor, width: 2),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return c.dullOrange;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: c.borderColor, width: 2),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: c.surface,
        textColor: c.textPrimary,
        iconColor: c.borderColor,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: c.chipBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide(color: c.borderColor, width: 2),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: c.borderColor, width: 2.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
          side: BorderSide(color: c.borderColor, width: 2.5),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: c.borderColor, width: 2),
        ),
      ),
    );
  }
}
