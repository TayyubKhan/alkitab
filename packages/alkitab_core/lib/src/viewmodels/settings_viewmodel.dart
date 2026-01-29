import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alkitab_core/alkitab_core.dart';
import 'package:alkitab_models/alkitab_models.dart';

// -----------------------------------------------------------------------------
// 1. STATE MODEL
// -----------------------------------------------------------------------------
@immutable
class AppConfigState {
  final bool isDarkTheme;
  final double arabicFontSize;
  final double translationFontSize;
  final double playbackSpeed;
  final String selectedReciterIdentifier;
  final String selectedWordByWordEdition;
  final Set<String> activeTranslationIdentifiers;
  
  final String appLanguage;
  final bool showArabicText;
  final String arabicFontStyle;
  final double tafsirFontSize;
  final bool isDirectWBWEnabled;
  final String wbwLanguage;
  final String aiPreference;
  final bool enableShakeToReport;

  const AppConfigState({
    this.isDarkTheme = true,
    this.arabicFontSize = 20.0,
    this.translationFontSize = 16.0,
    this.playbackSpeed = 1.0,
    this.selectedReciterIdentifier = '7', // Mishary
    this.selectedWordByWordEdition = 'en_wbw',
    this.activeTranslationIdentifiers = const {'131'}, // Saheeh Intl
    this.appLanguage = 'English',
    this.showArabicText = true,
    this.arabicFontStyle = 'Uthmani',
    this.tafsirFontSize = 16.0,
    this.isDirectWBWEnabled = false,
    this.wbwLanguage = 'en',
    this.aiPreference = 'disabled',
    this.enableShakeToReport = true,
  });

  bool get isTranslationOnly => !showArabicText;
  String get selectedTranslationLanguage => appLanguage;

  AppConfigState copyWith({
    bool? isDarkTheme,
    double? arabicFontSize,
    double? translationFontSize,
    double? playbackSpeed,
    String? selectedReciterIdentifier,
    String? selectedWordByWordEdition,
    Set<String>? activeTranslationIdentifiers,
    String? appLanguage,
    bool? showArabicText,
    String? arabicFontStyle,
    double? tafsirFontSize,
    bool? isDirectWBWEnabled,
    String? wbwLanguage,
    String? aiPreference,
    Set<String>? fullEditions, // Compatibility
    bool? enableShakeToReport,
  }) {
    return AppConfigState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      selectedReciterIdentifier:
          selectedReciterIdentifier ?? this.selectedReciterIdentifier,
      selectedWordByWordEdition:
          selectedWordByWordEdition ?? this.selectedWordByWordEdition,
      activeTranslationIdentifiers:
          activeTranslationIdentifiers ?? this.activeTranslationIdentifiers,
      appLanguage: appLanguage ?? this.appLanguage,
      showArabicText: showArabicText ?? this.showArabicText,
      arabicFontStyle: arabicFontStyle ?? this.arabicFontStyle,
      tafsirFontSize: tafsirFontSize ?? this.tafsirFontSize,
      isDirectWBWEnabled: isDirectWBWEnabled ?? this.isDirectWBWEnabled,
      wbwLanguage: wbwLanguage ?? this.wbwLanguage,
      aiPreference: aiPreference ?? this.aiPreference,
      enableShakeToReport: enableShakeToReport ?? this.enableShakeToReport,
    );
  }
}

// -----------------------------------------------------------------------------
// 2. VIEW MODEL
// -----------------------------------------------------------------------------
class AppConfigViewModel extends Notifier<AppConfigState> {
  late SharedPreferences _prefs;

  static const _kThemeKey = 'theme_mode';
  static const _kArabicSizeKey = 'font_size_arabic';
  static const _kTransSizeKey = 'font_size_trans';
  static const _kSpeedKey = 'playback_speed';
  static const _kReciterKey = 'reciter_id';
  static const _kWbwKey = 'wbw_id';
  static const _kTransKey = 'active_translations';
  
  static const _kAppLangKey = 'app_language';
  static const _kShowArabicKey = 'show_arabic';
  static const _kArabicFontKey = 'arabic_font_style';
  static const _kTafsirSizeKey = 'tafsir_font_size';
  static const _kDirectWbwKey = 'direct_wbw_enabled';
  static const _kWbwLangKey = 'wbw_language';
  static const _kAiKey = 'ai_preference';
  static const _kShakeRepoKey = 'shake_to_report_enabled';


  @override
  AppConfigState build() {
    _loadSettings();
    return const AppConfigState();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    final isDark = _prefs.getBool(_kThemeKey) ?? true;
    final arSize = _prefs.getDouble(_kArabicSizeKey) ?? 20.0;
    final trSize = _prefs.getDouble(_kTransSizeKey) ?? 16.0;
    final speed = _prefs.getDouble(_kSpeedKey) ?? 1.0;
    final reciter = _prefs.getString(_kReciterKey) ?? '7';
    final wbw = _prefs.getString(_kWbwKey) ?? 'en_wbw';
    final transList = _prefs.getStringList(_kTransKey) ?? ['131'];
    
    final appLang = _prefs.getString(_kAppLangKey) ?? 'English';
    final showAr = _prefs.getBool(_kShowArabicKey) ?? true;
    final arFont = _prefs.getString(_kArabicFontKey) ?? 'Uthmani';
    final tafsirSize = _prefs.getDouble(_kTafsirSizeKey) ?? 16.0;
    final directWbw = _prefs.getBool(_kDirectWbwKey) ?? false;
    final wbwLang = _prefs.getString(_kWbwLangKey) ?? 'en';
    final ai = _prefs.getString(_kAiKey) ?? 'disabled';
    final shake = _prefs.getBool(_kShakeRepoKey) ?? true;

    state = AppConfigState(
      isDarkTheme: isDark,
      arabicFontSize: arSize,
      translationFontSize: trSize,
      playbackSpeed: speed,
      selectedReciterIdentifier: reciter,
      selectedWordByWordEdition: wbw,
      activeTranslationIdentifiers: transList.toSet(),
      appLanguage: appLang,
      showArabicText: showAr,
      arabicFontStyle: arFont,
      tafsirFontSize: tafsirSize,
      isDirectWBWEnabled: directWbw,
      wbwLanguage: wbwLang,
      aiPreference: ai,
      enableShakeToReport: shake,
    );
  }

