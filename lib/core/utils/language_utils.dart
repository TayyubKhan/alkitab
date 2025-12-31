class LanguageUtils {
  static String getLanguageName(String code) {
    final Map<String, String> languageNames = {
      // A
      'am': 'Amharic',
      'ar': 'Arabic',
      'az': 'Azerbaijani',
      // B
      'ba': 'Bashkir', // or Balochi depending on source, usually Bashkir in ISO
      'ber': 'Amazigh (Berber)',
      'bg': 'Bulgarian',
      'bn': 'Bengali',
      'bs': 'Bosnian',
      // C
      'ce': 'Chechen',
      'cs': 'Czech',
      // D
      'de': 'German',
      'dv': 'Divehi',
      // E
      'en': 'English',
      'es': 'Spanish',
      // F
      'fa': 'Persian',
      'fr': 'French',
      // H
      'ha': 'Hausa',
      'hi': 'Hindi',
      // I
      'id': 'Indonesian',
      'it': 'Italian',
      // J
      'ja': 'Japanese',
      // K
      'ko': 'Korean',
      'ku': 'Kurdish',
      // M
      'ml': 'Malayalam',
      'ms': 'Malay',
      'my': 'Burmese',
      // N
      'nl': 'Dutch',
      'no': 'Norwegian',
      // P
      'pl': 'Polish',
      'ps': 'Pashto',
      'pt': 'Portuguese',
      // R
      'ro': 'Romanian',
      'ru': 'Russian',
      // S
      'sd': 'Sindhi',
      'si': 'Sinhala',
      'so': 'Somali',
      'sq': 'Albanian',
      'sv': 'Swedish',
      'sw': 'Swahili',
      // T
      'ta': 'Tamil',
      'tg': 'Tajik',
      'th': 'Thai',
      'tr': 'Turkish',
      'tt': 'Tatar',
      // U
      'ug': 'Uyghur',
      'ur': 'Urdu',
      'uz': 'Uzbek',
      // Z
      'zh': 'Chinese',
    };

    // 1. Normalize input to lowercase
    final lowerCode = code.toLowerCase();

    // 2. Return name if found, otherwise return the uppercase code (e.g. "XX")
    return languageNames[lowerCode] ?? code.toUpperCase();
  }
}
