import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/quran_models.dart';
import '../data/repositories/quran_repository.dart';
import 'quran_viewmodel.dart';

// -----------------------------------------------------------------------------
// CONSTANTS (SharedPreferences Keys)
// -----------------------------------------------------------------------------
class _PrefsKeys {
  // Font Sizes
  static const fontSizeArabic = 'fs_ar';
  static const fontSizeTranslation = 'fs_tr';
  static const fontSizeTafsir = 'fs_tafsir'; // NEW
  static const fontSizeWBW = 'fs_wbw';

  // Visuals
  static const isDarkTheme = 'dark';
  static const appLanguage = 'app_lang';
  static const arabicFontStyle = 'ar_font_style'; // 'uthmani' or 'naskh'

  // Reading Preferences
  static const showArabic = 'show_ar';
  static const tajweed = 'tajweed';
  static const isTranslationOnly = 'is_tr_only';
  static const activeTranslations = 'active_trans';

  // Word By Word
  static const wordByWord = 'wbw'; // The specific edition ID
  static const isDirectWBW = 'is_dir_wbw';
  static const wbwLanguage = 'wbw_lang';

  // Audio & AI
  static const reciter = 'reciter';
  static const playbackSpeed = 'playback_speed';
  static const aiPreference = 'ai_pref'; // 0: Balanced, 1: Max Accuracy

  // Last Viewed (Bookmarks)
  static const lastSurah = 'last_s';
  static const lastAyah = 'last_a';
  static const lastSurahName = 'last_s_name';
  static const lastTotalAyah = 'last_total_ayah';
}

// -----------------------------------------------------------------------------
// 1. APP CONFIGURATION STATE
// -----------------------------------------------------------------------------

@immutable
class AppConfig {
  // Visuals
  final bool isDarkTheme;
  final String appLanguage;

  // Reading
  final double arabicFontSize;
  final double translationFontSize;
  final double tafsirFontSize; // NEW
  final double wbwFontSize;
  final String arabicFontStyle; // 'uthmani', 'naskh'
  final bool showArabicText;
  final bool isTajweedEnabled;
  final bool isTranslationOnly;

  // Translation & WBW
  final List<String> activeTranslationIdentifiers;
  final String selectedTranslationLanguage; // 'en', 'ur', etc. (Derived logic)
  final bool isDirectWBWEnabled;
  final String wbwLanguage;
  final String? selectedWordByWordEdition;

  // Audio & AI
  final String? selectedReciterIdentifier;
  final double playbackSpeed;
  final int aiPreference; // 0: Balanced, 1: Max Accuracy

  const AppConfig({
    required this.isDarkTheme,
    required this.appLanguage,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.tafsirFontSize, // NEW
    required this.wbwFontSize,
    required this.arabicFontStyle,
    required this.showArabicText,
    required this.isTajweedEnabled,
    required this.isTranslationOnly,
    required this.activeTranslationIdentifiers,
    required this.selectedTranslationLanguage,
    required this.isDirectWBWEnabled,
    required this.wbwLanguage,
    this.selectedWordByWordEdition,
    this.selectedReciterIdentifier,
    required this.playbackSpeed,
    required this.aiPreference,
  });

  AppConfig copyWith({
    bool? isDarkTheme,
    String? appLanguage,
    double? arabicFontSize,
    double? translationFontSize,
    double? tafsirFontSize, // NEW
    double? wbwFontSize,
    String? arabicFontStyle,
    bool? showArabicText,
    bool? isTajweedEnabled,
    bool? isTranslationOnly,
    List<String>? activeTranslationIdentifiers,
    String? selectedTranslationLanguage,
    bool? isDirectWBWEnabled,
    String? wbwLanguage,
    String? selectedWordByWordEdition,
    bool clearWordByWord = false,
    String? selectedReciterIdentifier,
    bool clearReciter = false,
    double? playbackSpeed,
    int? aiPreference,
  }) {
    return AppConfig(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      appLanguage: appLanguage ?? this.appLanguage,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      tafsirFontSize: tafsirFontSize ?? this.tafsirFontSize,
      wbwFontSize: wbwFontSize ?? this.wbwFontSize,
      arabicFontStyle: arabicFontStyle ?? this.arabicFontStyle,
      showArabicText: showArabicText ?? this.showArabicText,
      isTajweedEnabled: isTajweedEnabled ?? this.isTajweedEnabled,
      isTranslationOnly: isTranslationOnly ?? this.isTranslationOnly,
      activeTranslationIdentifiers:
          activeTranslationIdentifiers ?? this.activeTranslationIdentifiers,
      selectedTranslationLanguage:
          selectedTranslationLanguage ?? this.selectedTranslationLanguage,
      isDirectWBWEnabled: isDirectWBWEnabled ?? this.isDirectWBWEnabled,
      wbwLanguage: wbwLanguage ?? this.wbwLanguage,
      selectedWordByWordEdition: clearWordByWord
          ? null
          : selectedWordByWordEdition ?? this.selectedWordByWordEdition,
      selectedReciterIdentifier: clearReciter
          ? null
          : selectedReciterIdentifier ?? this.selectedReciterIdentifier,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      aiPreference: aiPreference ?? this.aiPreference,
    );
  }
}