  void toggleTheme(bool isDark) {
    state = state.copyWith(isDarkTheme: isDark);
    _prefs.setBool(_kThemeKey, isDark);
  }

  void setArabicFontSize(double size) {
    state = state.copyWith(arabicFontSize: size);
    _prefs.setDouble(_kArabicSizeKey, size);
  }

  void setTranslationFontSize(double size) {
    state = state.copyWith(translationFontSize: size);
    _prefs.setDouble(_kTransSizeKey, size);
  }

  void setPlaybackSpeed(double speed) {
    state = state.copyWith(playbackSpeed: speed);
    _prefs.setDouble(_kSpeedKey, speed);
  }

  void setSelectedReciter(String id) {
    state = state.copyWith(selectedReciterIdentifier: id);
    _prefs.setString(_kReciterKey, id);
  }

  void setSelectedWordByWordEdition(String id) {
    state = state.copyWith(selectedWordByWordEdition: id);
    _prefs.setString(_kWbwKey, id);
  }

  void toggleActiveTranslation(String id) {
    final newSet = {...state.activeTranslationIdentifiers};
    if (newSet.contains(id)) {
      if (newSet.length > 1) newSet.remove(id);
    } else {
      newSet.add(id);
    }
    state = state.copyWith(activeTranslationIdentifiers: newSet);
    _prefs.setStringList(_kTransKey, newSet.toList());
  }

  void addActiveTranslation(String id) {
    final newSet = {...state.activeTranslationIdentifiers, id};
    state = state.copyWith(activeTranslationIdentifiers: newSet);
    _prefs.setStringList(_kTransKey, newSet.toList());
  }
  
  // New Methods
  void setAppLanguage(String lang) {
      state = state.copyWith(appLanguage: lang);
      _prefs.setString(_kAppLangKey, lang);
  }
  
  void setShowArabic(bool show) {
      state = state.copyWith(showArabicText: show);
      _prefs.setBool(_kShowArabicKey, show);
  }
  
  void setArabicFontStyle(String style) {
      state = state.copyWith(arabicFontStyle: style);
      _prefs.setString(_kArabicFontKey, style);
  }
  
  void setTafsirFontSize(double size) {
      state = state.copyWith(tafsirFontSize: size);
      _prefs.setDouble(_kTafsirSizeKey, size);
  }
  
  void setDirectWBW(bool enabled) {
      state = state.copyWith(isDirectWBWEnabled: enabled);
      _prefs.setBool(_kDirectWbwKey, enabled);
  }
  
  void setWbwLanguage(String lang) {
      state = state.copyWith(wbwLanguage: lang);
      _prefs.setString(_kWbwLangKey, lang);
  }
  
  void setAiPreference(String pref) {
      state = state.copyWith(aiPreference: pref);
      _prefs.setString(_kAiKey, pref);
  }

  void setShakeToReport(bool enabled) {
    state = state.copyWith(enableShakeToReport: enabled);
    _prefs.setBool(_kShakeRepoKey, enabled);
  }
  
  Future<void> clearCache() async {
      await _prefs.clear();
      _loadSettings();
  }
}

final appConfigViewModelProvider =
    NotifierProvider<AppConfigViewModel, AppConfigState>(
        AppConfigViewModel.new);

// --- Added Providers ---

final cacheSizeProvider = FutureProvider<String>((ref) async {
  return "Calculating..."; 
});

final downloadedEditionIdsProvider = FutureProvider<Set<String>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  final editions = await repo.getAllTranslationEditions();
  final Set<String> downloaded = {};
  
  for (var e in editions) {
    if (await repo.isEditionDownloaded(e.identifier)) {
      downloaded.add(e.identifier);
    }
  }
  return downloaded;
});

// Track individual progress in a reactive way
class EditionDownloadProgressNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => {};

  void updateProgress(String id, double p) {
    state = {...state, id: p};
  }

  void removeProgress(String id) {
    final newState = {...state};
    newState.remove(id);
    state = newState;
  }
}

final editionDownloadProgressProvider =
    NotifierProvider<EditionDownloadProgressNotifier, Map<String, double>>(
        EditionDownloadProgressNotifier.new);

final sortedEditionsProvider = FutureProvider.family<List<Edition>, String>((ref, type) async {
  final repo = ref.watch(quranRepositoryProvider);
  try {
    final editions = await repo.getAllTranslationEditions();
    return editions.where((e) => e.type == type).toList();
  } catch (e) {
    return [];
  }
});
