import 'package:flutter/material.dart';

class AppTheme {
  // --- PRIVATE PALETTE (Only used inside this file) ---
  static const _voidBlack = Color(0xFF000000);
  static const _divineGoldLight =
      Color(0xff144a18); // softer gold for light theme
  static const _divineGoldDark =
      Color(0xff2eae34); // original gold for dark theme
  static const _surfaceDark = Color(0xFF121212);
  static const _pureWhite = Color(0xFFFFFFFF);
  static const _stoneGrey = Color(0xFF888888);
  static const _lightGrey = Color(0xFFF7F7F7);
  static const _borderDark = Color(0x33FFFFFF); // 20% White
  static const _borderLight = Color(0x33000000); // 20% Black

  // --- LIGHT THEME ---
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _pureWhite,
    fontFamily: 'Lato',

    // 1. Color Scheme Mapping
    colorScheme: const ColorScheme.light(
      primary: _voidBlack,
      onPrimary: _pureWhite,
      secondary: _divineGoldLight, // softer gold for light theme
      onSecondary: _pureWhite,
      surface: _pureWhite,
      onSurface: _voidBlack,
      surfaceContainer: _lightGrey,
      outline: _borderLight,
      tertiary: _stoneGrey,
    ),

    // 2. Text Theme Mapping
    textTheme: _buildTextTheme(Colors.black),

    // 3. Component Defaults
    appBarTheme: AppBarTheme(
      backgroundColor: _pureWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: _headingStyle(Colors.black, 24),
    ),
    cardTheme: CardThemeData(
      color: _pureWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _borderLight),
      ),
    ),
    dividerTheme: const DividerThemeData(color: _borderLight, thickness: 1),
    iconTheme: const IconThemeData(color: Colors.black, size: 24),
  );

  // --- DARK THEME ---
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _voidBlack,
    fontFamily: 'Lato',

    // 1. Color Scheme Mapping
    colorScheme: const ColorScheme.dark(
      primary: _divineGoldDark,
      onPrimary: _voidBlack,
      secondary: _divineGoldDark,
      onSecondary: _voidBlack,
      surface: _surfaceDark,
      onSurface: _pureWhite,
      surfaceContainer: _voidBlack,
      outline: _borderDark,
      tertiary: _stoneGrey,
    ),

    // 2. Text Theme Mapping
    textTheme: _buildTextTheme(Colors.white),

    // 3. Component Defaults
    appBarTheme: AppBarTheme(
      backgroundColor: _voidBlack,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: _headingStyle(Colors.white, 24),
    ),
    cardTheme: CardThemeData(
      color: _surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _borderDark),
      ),
    ),
    dividerTheme: const DividerThemeData(color: _borderDark, thickness: 1),
    iconTheme: const IconThemeData(color: Colors.white, size: 24),
  );

  // --- TEXT STYLE DEFINITIONS ---
  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'quranfont',
        fontSize: 20,
        height: 2.0,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Gulzar',
        fontSize: 24,
        height: 2.2,
        color: baseColor,
      ),
      headlineLarge: _headingStyle(baseColor, 36),
      headlineMedium: _headingStyle(baseColor, 28),
      headlineSmall: _headingStyle(baseColor, 24),
      titleLarge: _headingStyle(baseColor, 22),
      bodyLarge: TextStyle(
          fontFamily: 'Lato', fontSize: 18, height: 1.5, color: baseColor),
      bodyMedium: TextStyle(
          fontFamily: 'Lato', fontSize: 16, height: 1.5, color: baseColor),
      labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: baseColor),
      labelSmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500,
          color: baseColor.withOpacity(0.7)),
    );
  }

  static TextStyle _headingStyle(Color color, double size) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: color,
    );
  }
}
