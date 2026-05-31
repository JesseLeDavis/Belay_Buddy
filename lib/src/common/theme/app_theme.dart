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
// ---------------------------------------------------------------------------

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.canvas,
    required this.ink,
    required this.chalkBlue,
    required this.lime,
    required this.surface,
    required this.inputFill,
    required this.borderColor,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
  });

  // ── Chalk & Static core ───────────────────────────────────────────────────
  /// Warm manila background.
  final Color canvas;

  /// Near-black. All text, hairlines, default UI.
  final Color ink;

  /// Soft ambient. Expected/inferred states, secondary metadata.
  final Color chalkBlue;

  /// Reserved for "a human is reachable." Never decoration.
  final Color lime;

  // ── Material surface slots ────────────────────────────────────────────────
  /// ColorScheme.surface — currently the same as canvas; one tier exists
  /// because Material's API expects a distinct "surface" token.
  final Color surface;

  /// Fill for text inputs / surfaceContainerHighest.
  final Color inputFill;

  // ── Hairline + status ─────────────────────────────────────────────────────
  final Color borderColor;
  final Color error;

  // ── Text ──────────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  @override
  AppColorsExtension copyWith({
    Color? canvas,
    Color? ink,
    Color? chalkBlue,
    Color? lime,
    Color? surface,
    Color? inputFill,
    Color? borderColor,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
  }) {
    return AppColorsExtension(
      canvas: canvas ?? this.canvas,
      ink: ink ?? this.ink,
      chalkBlue: chalkBlue ?? this.chalkBlue,
      lime: lime ?? this.lime,
      surface: surface ?? this.surface,
      inputFill: inputFill ?? this.inputFill,
      borderColor: borderColor ?? this.borderColor,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      chalkBlue: Color.lerp(chalkBlue, other.chalkBlue, t)!,
      lime: Color.lerp(lime, other.lime, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// Light & Dark color instances — Chalk & Static
// ---------------------------------------------------------------------------

const _ink = Color(0xFF111111);
const _canvas = Color(0xFFEDE6D3);
const _chalkBlue = Color(0xFFC8D4DE);
const _lime = Color(0xFFD8FF3C);
const _inkSecondary = Color(0xFF5A554A);
const _inkDisabled = Color(0xFF9A9385);

const lightColors = AppColorsExtension(
  canvas: _canvas,
  ink: _ink,
  chalkBlue: _chalkBlue,
  lime: _lime,
  surface: _canvas,
  inputFill: _canvas,
  borderColor: _ink,
  error: Color(0xFFC9342B),
  textPrimary: _ink,
  textSecondary: _inkSecondary,
  textDisabled: _inkDisabled,
);

const _darkCanvas = Color(0xFF1A1612);
const _darkInk = Color(0xFFEDE6D3);
const _darkInkSecondary = Color(0xFFA89A8C);
const _darkInkDisabled = Color(0xFF5E554C);
const _darkChalkBlue = Color(0xFF3A4754);

const darkColors = AppColorsExtension(
  canvas: _darkCanvas,
  ink: _darkInk,
  chalkBlue: _darkChalkBlue,
  // Lime is the same in both modes — it's a signal, not a theme color.
  lime: _lime,
  surface: _darkCanvas,
  inputFill: Color(0xFF24201B),
  borderColor: _darkInk,
  error: Color(0xFFE85A50),
  textPrimary: _darkInk,
  textSecondary: _darkInkSecondary,
  textDisabled: _darkInkDisabled,
);

extension AppColorsX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

// ---------------------------------------------------------------------------
// Legacy static AppColors — kept const so lib/admin/ and the climbing-tags
// data table still compile. Values remapped to Chalk & Static so even though
// admin reads `AppColors.dullOrange` it renders as ink.
//
// Not consumed by any feature/ code anymore; deletable once admin migrates.
// ---------------------------------------------------------------------------
class AppColors {
  AppColors._();

  static const Color background = _canvas;
  static const Color surface = _canvas;
  static const Color darkNavy = _ink;
  static const Color dullOrange = _ink;
  static const Color oliveGreen = _ink;
  static const Color amber = _chalkBlue;
  static const Color accentBlue = _ink;
  static const Color darkGrey = Color(0xFFD6CFBE);
  static const Color cork = _canvas;
  static const Color error = Color(0xFFC9342B);
  static const Color textSecondary = _inkSecondary;

  // Chalk & Static semantic — prefer these in new admin code.
  static const Color ink = _ink;
  static const Color canvas = _canvas;
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
