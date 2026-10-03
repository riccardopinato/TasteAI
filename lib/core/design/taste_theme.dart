import 'package:flutter/material.dart';

abstract final class TastePalette {
  static const Color sage = Color(0xFF6F8F78);
  static const Color apricot = Color(0xFFF5A66F);
  static const Color cream = Color(0xFFFFF9F3);
  static const Color ink = Color(0xFF242424);
}

abstract final class TasteTheme {
  static ThemeData light() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: TastePalette.sage,
      brightness: Brightness.light,
      surface: TastePalette.cream,
    );

    return _base(
      scheme.copyWith(
        primary: TastePalette.sage,
        secondary: TastePalette.apricot,
      ),
      scaffold: scheme.surface,
    );
  }

  static ThemeData dark() {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: TastePalette.sage,
      brightness: Brightness.dark,
    );

    return _base(
      scheme.copyWith(
        primary: const Color(0xFF9BC5A6),
        secondary: const Color(0xFFFFB98C),
      ),
      scaffold: scheme.surface,
    );
  }

  static ThemeData _base(
    ColorScheme scheme, {
    required Color scaffold,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
      ),
      navigationRailTheme: NavigationRailThemeData(
        indicatorColor: scheme.secondaryContainer,
        useIndicator: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
