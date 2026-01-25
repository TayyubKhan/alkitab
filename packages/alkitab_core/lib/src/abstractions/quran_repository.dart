import 'package:alkitab_models/alkitab_models.dart';

import 'package:flutter/foundation.dart';
import '../models/setup_options.dart';

abstract class QuranRepository {
  Future<List<Surah>> getAllSurahs();
  
  Future<List<AyahWithTranslations>> getAyahsForSurah(
      int surahNumber,
      List<String> editionIdentifiers,
      String? wordByWordEdition,
      String? reciterIdentifier,
      {int limit = 20,
      int offset = 0});

  Future<List<QuranSearchResult>> searchAyahs(String query);
  
  Future<List<Edition>> getAllTranslationEditions();
  
  Future<List<Reciter>> getAllReciters();

  // --- Added Methods ---
  Future<void> downloadInitialData(SetupOptions options, ValueSetter<String> progress);

  Future<bool> isBaseDataDownloaded();

  Future<bool> isEditionDownloaded(String id);
  
  Future<void> downloadAndStoreTranslation(String id, ValueSetter<String> progress);
  
  Future<void> deleteAllLocalData();
}
