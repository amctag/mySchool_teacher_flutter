import 'package:flutter/material.dart';
import 'package:my_school_teacher/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => _theme(
    brightness: Brightness.light,
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: Color(0xFF5A1B08),
      secondary: Color(0xFFA8446B),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF8D8E5),
      onSecondaryContainer: Color(0xFF3F1028),
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFBE6F2),
      onTertiaryContainer: Color(0xFF48102F),
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDADB),
      onErrorContainer: Color(0xFF410008),
      surface: AppColors.card,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.outline,
      outlineVariant: Color(0xFFF0E7E2),
      shadow: Color(0x28000000),
      scrim: Color(0x66000000),
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.surface,
      inversePrimary: Color(0xFFFFB69D),
      surfaceTint: AppColors.primary,
    ),
    scaffold: AppColors.surface,
  );

  static ThemeData get dark => _theme(
    brightness: Brightness.dark,
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB69D),
      onPrimary: Color(0xFF5A1B08),
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: Color(0xFFFFDBCF),
      secondary: Color(0xFFFFAFCD),
      onSecondary: Color(0xFF5A1236),
      secondaryContainer: Color(0xFF75284D),
      onSecondaryContainer: Color(0xFFFFD9E5),
      tertiary: Color(0xFFFFA9D2),
      onTertiary: Color(0xFF631044),
      tertiaryContainer: Color(0xFF7E285C),
      onTertiaryContainer: Color(0xFFFFD8E8),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: AppColors.darkCard,
      onSurface: AppColors.darkText,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkOutline,
      outlineVariant: Color(0xFF39322E),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.darkText,
      onInverseSurface: AppColors.darkSurface,
      inversePrimary: AppColors.primary,
      surfaceTint: Color(0xFFFFB69D),
    ),
    scaffold: AppColors.darkSurface,
  );

  static ThemeData _theme({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffold,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          fontSize: 15,
          height: 1.5,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.5,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: scheme.onPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? AppColors.surfaceSoft
            : AppColors.darkSurfaceSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: brightness == Brightness.light
              ? AppColors.surfaceSoft
              : AppColors.darkSurfaceSoft,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(scheme.surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
      ),
    );
  }
}