// -----------------------------------------------------------------------------
// 2. VIEW MODEL
// -----------------------------------------------------------------------------

class AppConfigViewModel extends Notifier<AppConfig> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppConfig build() {
    final p = _prefs;
    // Default translation logic
    final activeIds = p.getStringList(_PrefsKeys.activeTranslations) ??
        ['131']; // Default to clear Quran (or similar)
    final lang = activeIds.contains('131') ? 'ur' : 'en';

    // Audio & AI
    String reciter = p.getString(_PrefsKeys.reciter) ?? '7';

    // MIGRATION: Fix legacy "ar.alafasy" (AlQuran Cloud) back to "7" (QDC V4)
    if (reciter == 'ar.alafasy') {
      reciter = '7';
      p.setString(_PrefsKeys.reciter, reciter);
    }

    return AppConfig(
      // Visuals
      isDarkTheme: p.getBool(_PrefsKeys.isDarkTheme) ?? false,
      appLanguage: p.getString(_PrefsKeys.appLanguage) ?? 'English',

      // Font Sizes
      arabicFontSize: p.getDouble(_PrefsKeys.fontSizeArabic) ?? 20.0,
      translationFontSize: p.getDouble(_PrefsKeys.fontSizeTranslation) ?? 18.0,
      tafsirFontSize:
          p.getDouble(_PrefsKeys.fontSizeTafsir) ?? 18.0, // Default 18
      wbwFontSize: p.getDouble(_PrefsKeys.fontSizeWBW) ?? 18.0,
      arabicFontStyle: _normalizeFontStyle(
          p.getString(_PrefsKeys.arabicFontStyle) ?? 'amiri'),

      // Reading Toggles
      showArabicText: p.getBool(_PrefsKeys.showArabic) ?? true,
      isTajweedEnabled: p.getBool(_PrefsKeys.tajweed) ?? true,
      isTranslationOnly: p.getBool(_PrefsKeys.isTranslationOnly) ?? false,

      // Translations
      activeTranslationIdentifiers: activeIds,
      selectedTranslationLanguage: lang,

      // Word by Word
      isDirectWBWEnabled: p.getBool(_PrefsKeys.isDirectWBW) ?? false,
      wbwLanguage: p.getString(_PrefsKeys.wbwLanguage) ?? 'English',
      selectedWordByWordEdition: p.getString(_PrefsKeys.wordByWord),

      // Audio & AI
      selectedReciterIdentifier: reciter,
      playbackSpeed: p.getDouble(_PrefsKeys.playbackSpeed) ?? 1.0,
      aiPreference: p.getInt(_PrefsKeys.aiPreference) ?? 0,
    );
  }

  // --- Visuals ---

  void toggleTheme(bool d) {
    _prefs.setBool(_PrefsKeys.isDarkTheme, d);
    state = state.copyWith(isDarkTheme: d);
  }

  void setAppLanguage(String lang) {
    _prefs.setString(_PrefsKeys.appLanguage, lang);
    state = state.copyWith(appLanguage: lang);
  }

  // --- Reading (Fonts & Toggles) ---

  void setArabicFontSize(double s) {
    _prefs.setDouble(_PrefsKeys.fontSizeArabic, s);
    state = state.copyWith(arabicFontSize: s);
  }

  void setTranslationFontSize(double s) {
    _prefs.setDouble(_PrefsKeys.fontSizeTranslation, s);
    state = state.copyWith(translationFontSize: s);
  }

  void setTafsirFontSize(double s) {
    _prefs.setDouble(_PrefsKeys.fontSizeTafsir, s);
    state = state.copyWith(tafsirFontSize: s);
  }

  void setWBWFontSize(double s) {
    _prefs.setDouble(_PrefsKeys.fontSizeWBW, s);
    state = state.copyWith(wbwFontSize: s);
  }

  void setArabicFontStyle(String style) {
    // Expected values: 'amiri', 'indopak'
    // Normalization ensures legacy values ('pdms', 'naskh', 'uthmani') map to new ones.
    final normalized = _normalizeFontStyle(style);
    _prefs.setString(_PrefsKeys.arabicFontStyle, normalized);
    state = state.copyWith(arabicFontStyle: normalized);
  }

  String _normalizeFontStyle(String style) {
    switch (style.toLowerCase()) {
      case 'pdms':
      case 'naskh':
      case 'indopak':
      case 'quranfont':
        return 'quranfont';
      case 'uthmani':
      case 'amiri':
      default:
        return 'amiri';
    }
  }

  void toggleTajweed(bool t) {
    _prefs.setBool(_PrefsKeys.tajweed, t);
    state = state.copyWith(isTajweedEnabled: t);
  }

  void setTranslationOnly(bool v) {
    _prefs.setBool(_PrefsKeys.isTranslationOnly, v);
    state = state.copyWith(isTranslationOnly: v);
  }

  void setShowArabic(bool v) {
    _prefs.setBool(_PrefsKeys.showArabic, v);
    state = state.copyWith(showArabicText: v);
  }

  // --- Translations Management ---

  void addActiveTranslation(String id) {
    final currentList = state.activeTranslationIdentifiers;
    if (!currentList.contains(id)) {
      final newList = [...currentList, id];
      _prefs.setStringList(_PrefsKeys.activeTranslations, newList);

      // Simple logic to guess primary language based on ID existence
      // You can expand this logic if needed
      final newLang = newList.contains('131') ? 'ur' : 'en';

      state = state.copyWith(
        activeTranslationIdentifiers: newList,
        selectedTranslationLanguage: newLang,
      );
    }
  }

  void removeActiveTranslation(String id) {
    final newList =
        state.activeTranslationIdentifiers.where((x) => x != id).toList();
    _prefs.setStringList(_PrefsKeys.activeTranslations, newList);

    final newLang = newList.contains('131') ? 'ur' : 'en';

    state = state.copyWith(
      activeTranslationIdentifiers: newList,
      selectedTranslationLanguage: newLang,
    );
  }

  // --- Word By Word ---

  void setDirectWBW(bool v) {
    _prefs.setBool(_PrefsKeys.isDirectWBW, v);
    state = state.copyWith(isDirectWBWEnabled: v);
  }

  void setWbwLanguage(String lang) {
    _prefs.setString(_PrefsKeys.wbwLanguage, lang);
    state = state.copyWith(wbwLanguage: lang);
  }

  void setSelectedWordByWordEdition(String? id) {
    if (id == null) {
      _prefs.remove(_PrefsKeys.wordByWord);
      state = state.copyWith(clearWordByWord: true);
    } else {
      _prefs.setString(_PrefsKeys.wordByWord, id);
      state = state.copyWith(selectedWordByWordEdition: id);
    }
  }

  // --- Audio ---

  void setSelectedReciter(String? id) {
    if (id == null) {
      _prefs.remove(_PrefsKeys.reciter);
      state = state.copyWith(clearReciter: true);
    } else {
      _prefs.setString(_PrefsKeys.reciter, id);
      state = state.copyWith(selectedReciterIdentifier: id);
    }
  }

  void setPlaybackSpeed(double speed) {
    _prefs.setDouble(_PrefsKeys.playbackSpeed, speed);
    state = state.copyWith(playbackSpeed: speed);
  }

  // --- AI ---

  void setAiPreference(int pref) {
    _prefs.setInt(_PrefsKeys.aiPreference, pref);
    state = state.copyWith(aiPreference: pref);
  }

  // --- Cache Management ---

  // --- Data Management ---

  Future<void> downloadEdition(
      String id, ValueSetter<String>? onProgress) async {
    try {
      final repo = ref.read(quranRepositoryProvider);
      await repo.downloadAndStoreTranslation(id, (msg) {
        onProgress?.call(msg);
      });
      // Refresh the list of downloaded items
      ref.invalidate(downloadedEditionIdsProvider);
    } catch (e) {
      debugPrint("Download failed: $e");
      rethrow;
    }
  }

  Future<void> clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
      // Force refresh the cache size provider by invalidating it
      ref.invalidate(cacheSizeProvider);
    } catch (e) {
      debugPrint("Error clearing cache: $e");
    }
  }
}

