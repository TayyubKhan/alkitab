import 'package:flutter/material.dart';

class NumberUtils {
  static String localize(String input, BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'ar' || locale.languageCode == 'ur') {
      const westernDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const easternDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      
      for (int i = 0; i < westernDigits.length; i++) {
        input = input.replaceAll(westernDigits[i], easternDigits[i]);
      }
    }
    // Add other numeral systems if needed (e.g., Bengali)
    if (locale.languageCode == 'bn') {
       const westernDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const bengaliDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
       for (int i = 0; i < westernDigits.length; i++) {
        input = input.replaceAll(westernDigits[i], bengaliDigits[i]);
      }
    }
    return input;
  }
}
