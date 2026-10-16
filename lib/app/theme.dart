import 'package:flutter/material.dart';

/// Soft cheetah palette: a clean white body with light apricot orange on icons,
/// buttons and highlights, and espresso brown text like the spots.
class AppTheme {
  static const seed = Color(0xFFC98A52);
  static const fontFamily = 'SpecialElite';

  static ThemeData light() => _build(ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ).copyWith(
        // Light apricot orange. Dark espresso text on it stays easy to read.
        primary: const Color(0xFFCC7F40),
        onPrimary: const Color(0xFF3A2112),
        primaryContainer: const Color(0xFFFDE9D7), // pale peach
        onPrimaryContainer: const Color(0xFF3B2312),
        secondary: const Color(0xFF6E5341), // espresso, like the spots
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFFDEEE1),
        onSecondaryContainer: const Color(0xFF2E1F14),
        tertiary: const Color(0xFF9A7A22), // golden coat
        tertiaryContainer: const Color(0xFFFBF0D2),
        onTertiaryContainer: const Color(0xFF2B2105),
        surface: Colors.white, // clean white body
        onSurface: const Color(0xFF2B211A),
        onSurfaceVariant: const Color(0xFF75675D),
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: const Color(0xFFFCF7F2), // cards: barely-warm white
        surfaceContainer: const Color(0xFFF9F2EB),
        surfaceContainerHigh: const Color(0xFFF6EDE4),
        surfaceContainerHighest: const Color(0xFFF1E6DB),
        outline: const Color(0xFFB3A296),
        outlineVariant: const Color(0xFFF0E3D6),
        inverseSurface: const Color(0xFF3A2E26),
        onInverseSurface: const Color(0xFFFBF1E6),
        inversePrimary: const Color(0xFFF5C08F),
        surfaceTint: Colors.transparent,
      ));

  static ThemeData dark() => _build(ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFFF5C08F), // soft apricot
        onPrimary: const Color(0xFF452408),
        primaryContainer: const Color(0xFF5E3D22),
        onPrimaryContainer: const Color(0xFFFFDDC2),
        secondary: const Color(0xFFDCC2AC),
        onSecondary: const Color(0xFF3D2B1D),
        secondaryContainer: const Color(0xFF4A392C),
        onSecondaryContainer: const Color(0xFFF6E0CC),
        tertiary: const Color(0xFFE2C46E),
        tertiaryContainer: const Color(0xFF574510),
        onTertiaryContainer: const Color(0xFFFBE7AE),
        surface: const Color(0xFF1A1512), // warm espresso
        onSurface: const Color(0xFFF0E5DB),
        onSurfaceVariant: const Color(0xFFC9B9AB),
        surfaceContainerLowest: const Color(0xFF14100D),
        surfaceContainerLow: const Color(0xFF221C18),
        surfaceContainer: const Color(0xFF27201B),
        surfaceContainerHigh: const Color(0xFF312923),
        surfaceContainerHighest: const Color(0xFF3B322B),
        outline: const Color(0xFF8F7F72),
        outlineVariant: const Color(0xFF4A3F37),
        inverseSurface: const Color(0xFFF0E5DB),
        onInverseSurface: const Color(0xFF2B211A),
        inversePrimary: const Color(0xFFA8642E),
        surfaceTint: Colors.transparent,
      ));

  static ThemeData _build(ColorScheme scheme) {
    // Special Elite: a typewriter font, bundled in assets/fonts so it works offline.
    final base = ThemeData(colorScheme: scheme, useMaterial3: true, fontFamily: fontFamily);
    final text = base.textTheme;
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: scheme.outlineVariant, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHigh.withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: scheme.outlineVariant),
        selectedColor: scheme.primaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
      ),
      sliderTheme: base.sliderTheme.copyWith(
        showValueIndicator: ShowValueIndicator.onDrag,
        inactiveTrackColor: scheme.primaryContainer,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(iconColor: scheme.primary),

      // ---- Modals: soft, roomy and rounded ----
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        barrierColor: const Color(0xFF2B1A0E).withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
        ),
        iconColor: scheme.primary,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
        contentTextStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant, height: 1.45),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surfaceContainerLowest,
        modalBarrierColor: const Color(0xFF2B1A0E).withValues(alpha: 0.45),
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: scheme.outlineVariant,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        dialBackgroundColor: scheme.surfaceContainerLow,
        hourMinuteColor: scheme.surfaceContainerHigh,
        dayPeriodColor: scheme.primaryContainer,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        headerBackgroundColor: scheme.primaryContainer,
        headerForegroundColor: scheme.onPrimaryContainer,
      ),
    );
  }
}
