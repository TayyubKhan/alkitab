// -----------------------------------------------------------------------------
// Providers & ViewModels
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/quran_models.dart';
import '../../data/repositories/quran_repository.dart';
import '../../features/onboarding/startup_screens.dart';
import '../../features/quran/screens/ayah_list_screen.dart';
import '../../viewmodels/audio_viewmodel.dart';
import '../../viewmodels/download_viewmodel.dart';
import '../../viewmodels/quran_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../utils/app_logger.dart';
import '../utils/language_utils.dart';
import '../widgets/common_widgets.dart';

part 'controllers.g.dart';

/// Manages the local state of the Setup Screen (Reciter selection)
/// and orchestrates the download sequence.
@riverpod
class AutoSetupController extends _$AutoSetupController {
  @override
  String? build() => null;

  void setSelectedReciter(String id) {
    state = id;
  }

  /// Sets default reciter (Mishary) if none is selected.
  /// Returns true if state was updated.
  bool initializeDefaultReciter(List<Reciter> reciters) {
    if (state != null) return false;

    if (reciters.isNotEmpty) {
      final mishary = reciters.firstWhere(
        (r) => r.name.contains("Mishary"),
        orElse: () => reciters.first,
      );
      state = mishary.identifier;
      return true;
    }
    return false;
  }

  /// Orchestrates the initial download sequence.
  /// Returns [true] if successful and navigation should proceed.
  Future<bool> startDownloadSequence() async {
    AppLogger.i("Starting Initial Download Sequence from Setup Screen...");

    // 1. Save Reciter to App Config
    if (state != null) {
      ref.read(appConfigViewModelProvider.notifier).setSelectedReciter(state!);
      // FIX: Sync to SetupOptions so DownloadVM sees it
      ref.read(setupOptionsProvider.notifier).setReciter(state!);
    }

    // 2. Start Data Download
    final success =
        await ref.read(dataDownloadViewModelProvider.notifier).startDownload();

    if (success) {
      AppLogger.i("Download Sequence Complete. Refreshing Providers.");

      // 3. Invalidate / Reset Providers
      ref.invalidate(allEditionsProvider);
      ref.invalidate(allRecitersProvider);
      ref.invalidate(isAnythingDownloadedProvider);
      ref.invalidate(surahListProvider);
      ref.read(audioControlProvider.notifier).stop();

      return true;
    } else {
      AppLogger.w("Download Sequence Failed or Cancelled on Setup.");
      return false;
    }
  }
}

/// Computes the grouped and sorted translations for the Setup Screen.
/// Moves heavy list manipulation out of the UI.
@riverpod
List<MapEntry<String, List<Edition>>> sortedTranslations(Ref ref) {
  final allEditionsAsync = ref.watch(allEditionsProvider);

  return allEditionsAsync.maybeWhen(
    data: (editions) {
      final translations =
          editions.where((e) => e.type == 'translation').toList();

      // Group by Language
      final groups = <String, List<Edition>>{};
      for (var e in translations) {
        groups.putIfAbsent(e.language, () => []).add(e);
      }

      // Sort translations WITHIN each language group alphabetically by Author/EnglishName
      for (var key in groups.keys) {
        groups[key]!.sort((a, b) => a.englishName.compareTo(b.englishName));
      }

      // Priority List
      const priorityLanguages = [
        'en', // English (Global)
        'ur', // Urdu (High User Base)
        'id', // Indonesian (High User Base)
        'ar', // Arabic
        'bn', // Bengali
        'hi', // Hindi
        'tr', // Turkish
        'fr', // French
        'es', // Spanish
        'ru', // Russian
        'de', // German
        'zh', // Chinese
        'ms', // Malay
      ];

      // Sort
      final sortedEntries = groups.entries.toList();
      sortedEntries.sort((a, b) {
        final rankA = priorityLanguages.indexOf(a.key);
        final rankB = priorityLanguages.indexOf(b.key);

        if (rankA != -1 && rankB != -1) return rankA.compareTo(rankB);
        if (rankA != -1) return -1;
        if (rankB != -1) return 1;

        final nameA = LanguageUtils.getLanguageName(a.key);
        final nameB = LanguageUtils.getLanguageName(b.key);
        return nameA.compareTo(nameB);
      });

      return sortedEntries;
    },
    orElse: () => [],
  );
}

// -----------------------------------------------------------------------------
// CONTROLLER (Handles Navigation & Reset Logic)
// -----------------------------------------------------------------------------

@riverpod
class SurahListController extends _$SurahListController {
  @override
  void build() {}

  Future<void> navigateToLastSeen(
    BuildContext context,
    LastViewedState last,
  ) async {
    if (last.surah == null || last.ayah == null) return;

    try {
      // Safely fetch the Surah object
      final surahList = await ref.read(surahListProvider.future);
      final surah = surahList.firstWhere(
        (s) => s.number == last.surah,
        orElse: () => surahList.first,
      );

      if (context.mounted) {
        AppLogger.i(
            "Navigating to Last Seen: ${surah.englishName} Ayah ${last.ayah}");
        Navigator.push(
          context,
          FadePageRoute(
            builder: (_) =>
                AyahListScreen(surah: surah, initialAyah: last.ayah),
          ),
        );
      }
    } catch (e) {
      AppLogger.e("Failed to navigate to last seen", e);
    }
  }

  Future<void> resetApplication(BuildContext context) async {
    // 1. Stop Audio
    await ref.read(audioControlProvider.notifier).stop();

    // 2. Delete Data
    await ref.read(quranRepositoryProvider).deleteAllLocalData();

    // 3. Invalidate State
    ref.invalidate(isAnythingDownloadedProvider);
    ref.invalidate(surahListProvider);
    ref.invalidate(allEditionsProvider);

    // 4. Navigate to Startup
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AutoSetupScreen()),
        (route) => false,
      );
    }
  }
}
