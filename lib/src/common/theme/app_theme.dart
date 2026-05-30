import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Chalk & Static — design tokens.
//
// Source of truth: docs/design-north-star.md
//
// Brand rule: lime is reserved exclusively for "a human is reachable."
// Never decoration. If you reach for `c.lime` in a button that posts, waves,
// or opens settings — stop. Use ink instead.
//
// Existing field names (dullOrange, oliveGreen, amber, accentBlue, etc.) are
// kept for now to avoid a cascade of call-site renames. They have been
// remapped to ink/chalk-blue/canvas so they no longer carry the old
// neobrutalist meaning. A follow-up PR will migrate call sites onto the
// semantic names below (ink, chalkBlue, lime).
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
    required this.textOnTertiary,
    required this.textOnCork,
    required this.teal,
    required this.pink,
    required this.borderColor,
    required this.shadowColor,
    required this.ink,
    required this.chalkBlue,
    required this.lime,
  });

  // ── Chalk & Static core ───────────────────────────────────────────────────
  /// Near-black. All text, hairlines, default UI surface for type.
  final Color ink;
  /// Soft ambient. Expected/inferred states, secondary metadata.
  final Color chalkBlue;
  /// Reserved for "a human is reachable." Never decoration.
  final Color lime;

  // ── Legacy field surface (remapped to Chalk & Static) ─────────────────────
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
  final Color sageLight;
  final Color orangeLight;
  final Color accentBlue;
  final Color blueLight;
  final Color chipBg;
  final Color tanStrip;
  final Color yellowFill;
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
  final Color noteImmediate;
  final Color noteScheduled;
  final Color cork;
  final Color corkDark;
  final Color inputFill;
  final Color success;
  final Color successContainer;
  final Color error;
  final Color errorContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color textOnPrimary;
  final Color textOnSecondary;
  final Color textOnTertiary;
  final Color textOnCork;
  final Color teal;
  final Color pink;
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
    Color? textOnTertiary,
    Color? textOnCork,
    Color? teal,
    Color? pink,
    Color? borderColor,
    Color? shadowColor,
    Color? ink,
    Color? chalkBlue,
    Color? lime,
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
      textOnTertiary: textOnTertiary ?? this.textOnTertiary,
      textOnCork: textOnCork ?? this.textOnCork,
      teal: teal ?? this.teal,
      pink: pink ?? this.pink,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      ink: ink ?? this.ink,
      chalkBlue: chalkBlue ?? this.chalkBlue,
      lime: lime ?? this.lime,
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
      textOnTertiary: Color.lerp(textOnTertiary, other.textOnTertiary, t)!,
      textOnCork: Color.lerp(textOnCork, other.textOnCork, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      chalkBlue: Color.lerp(chalkBlue, other.chalkBlue, t)!,
      lime: Color.lerp(lime, other.lime, t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// Light & Dark color instances — Chalk & Static
// ---------------------------------------------------------------------------

// Light: warm manila canvas, ink on top, chalk-blue ambient, lime signal.
const _ink = Color(0xFF111111);
const _canvas = Color(0xFFEDE6D3);
const _chalkBlue = Color(0xFFC8D4DE);
const _lime = Color(0xFFD8FF3C);
const _inkSecondary = Color(0xFF5A554A);
const _inkDisabled = Color(0xFF9A9385);
const _hairline = Color(0xFF111111);

const lightColors = AppColorsExtension(
  ink: _ink,
  chalkBlue: _chalkBlue,
  lime: _lime,

  background: _canvas,
  surface: _canvas,
  surfaceLight: _canvas,
  darkNavy: _ink,
  dullOrange: _ink,
  oliveGreen: _ink,
  amber: _chalkBlue,
  white: _canvas,
  dimWhite: _inkSecondary,
  darkGrey: Color(0xFFD6CFBE),

  sageLight: _chalkBlue,
  orangeLight: _chalkBlue,
  accentBlue: _ink,
  blueLight: _chalkBlue,
  chipBg: _canvas,
  tanStrip: _chalkBlue,
  yellowFill: _chalkBlue,

  primary: _ink,
  primaryLight: _inkSecondary,
  primaryContainer: _chalkBlue,
  secondary: _ink,
  secondaryLight: _inkSecondary,
  secondaryContainer: _chalkBlue,
  tertiary: _chalkBlue,
  tertiaryContainer: _chalkBlue,

  canvas: _canvas,
  cardSurface: _canvas,

  noteImmediate: _chalkBlue,
  noteScheduled: _chalkBlue,

  cork: _canvas,
  corkDark: Color(0xFFD6CFBE),
  inputFill: _canvas,

  success: _ink,
  successContainer: _chalkBlue,
  error: Color(0xFFC9342B),
  errorContainer: _chalkBlue,
  warning: _ink,
  warningContainer: _chalkBlue,
  info: _ink,

  textPrimary: _ink,
  textSecondary: _inkSecondary,
  textDisabled: _inkDisabled,
  textOnPrimary: _canvas,
  textOnSecondary: _canvas,
  textOnTertiary: _ink,
  textOnCork: _ink,

  teal: _ink,
  pink: _ink,

  borderColor: _hairline,
  shadowColor: Color(0x00000000), // shadows are off in Chalk & Static
);

// Dark: warm-charcoal canvas, light ink, same chalk-blue + lime semantics.
const _darkCanvas = Color(0xFF1A1612);
const _darkInk = Color(0xFFEDE6D3);
const _darkInkSecondary = Color(0xFFA89A8C);
const _darkInkDisabled = Color(0xFF5E554C);
const _darkChalkBlue = Color(0xFF3A4754);

const darkColors = AppColorsExtension(
  ink: _darkInk,
  chalkBlue: _darkChalkBlue,
  lime: _lime, // lime is the same in both modes — it's a signal, not a theme color

  background: _darkCanvas,
  surface: _darkCanvas,
  surfaceLight: Color(0xFF24201B),
  darkNavy: _darkInk,
  dullOrange: _darkInk,
  oliveGreen: _darkInk,
  amber: _darkChalkBlue,
  white: _darkCanvas,
  dimWhite: _darkInkSecondary,
  darkGrey: Color(0xFF3E3830),

  sageLight: _darkChalkBlue,
  orangeLight: _darkChalkBlue,
  accentBlue: _darkInk,
  blueLight: _darkChalkBlue,
  chipBg: Color(0xFF24201B),
  tanStrip: _darkChalkBlue,
  yellowFill: _darkChalkBlue,

  primary: _darkInk,
  primaryLight: _darkInkSecondary,
  primaryContainer: _darkChalkBlue,
  secondary: _darkInk,
  secondaryLight: _darkInkSecondary,
  secondaryContainer: _darkChalkBlue,
  tertiary: _darkChalkBlue,
  tertiaryContainer: _darkChalkBlue,

  canvas: _darkCanvas,
  cardSurface: _darkCanvas,

  noteImmediate: _darkChalkBlue,
  noteScheduled: _darkChalkBlue,

  cork: _darkCanvas,
  corkDark: Color(0xFF3E3830),
  inputFill: Color(0xFF24201B),

  success: _darkInk,
  successContainer: _darkChalkBlue,
  error: Color(0xFFE85A50),
  errorContainer: _darkChalkBlue,
  warning: _darkInk,
  warningContainer: _darkChalkBlue,
  info: _darkInk,

  textPrimary: _darkInk,
  textSecondary: _darkInkSecondary,
  textDisabled: _darkInkDisabled,
  textOnPrimary: _darkCanvas,
  textOnSecondary: _darkCanvas,
  textOnTertiary: _ink,
  textOnCork: _darkInk,

  teal: _darkInk,
  pink: _darkInk,

  borderColor: _darkInk,
  shadowColor: Color(0x00000000),
);

extension AppColorsX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

// ---------------------------------------------------------------------------
// Legacy static AppColors — kept const so admin/ and climbing_tags.dart still
// compile. Values remapped to Chalk & Static.
// ---------------------------------------------------------------------------
class AppColors {
  AppColors._();

  static const Color background = _canvas;
  static const Color surface = _canvas;
  static const Color surfaceLight = _canvas;
  static const Color darkNavy = _ink;
  static const Color dullOrange = _ink;
  static const Color oliveGreen = _ink;
  static const Color amber = _chalkBlue;
  static const Color white = _canvas;
  static const Color dimWhite = _inkSecondary;
  static const Color darkGrey = Color(0xFFD6CFBE);

  static const Color sageLight = _chalkBlue;
  static const Color orangeLight = _chalkBlue;
  static const Color accentBlue = _ink;
  static const Color blueLight = _chalkBlue;
  static const Color chipBg = _canvas;
  static const Color tanStrip = _chalkBlue;
  static const Color yellowFill = _chalkBlue;

  static const Color primary = _ink;
  static const Color primaryLight = _inkSecondary;
  static const Color primaryContainer = _chalkBlue;
  static const Color secondary = _ink;
  static const Color secondaryLight = _inkSecondary;
  static const Color secondaryContainer = _chalkBlue;
  static const Color tertiary = _chalkBlue;
  static const Color tertiaryContainer = _chalkBlue;

  static const Color canvas = _canvas;
  static const Color cardSurface = _canvas;

  static const Color noteImmediate = _chalkBlue;
  static const Color noteScheduled = _chalkBlue;

  static const Color cork = _canvas;
  static const Color corkDark = Color(0xFFD6CFBE);
  static const Color inputFill = _canvas;

  static const Color success = _ink;
  static const Color successContainer = _chalkBlue;
  static const Color error = Color(0xFFC9342B);
  static const Color errorContainer = _chalkBlue;
  static const Color warning = _ink;
  static const Color warningContainer = _chalkBlue;
  static const Color info = _ink;

  static const Color textPrimary = _ink;
  static const Color textSecondary = _inkSecondary;
  static const Color textDisabled = _inkDisabled;
  static const Color textOnPrimary = _canvas;
  static const Color textOnSecondary = _canvas;
  static const Color textOnCork = _ink;

  static const Color teal = _ink;
  static const Color pink = _ink;

  // Chalk & Static semantic
  static const Color ink = _ink;
  static const Color chalkBlue = _chalkBlue;
  static const Color lime = _lime;
}

// ---------------------------------------------------------------------------
// Spacing — unchanged (4dp grid)
// ---------------------------------------------------------------------------
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double smMd = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// ---------------------------------------------------------------------------
// Radii — Chalk & Static is zero-radius except for circular avatars.
// All sm/md/lg/xl tokens map to 0; `full` stays 999 for circles.
// ---------------------------------------------------------------------------
class AppRadius {
  AppRadius._();

  static const double xs = 0.0;
  static const double sm = 0.0;
  static const double md = 0.0;
  static const double lg = 0.0;
  static const double xl = 0.0;
  static const double full = 999.0;
}

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------
class AppTheme {
  AppTheme._();

  static const _hairlineWidth = 1.5;

  static TextTheme _buildTextTheme(
      {required Color primary, required Color secondary}) {
    final ui = GoogleFonts.interTextTheme();
    final mono = GoogleFonts.jetBrainsMonoTextTheme();

    return TextTheme(
      displayLarge: ui.displayLarge?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.1,
        color: primary,
      ),
      headlineLarge: ui.headlineLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: primary,
      ),
      headlineMedium: ui.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: primary,
      ),
      headlineSmall: ui.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: primary,
      ),
      titleMedium: ui.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: primary,
      ),
      titleSmall: mono.titleSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: primary,
      ),
      bodyLarge: ui.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primary,
      ),
      bodyMedium: ui.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primary,
      ),
      bodySmall: ui.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondary,
      ),
      labelLarge: mono.labelLarge?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: primary,
      ),
      labelSmall: mono.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: primary,
      ),
    );
  }

  static ThemeData get light => _buildTheme(lightColors, Brightness.light);
  static ThemeData get dark => _buildTheme(darkColors, Brightness.dark);

  static ThemeData _buildTheme(AppColorsExtension c, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: c.ink,
      onPrimary: c.canvas,
      primaryContainer: c.chalkBlue,
      onPrimaryContainer: c.ink,
      secondary: c.ink,
      onSecondary: c.canvas,
      secondaryContainer: c.chalkBlue,
      onSecondaryContainer: c.ink,
      tertiary: c.lime,
      onTertiary: c.ink,
      tertiaryContainer: c.chalkBlue,
      onTertiaryContainer: c.ink,
      error: c.error,
      onError: c.canvas,
      errorContainer: c.chalkBlue,
      onErrorContainer: c.ink,
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
      scaffoldBackgroundColor: c.canvas,
      textTheme:
          _buildTextTheme(primary: c.textPrimary, secondary: c.textSecondary),
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.canvas,
        foregroundColor: c.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: c.ink,
        ),
        iconTheme: IconThemeData(color: c.ink),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: _hairlineWidth),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: c.canvas,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.canvas,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: c.borderColor, width: _hairlineWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: c.borderColor, width: _hairlineWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: c.borderColor, width: _hairlineWidth),
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
          backgroundColor: c.ink,
          foregroundColor: c.canvas,
          shape: const RoundedRectangleBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.ink,
        foregroundColor: c.canvas,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
        extendedTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.canvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: c.borderColor, width: _hairlineWidth),
        ),
        labelStyle: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.canvas,
        selectedItemColor: c.ink,
        unselectedItemColor: c.textDisabled,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.canvas,
        indicatorColor: Colors.transparent,
        indicatorShape: const RoundedRectangleBorder(),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: c.ink,
            );
          }
          return GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: c.textDisabled,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.ink);
          }
          return IconThemeData(color: c.textDisabled);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: c.borderColor,
        thickness: _hairlineWidth,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.ink,
        contentTextStyle: GoogleFonts.inter(color: c.canvas),
        shape: const RoundedRectangleBorder(),
        behavior: SnackBarBehavior.floating,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return c.ink;
            return c.canvas;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return c.canvas;
            return c.ink;
          }),
          side: WidgetStateProperty.all(
            BorderSide(color: c.borderColor, width: _hairlineWidth),
          ),
          shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.ink;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(c.canvas),
        side: BorderSide(color: c.borderColor, width: _hairlineWidth),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: c.canvas,
        textColor: c.textPrimary,
        iconColor: c.ink,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: c.canvas,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: c.borderColor, width: _hairlineWidth),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: c.canvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: c.borderColor, width: _hairlineWidth),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.canvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: c.borderColor, width: _hairlineWidth),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.canvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: c.borderColor, width: _hairlineWidth),
        ),
      ),
    );
  }
}
