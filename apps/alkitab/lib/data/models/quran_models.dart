import '../local/app_database.dart';
import 'package:alkitab_models/alkitab_models.dart';

// Export everything from the domain package
export 'package:alkitab_models/alkitab_models.dart';

// --- MAPPERS (Data -> Domain) ---
// We define extensions on the DRIFT GENERATED CLASSES (Data Layer)
// to convert them into Domain Entities.

extension SurahDataExtension on SurahsData {
  Surah toDomain() => Surah(
      number: number,
      name: name,
      englishName: englishName,
      englishNameTranslation: englishNameTranslation,
      revelationType: revelationType,
      numberOfAyahs: numberOfAyahs);
}

extension WordTranslationExtension on WordTranslation {
  AyahWord toDomain() => AyahWord(
        wordNumber: wordNumber,
        arabicText: arabicText,
        translation: translation,
        transliteration: transliteration,
        localAudioPath: localAudioPath,
      );
}

extension CachedEditionExtension on CachedEdition {
  Edition toDomain() => Edition(
      identifier: identifier,
      language: language,
      name: name,
      englishName: englishName,
      type: type);
}

extension CachedReciterExtension on CachedReciter {
  Reciter toDomain() => Reciter(
      identifier: identifier,
      language: language,
      name: name,
      englishName: englishName);
}