final appConfigViewModelProvider =
    NotifierProvider<AppConfigViewModel, AppConfig>(AppConfigViewModel.new);

// -----------------------------------------------------------------------------
// 3. CACHE SIZE PROVIDER
// -----------------------------------------------------------------------------

final cacheSizeProvider = FutureProvider<String>((ref) async {
  try {
    final cacheDir = await getTemporaryDirectory();
    if (!cacheDir.existsSync()) return "0 MB";

    int totalSize = 0;
    try {
      cacheDir
          .listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity entity) {
        if (entity is File) {
          totalSize += entity.lengthSync();
        }
      });
    } catch (e) {
      return "0 MB";
    }

    double sizeInMb = totalSize / (1024 * 1024);
    if (sizeInMb < 1 && totalSize > 0) {
      return "${(totalSize / 1024).toStringAsFixed(0)} KB";
    }
    return "${sizeInMb.toStringAsFixed(1)} MB";
  } catch (e) {
    return "Unknown";
  }
});

// -----------------------------------------------------------------------------
// 4. LAST VIEWED (Bookmarks Logic)
// -----------------------------------------------------------------------------

@immutable
class LastViewedState {
  final int? surah;
  final int? ayah;
  final String? surahName;
  final int? totalAyah;

  const LastViewedState(
      {this.surah, this.ayah, this.surahName, this.totalAyah});
}

