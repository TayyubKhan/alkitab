import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:alkitab_core/alkitab_core.dart';
import 'package:alkitab_models/alkitab_models.dart';

part 'quran_viewmodel.g.dart';

// -----------------------------------------------------------------------------
// SEARCH PROVIDER
// -----------------------------------------------------------------------------
final quranSearchProvider = FutureProvider.family
    .autoDispose<List<QuranSearchResult>, String>((ref, query) async {
  return ref.read(quranRepositoryProvider).searchAyahs(query);
});

// -----------------------------------------------------------------------------
// 1. SURAH LIST PROVIDER
// -----------------------------------------------------------------------------
@riverpod
Future<List<Surah>> surahList(Ref ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getAllSurahs();
}

// -----------------------------------------------------------------------------
// 2. SURAH LIMIT PROVIDER (Pagination)
// -----------------------------------------------------------------------------
@riverpod
class SurahLimit extends _$SurahLimit {
  @override
  int build(int surahNumber) {
    return 20; // Initial limit
  }

  void loadMore() {
    state = state + 20;
  }

  void jumpTo(int ayahNumber) {
    if (ayahNumber > state) {
      state = ayahNumber + 20;
    }
  }
}

// -----------------------------------------------------------------------------
// 3. AYAH READER PROVIDER
// -----------------------------------------------------------------------------
@riverpod
Future<List<AyahWithTranslations>> ayahReader(
  Ref ref,
  int surahNumber,
) async {
  final repo = ref.watch(quranRepositoryProvider);
  final limit = ref.watch(surahLimitProvider(surahNumber));
  
  // Watch settings to trigger refetch if editions change
  final appConfig = ref.watch(appConfigViewModelProvider);
  
  final activeEditions = appConfig.activeTranslationIdentifiers.toList();
  final wbwEdition = appConfig.isDirectWBWEnabled ? appConfig.selectedWordByWordEdition : null;
  final reciterId = appConfig.selectedReciterIdentifier;

  return repo.getAyahsForSurah(
    surahNumber,
    activeEditions,
    wbwEdition,
    reciterId,
    limit: limit,
  );
}

// -----------------------------------------------------------------------------
// 4. EDITIONS PROVIDER
// -----------------------------------------------------------------------------
@riverpod
Future<List<Edition>> allEditions(Ref ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getAllTranslationEditions();
}

// -----------------------------------------------------------------------------
// 5. RECITERS PROVIDER
// -----------------------------------------------------------------------------
@riverpod
Future<List<Reciter>> allReciters(Ref ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getAllReciters();
}

// -----------------------------------------------------------------------------
// 6. AUDIO DOWNLOAD STATUS PROVIDER
// -----------------------------------------------------------------------------
@riverpod
Future<bool> isSurahAudioDownloaded(
  Ref ref,
  ({int surah, String reciter}) arg,
) async {
  // Mock for now, or use repo if extended
  return false;
}
