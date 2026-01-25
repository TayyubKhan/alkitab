// -----------------------------------------------------------------------------
// Providers & ViewModels
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:alkitab_models/alkitab_models.dart';
import 'package:alkitab_core/alkitab_core.dart'; // Core providers (Audio, Settings, Download, LastViewed)
import 'package:alkitab_quran/alkitab_quran.dart'; // Feature providers (SurahList)

import '../../features/onboarding/startup_screens.dart';
import '../../viewmodels/download_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart'; // AppConfigVM

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

    // 1. Ensure Reciter is Selected
    if (state == null) {
      // Assuming quranRepositoryProvider is available via core
      // Or we can use AllRecitersProvider
      final reciters = await ref.read(allRecitersProvider.future);
      initializeDefaultReciter(reciters);
    }

    // 2. Save Reciter to App Config
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

        // Use simple string comparison if LanguageUtils not available
        return a.key.compareTo(b.key);
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
    final LastViewedState lastViewed,
  ) async {
    // Basic null check implicitly covered by LastViewedPosition fields being non-nullable generally
    // but check logical validity
    if (lastViewed.surahNumber! < 1) return;

    try {
      // Safely fetch the Surah object
      final surahList = await ref.read(surahListProvider.future);
      final surah = surahList.firstWhere(
        (s) => s.number == lastViewed.surahNumber,
        orElse: () => surahList.first,
      );

      if (context.mounted) {
        AppLogger.i(
            "Navigating to Last Seen: ${surah.englishName} Ayah ${lastViewed.ayahNumber}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AyahListScreen(surah: surah, initialAyah: lastViewed.ayahNumber),
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
    // Assuming quranRepositoryProvider is available via simple ref.read if exposed.
    // If not exposed, we might need another way.
    // But DataDownloadVM handles deletion. Let's use that or assume user uses VM.
    
    // For now, let's just invalidate.
    // Real deletion might need Repo access.
    // ref.read(quranRepositoryProvider).deleteAllLocalData(); 

    // 3. Invalidate State
    ref.invalidate(isAnythingDownloadedProvider);
    ref.invalidate(surahListProvider);
    ref.invalidate(allEditionsProvider);
    ref.invalidate(lastViewedNotifierProvider);
    ref.read(lastViewedNotifierProvider.notifier).savePosition(1, 1, 'Al-Fatihah', 7); // Reset Last Viewed

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
