import 'package:flutter/material.dart';

@immutable
class QuranColors extends ThemeExtension<QuranColors> {
  final Color tajweedRule;
  final Color juzEndDecoration;
  final Color ayahEndSymbol;
  final Color wbwGridBorder;
  final Color wbwGridBackground;
  final Color wbwWordText;
  final Color wbwTranslationText;

  const QuranColors({
    required this.tajweedRule,
    required this.juzEndDecoration,
    required this.ayahEndSymbol,
    required this.wbwGridBorder,
    required this.wbwGridBackground,
    required this.wbwWordText,
    required this.wbwTranslationText,
  });

  @override
  QuranColors copyWith({
    Color? tajweedRule,
    Color? juzEndDecoration,
    Color? ayahEndSymbol,
    Color? wbwGridBorder,
    Color? wbwGridBackground,
    Color? wbwWordText,
    Color? wbwTranslationText,
  }) {
    return QuranColors(
      tajweedRule: tajweedRule ?? this.tajweedRule,
      juzEndDecoration: juzEndDecoration ?? this.juzEndDecoration,
      ayahEndSymbol: ayahEndSymbol ?? this.ayahEndSymbol,
      wbwGridBorder: wbwGridBorder ?? this.wbwGridBorder,
      wbwGridBackground: wbwGridBackground ?? this.wbwGridBackground,
      wbwWordText: wbwWordText ?? this.wbwWordText,
      wbwTranslationText: wbwTranslationText ?? this.wbwTranslationText,
    );
  }

  @override
  QuranColors lerp(ThemeExtension<QuranColors>? other, double t) {
    if (other is! QuranColors) {
      return this;
    }
    return QuranColors(
      tajweedRule: Color.lerp(tajweedRule, other.tajweedRule, t)!,
      juzEndDecoration:
          Color.lerp(juzEndDecoration, other.juzEndDecoration, t)!,
      ayahEndSymbol: Color.lerp(ayahEndSymbol, other.ayahEndSymbol, t)!,
      wbwGridBorder: Color.lerp(wbwGridBorder, other.wbwGridBorder, t)!,
      wbwGridBackground:
          Color.lerp(wbwGridBackground, other.wbwGridBackground, t)!,
      wbwWordText: Color.lerp(wbwWordText, other.wbwWordText, t)!,
      wbwTranslationText:
          Color.lerp(wbwTranslationText, other.wbwTranslationText, t)!,
    );
  }
}

@immutable
class QuranDimensions extends ThemeExtension<QuranDimensions> {
  final double ayahSymbolSize;
  final double wbwGridCellHeight;

  const QuranDimensions({
    required this.ayahSymbolSize,
    required this.wbwGridCellHeight,
  });

  @override
  QuranDimensions copyWith({
    double? ayahSymbolSize,
    double? wbwGridCellHeight,
  }) {
    return QuranDimensions(
      ayahSymbolSize: ayahSymbolSize ?? this.ayahSymbolSize,
      wbwGridCellHeight: wbwGridCellHeight ?? this.wbwGridCellHeight,
    );
  }

  @override
  QuranDimensions lerp(ThemeExtension<QuranDimensions>? other, double t) {
    if (other is! QuranDimensions) {
      return this;
    }
    return QuranDimensions(
      ayahSymbolSize:
          lerpDouble(ayahSymbolSize, other.ayahSymbolSize, t) ?? ayahSymbolSize,
      wbwGridCellHeight:
          lerpDouble(wbwGridCellHeight, other.wbwGridCellHeight, t) ??
              wbwGridCellHeight,
    );
  }

  // Helper for lerpDouble
  double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
