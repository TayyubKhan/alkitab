// Shared domain models.
// Note: These models are pure Dart and do not depend on Drift or local database implementation.

class AyahWithTranslations {
  final int numberInSurah;
  final String arabicText;
  final String? tajweedText;
  final Map<String, String> translations;
  final Map<String, String> tafsirs;
  final String? audioUrl;
  final List<AyahWord> words;
  final String? transliteration;

  AyahWithTranslations({
    required this.numberInSurah,
    required this.arabicText,
    this.tajweedText,
    required this.translations,
    required this.tafsirs,
    this.audioUrl,
    required this.words,
    this.transliteration,
  });

  factory AyahWithTranslations.fromJson(Map<String, dynamic> json) =>
      AyahWithTranslations(
        numberInSurah: json['numberInSurah'] as int,
        arabicText: json['text'] as String? ?? '', // Adapted for API
        translations: {},
        tafsirs: {},
        words: [],
      );
  
  @override
  String toString() {
    return 'AyahWithTranslations{\n'
        '  numberInSurah: $numberInSurah,\n'
        '  arabicText: $arabicText,\n'
        '  tajweedText: $tajweedText,\n'
        '  translations: $translations,\n'
        '  tafsirs: $tafsirs,\n'
        '  audioUrl: $audioUrl,\n'
        '  words: $words,\n'
        '  transliteration: $transliteration\n'
        '}';
  }
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs']);
}

class QuranSearchResult {
  final int surahNumber;
  final String surahEnglishName;
  final int ayahNumber;
  final String text;
  final String? translationId; 

  QuranSearchResult({
    required this.surahNumber,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.text,
    this.translationId,
  });
}

class AyahWord {
  final int wordNumber;
  final String arabicText;
  final String translation;
  final String transliteration;
  final String? localAudioPath;

  AyahWord({
    required this.wordNumber,
    required this.arabicText,
    required this.translation,
    required this.transliteration,
    this.localAudioPath,
  });

  @override
  String toString() {
    return 'AyahWord(num: $wordNumber, ar: $arabicText, tr: $translation)';
  }
}

class Edition {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String type;

  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.type,
  });

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
        identifier: json['id'].toString(),
        language: json['language_name'] ?? 'en',
        name: json['name'],
        englishName: json['author_name'],
        type: json['type'] ?? 'translation',
      );
}

class Reciter {
  final String identifier;
  final String language;
  final String name;
  final String englishName;

  Reciter({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
  });

  factory Reciter.fromJson(Map<String, dynamic> j) => Reciter(
      identifier: j['id'].toString(),
      language: 'ar',
      name: j['reciter_name'],
      englishName: j['style'] ?? j['reciter_name']);
}

class WbWOption {
  final String id;
  final String title;
  final String langCode;
  WbWOption(this.id, this.title, this.langCode);
}

final wbwOptionsList = [
  WbWOption('en_wbw', 'English', 'en'),
  WbWOption('ur_wbw', 'Urdu', 'ur'),
  WbWOption('id_wbw', 'Indonesian', 'id'),
];

class LastViewedPosition {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final int totalAyahs;

  LastViewedPosition({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.totalAyahs,
  });
}