class LastViewedNotifier extends Notifier<LastViewedState> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  LastViewedState build() {
    final p = _prefs;
    return LastViewedState(
      surah: p.getInt(_PrefsKeys.lastSurah),
      ayah: p.getInt(_PrefsKeys.lastAyah),
      surahName: p.getString(_PrefsKeys.lastSurahName),
      totalAyah: p.getInt(_PrefsKeys.lastTotalAyah),
    );
  }

  void savePosition(int surah, int ayah, String surahName, int totalAyah) {
    if (state.surah == surah && state.ayah == ayah) return;

    _prefs.setInt(_PrefsKeys.lastSurah, surah);
    _prefs.setInt(_PrefsKeys.lastAyah, ayah);
    _prefs.setString(_PrefsKeys.lastSurahName, surahName);
    _prefs.setInt(_PrefsKeys.lastTotalAyah, totalAyah);

    state = LastViewedState(
        surah: surah, ayah: ayah, surahName: surahName, totalAyah: totalAyah);
  }
}

final lastViewedProvider =
    NotifierProvider<LastViewedNotifier, LastViewedState>(
        LastViewedNotifier.new);

// -----------------------------------------------------------------------------
// 5. DOWNLOADED EDITIONS HELPER
// -----------------------------------------------------------------------------

final downloadedEditionIdsProvider = FutureProvider<Set<String>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return await repo.getDownloadedEditionIds();
});

// -----------------------------------------------------------------------------
// 6. SORTED EDITIONS HELPER (Sorting Logic)
// -----------------------------------------------------------------------------

final sortedEditionsProvider =
    FutureProvider.family<List<Edition>, String>((ref, type) async {
  final allEditions = await ref.watch(allEditionsProvider.future);
  final downloadedIds = await ref.watch(downloadedEditionIdsProvider.future);

  final filtered = allEditions.where((e) => e.type == type).toList();

  // Sort: Downloaded first, then alphabetical by name
  filtered.sort((a, b) {
    final aDownloaded = downloadedIds.contains(a.identifier);
    final bDownloaded = downloadedIds.contains(b.identifier);
    if (aDownloaded && !bDownloaded) return -1;
    if (!aDownloaded && bDownloaded) return 1;
    return a.name.compareTo(b.name);
  });

  return filtered;
});
