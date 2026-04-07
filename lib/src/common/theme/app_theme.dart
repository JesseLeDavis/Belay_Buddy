import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static TextTheme _buildTextTheme() {
    final cabin = GoogleFonts.cabinTextTheme();
    final spaceMono = GoogleFonts.spaceMonoTextTheme();

    return TextTheme(
      displayLarge: spaceMono.displayLarge?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      headlineLarge: spaceMono.headlineLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      headlineMedium: spaceMono.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      headlineSmall: spaceMono.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      titleMedium: cabin.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      titleSmall: spaceMono.titleSmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      bodyLarge: cabin.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodyMedium: cabin.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodySmall: cabin.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      labelLarge: spaceMono.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: AppColors.textPrimary,
      ),
      labelSmall: spaceMono.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 1.0,
        color: AppColors.textPrimary,
      ),
    );
  }

  // Both light and dark resolve to the same warm theme.
  static ThemeData get light => _buildTheme();
  static ThemeData get dark => _buildTheme();

  static ThemeData _buildTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.dullOrange,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.dullOrange,
      secondary: AppColors.oliveGreen,
      onSecondary: AppColors.textOnSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.oliveGreen,
      tertiary: AppColors.amber,
      onTertiary: AppColors.textOnPrimary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.amber,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.inputFill,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.darkNavy,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.darkNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceMono(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkNavy),
        shape: const Border(
          bottom: BorderSide(color: AppColors.darkNavy, width: 3),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColors.surface,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: const BorderSide(color: AppColors.darkNavy, width: 2.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.chipBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.darkNavy, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.darkNavy, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.dullOrange, width: 2.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textDisabled),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkNavy,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            side: const BorderSide(color: AppColors.darkNavy, width: 2.5),
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
        backgroundColor: AppColors.dullOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: const BorderSide(color: AppColors.darkNavy, width: 2.5),
        ),
        extendedTextStyle: GoogleFonts.spaceMono(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
          side: const BorderSide(color: AppColors.darkNavy, width: 2),
        ),
        labelStyle: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.darkNavy,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.dullOrange,
        unselectedItemColor: AppColors.textDisabled,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.orangeLight,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.spaceMono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.dullOrange,
            );
          }
          return GoogleFonts.spaceMono(
            fontSize: 11,
            color: AppColors.darkNavy.withAlpha(128),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.dullOrange);
          }
          return IconThemeData(color: AppColors.darkNavy.withAlpha(128));
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkGrey,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkNavy,
        contentTextStyle: GoogleFonts.cabin(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.dullOrange;
            }
            return AppColors.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.textOnPrimary;
            }
            return AppColors.darkNavy;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.darkNavy, width: 2),
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
            return AppColors.dullOrange;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.darkNavy, width: 2),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: AppColors.surface,
        textColor: AppColors.textPrimary,
        iconColor: AppColors.darkNavy,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.chipBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: const BorderSide(color: AppColors.darkNavy, width: 2),
          ),
        ),
      ),
    );
  }
}
