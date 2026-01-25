import 'package:flutter_test/flutter_test.dart';
import 'package:alkitab/data/models/quran_models.dart';
import 'package:alkitab/data/local/app_database.dart';

void main() {
  group('Quran Models Tests', () {
    test('Surah.fromData should map correctly', () {
      final data = SurahsData(
        number: 1,
        name: 'الفاتحة',
        englishName: 'Al-Fatiha',
        englishNameTranslation: 'The Opening',
        revelationType: 'Meccan',
        numberOfAyahs: 7,
      );

      final surah = data.toDomain();

      expect(surah.number, 1);
      expect(surah.name, 'الفاتحة');
      expect(surah.englishName, 'Al-Fatiha');
      expect(surah.englishNameTranslation, 'The Opening');
      expect(surah.revelationType, 'Meccan');
      expect(surah.numberOfAyahs, 7);
    });

    test('AyahWithTranslations.fromJson should handle minimal structure', () {
      final json = {'numberInSurah': 1};
      final ayah = AyahWithTranslations.fromJson(json);

      expect(ayah.numberInSurah, 1);
      expect(ayah.arabicText, '');
      expect(ayah.translations, isEmpty);
      expect(ayah.tafsirs, isEmpty);
      expect(ayah.words, isEmpty);
    });

    test('AyahWord.fromData should map correctly', () {
      final data = WordTranslation(
        id: 1,
        surahNumber: 1,
        numberInSurah: 1,
        wordNumber: 1,
        edition: 'en_wbw',
        arabicText: 'بِسْمِ',
        translation: 'In (the) name',
        transliteration: 'bis\'mi',
        audioUrl: 'url',
        localAudioPath: 'path',
      );

      final word = data.toDomain();

      expect(word.wordNumber, 1);
      expect(word.arabicText, 'بِسْمِ');
      expect(word.translation, 'In (the) name');
      expect(word.transliteration, 'bis\'mi');
      expect(word.localAudioPath, 'path');
    });

    test('Edition.fromJson should handle both translation and tafsir', () {
      final transJson = {
        'id': 131,
        'language_name': 'English',
        'name': 'Saheeh International',
        'author_name': 'Saheeh International',
        'type': 'translation'
      };

      final edition = Edition.fromJson(transJson);
      expect(edition.identifier, '131');
      expect(edition.language, 'English');
      expect(edition.type, 'translation');

      final tafsirJson = {
        'id': 160,
        'language_name': 'Urdu',
        'name': 'Tafsir Ibn Kathir',
        'author_name': 'Ibn Kathir',
        'type': 'tafsir'
      };
      final tafsir = Edition.fromJson(tafsirJson);
      expect(tafsir.identifier, '160');
      expect(tafsir.type, 'tafsir');
    });

    test('Reciter.fromJson should map correctly', () {
      final json = {
        'id': '7',
        'reciter_name': 'Mishari Rashid al-`Afasy',
        'style': 'Murattal'
      };

      final reciter = Reciter.fromJson(json);
      expect(reciter.identifier, '7');
      expect(reciter.name, 'Mishari Rashid al-`Afasy');
      expect(reciter.englishName, 'Murattal');
    });
  });
}
