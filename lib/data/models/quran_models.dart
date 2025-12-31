import '../local/app_database.dart';

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

  // Helper for AudioSource Tag parsing if needed from JSON
  factory AyahWithTranslations.fromJson(Map<String, dynamic> json) =>
      AyahWithTranslations(
        numberInSurah: json['numberInSurah'] as int,
        arabicText: '',
        translations: {},
        tafsirs: {},
        words: [],
      );
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

  factory Surah.fromData(SurahsData d) => Surah(
      number: d.number,
      name: d.name,
      englishName: d.englishName,
      englishNameTranslation: d.englishNameTranslation,
      revelationType: d.revelationType,
      numberOfAyahs: d.numberOfAyahs);
}
// Add this to your existing quran_models.dart file

class QuranSearchResult {
  final int surahNumber;
  final String surahEnglishName;
  final int ayahNumber;
  final String text;
  final String? translationId; // Useful to know which edition matched

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

  factory AyahWord.fromData(WordTranslation d) => AyahWord(
        wordNumber: d.wordNumber,
        arabicText: d.arabicText,
        translation: d.translation,
        transliteration: d.transliteration,
        localAudioPath: d.localAudioPath,
      );
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

  factory Edition.fromData(CachedEdition d) => Edition(
      identifier: d.identifier,
      language: d.language,
      name: d.name,
      englishName: d.englishName,
      type: d.type);
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

  factory Reciter.fromData(CachedReciter d) => Reciter(
      identifier: d.identifier,
      language: d.language,
      name: d.name,
      englishName: d.englishName);
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
  WbWOption('bn_wbw', 'Bengali', 'bn')
];
