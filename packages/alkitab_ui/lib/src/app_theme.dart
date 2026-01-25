import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Needed for CupertinoPageTransitionsBuilder
import 'theme_extension.dart';

class AppTheme {
  // --- USER PALETTE (QuranTheme) ---
  static const _background = Color(0xFF0A0A0A); // Richer Black
  static const _surface = Color(0xFF141414); // Slightly lighter than bg
  static const _textPrimary = Color(0xFFFFFFFF); // White
  static const _textSecondary = Color(0xFFB0B0B0); // Grey
  static const _primaryGreen = Color(0xFF006400); // Dark Green

  // --- LIGHT THEME (Derived or Keep Default) ---
  // Keeping original light theme for fallback, but ideally should match new design language if needed.
  // For now, minimizing changes to Light unless requested. 
  // We'll update Light to use the Green/Gold logic but keep white background.
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Lato',

    colorScheme: const ColorScheme.light(
      primary: _primaryGreen,
      onPrimary: Colors.white,
      secondary: _primaryGreen,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black, // Dark text on light
      surfaceContainer: Color(0xFFF5F5F5), // Light grey
      outline: Color(0x33000000),
      tertiary: Color(0xFF666666),
      error: Color(0xFFCF6679),
    ),

    extensions: <ThemeExtension<dynamic>>[
      const QuranColors(
        tajweedRule: Color(0xFFD32F2F),
        juzEndDecoration: _primaryGreen,
        ayahEndSymbol: _primaryGreen,
        wbwGridBorder: Color(0x33000000),
        wbwGridBackground: Colors.transparent,
        wbwWordText: Colors.black,
        wbwTranslationText: _primaryGreen,
      ),
      const QuranDimensions(
        ayahSymbolSize: 32.0,
        wbwGridCellHeight: 140.0,
      ),
    ],

    textTheme: _buildTextTheme(Colors.black, const Color(0xFF666666)),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // --- DARK THEME (The Requested QuranTheme) ---
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _background,
    fontFamily: 'Lato', // Keeping global font, but Quran text uses specific fonts

    // 1. Color Scheme
    colorScheme: const ColorScheme.dark(
      surface: _surface,
      primary: _primaryGreen,
      onPrimary: _textPrimary,
      secondary: _primaryGreen,
      onSecondary: _textPrimary, // Gold is darkish? Or maybe Text on Gold. 
      // User said: onBackground: textPrimary
      onBackground: _textPrimary,
      // User said: onSurface: textSecondary
      onSurface: _textSecondary, 
      
      // Additional mappings for consistency
      surfaceContainer: _surface, 
      outline: Color(0x33FFFFFF), // Subtle border
      tertiary: _textSecondary,
      error: Color(0xFFCF6679),
    ),

    // 2. Extensions
    extensions: <ThemeExtension<dynamic>>[
      const QuranColors(
        tajweedRule: Color(0xFFEF5350),
        juzEndDecoration: _primaryGreen,
        ayahEndSymbol: _primaryGreen,
        wbwGridBorder: Color(0x33FFFFFF),
        wbwGridBackground: _surface,
        wbwWordText: _textPrimary, // Ensure words are WHITE
        wbwTranslationText: _primaryGreen,
      ),
      const QuranDimensions(
        ayahSymbolSize: 32.0,
        wbwGridCellHeight: 140.0,
      ),
    ],

    // 3. Text Theme
    textTheme: _buildTextTheme(_textPrimary, _textSecondary),

    // 4. Component Themes
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: _textPrimary),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),

    cardTheme: CardThemeData(
      color: _surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0x33FFFFFF)),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      iconColor: _textSecondary,
      textColor: _textPrimary,
    ),

    dividerTheme: const DividerThemeData(color: Color(0x33FFFFFF), thickness: 1),
    iconTheme: const IconThemeData(color: _textPrimary, size: 24),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryGreen,
        foregroundColor: _textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryGreen,
        side: const BorderSide(color: Color(0x33FFFFFF)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryGreen,
      foregroundColor: _textPrimary,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _background,
      selectedItemColor: _primaryGreen,
      unselectedItemColor: _textSecondary,
      type: BottomNavigationBarType.fixed,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryGreen),
      ),
      hintStyle: TextStyle(color: _textSecondary.withValues(alpha: 0.7)),
    ),
  );

  // --- TEXT STYLE DEFINITIONS ---
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      // Quranic / Arabic Large
      displayLarge: TextStyle(
        fontFamily: 'Scheherazade', // User requested
        fontSize: 32,
        height: 2.0,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // Quranic Mixed / Titles
      displayMedium: TextStyle(
        fontFamily: 'Scheherazade',
        fontSize: 28,
        height: 1.8,
        color: primary,
      ),
      // App Headings
      headlineLarge: _headingStyle(primary, 36),
      headlineMedium: _headingStyle(primary, 28),
      headlineSmall: _headingStyle(primary, 24),

      // Section Titles
      titleLarge: _headingStyle(primary, 20),
      titleMedium: TextStyle(
          fontFamily: 'GT-Super-Text-Book',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primary),
      titleSmall: TextStyle(
          fontFamily: 'GT-Super-Text-Book',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: secondary),

      // Body Text
      bodyLarge: TextStyle(
          fontFamily: 'Lato', fontSize: 16, height: 1.5, color: primary),
      bodyMedium: TextStyle(
          fontFamily: 'Lato', 
          fontSize: 16, 
          height: 1.5, 
          color: secondary), // Matches user: translationText color = textSecondary
      bodySmall: TextStyle(
          fontFamily: 'Lato', fontSize: 12, height: 1.5, color: secondary),

      // Labels
      labelLarge: TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primary),
      labelMedium: TextStyle(
          fontFamily: 'Lato',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: secondary),
      labelSmall: TextStyle(
          fontFamily: 'Lato',
          fontSize: 10,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500,
          color: secondary.withValues(alpha: 0.8)),
    );
  }

  static TextStyle _headingStyle(Color color, double size) {
    return TextStyle(
      fontFamily: 'GT-Super-Text-Book',
      fontSize: size,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: color,
    );
  }
}
