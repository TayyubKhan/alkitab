import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/local/app_database.dart';
import '../data/models/quran_models.dart';
import '../data/repositories/quran_repository.dart';
import 'settings_viewmodel.dart';

part 'quran_viewmodel.g.dart';

// -----------------------------------------------------------------------------
// CONSTANTS
// -----------------------------------------------------------------------------

const int _kInitialAyahLimit = 40; // Load 40 initially (Optimized)
const int _kPaginationStep = 50; // Load 50 more when needed
const int _kJumpBuffer = 20; // Extra verses to load after a jump target

// -----------------------------------------------------------------------------
// 1. SURAH LIMIT NOTIFIER (Pagination Logic)
// -----------------------------------------------------------------------------

@riverpod
class SurahLimitNotifier extends _$SurahLimitNotifier {
  @override
  int build(int surahNumber) {
    // Initial state: load minimal verses for fast startup
    return _kInitialAyahLimit;
  }

  void loadMore() {
    state = state + _kPaginationStep;
  }

  void jumpTo(int ayahNumber) {
    if (state < ayahNumber + _kJumpBuffer) {
      state = ayahNumber + _kJumpBuffer;
    }
  }
}

// Usage: ref.watch(surahLimitNotifierProvider(surahNumber));

// -----------------------------------------------------------------------------
// 2. MAIN DATA PROVIDERS
// -----------------------------------------------------------------------------

@Riverpod(keepAlive: true)
Future<List<Surah>> surahList(Ref ref) async {
  return ref.watch(quranRepositoryProvider).getAllSurahs();
}

@Riverpod(keepAlive: true)
Future<List<Edition>> allEditions(Ref ref) async {
  return ref.watch(quranRepositoryProvider).getAllTranslationEditions();
}

@Riverpod(keepAlive: true)
Future<List<Reciter>> allReciters(Ref ref) async {
  return ref.watch(quranRepositoryProvider).getAllReciters();
}

@riverpod
Future<bool> isSurahAudioDownloaded(
    Ref ref, ({int surah, String reciter}) args) async {
  return ref
      .watch(quranRepositoryProvider)
      .isSurahAudioDownloaded(args.surah, args.reciter);
}

@riverpod
Future<bool> isWbWEditionDownloaded(Ref ref, String id) async {
  return ref.watch(databaseProvider).isWbWEditionDownloaded(id);
}

// -----------------------------------------------------------------------------
// 3. AYAH READER PROVIDER
// -----------------------------------------------------------------------------

@riverpod
Future<List<AyahWithTranslations>> ayahReader(Ref ref, int surahNum) async {
  final config = ref.watch(appConfigViewModelProvider);
  final repo = ref.watch(quranRepositoryProvider);
  final database = ref.watch(databaseProvider);

  // 1. Watch Pagination Limit
  final currentLimit = ref.watch(surahLimitProvider(surahNum));

  // 2. Watch Editions to trigger rebuild on download completion
  ref.watch(allEditionsProvider);

  final selectedReciter = config.selectedReciterIdentifier;

  // 3. Fetch Data from Repository
  final ayahs = await repo.getAyahsForSurah(
    surahNum,
    config.activeTranslationIdentifiers,
    config.selectedWordByWordEdition,
    selectedReciter,
    limit: currentLimit,
  );

  // 4. Override with Local Audio Paths if available
  if (selectedReciter != null) {
    final localPaths =
        await database.getDownloadedAudioPaths(surahNum, selectedReciter);

    if (localPaths.isNotEmpty) {
      return _injectLocalAudioPaths(ayahs, localPaths);
    }
  }

  return ayahs;
}

// -----------------------------------------------------------------------------
// HELPER FUNCTIONS
// -----------------------------------------------------------------------------

/// Reconstructs the list of Ayahs with local file paths for audio
/// where available.
List<AyahWithTranslations> _injectLocalAudioPaths(
  List<AyahWithTranslations> ayahs,
  Map<int, String> localPaths,
) {
  return ayahs.map((a) {
    final localPath = localPaths[a.numberInSurah];

    if (localPath == null) return a;

    return AyahWithTranslations(
      numberInSurah: a.numberInSurah,
      arabicText: a.arabicText,
      tajweedText: a.tajweedText,
      translations: a.translations,
      tafsirs: a.tafsirs,
      audioUrl: 'file://$localPath',
      words: a.words,
      transliteration: a.transliteration,
    );
  }).toList();
}
// Update this provider in surah_list_screen.dart (or viewmodel file)

final quranSearchProvider = FutureProvider.family
    .autoDispose<List<QuranSearchResult>, String>((ref, query) async {
  final repository = ref.read(quranRepositoryProvider);
  // Now we call the real method we just created
  return repository.searchAyahs(query);
});
