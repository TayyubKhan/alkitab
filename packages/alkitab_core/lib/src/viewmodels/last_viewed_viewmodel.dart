import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Logic to persist last viewed position
// We use SharedPreferences for simplicity in Core.

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

class LastViewedState {
  final int? surahNumber;
  final int? ayahNumber;
  final String? surahName;
  final int? totalAyahs;

  const LastViewedState({
    this.surahNumber,
    this.ayahNumber,
    this.surahName,
    this.totalAyahs,
  });
}

class LastViewedNotifier extends Notifier<LastViewedState> {
  late SharedPreferences _prefs;
  static const _keySurah = 'last_surah';
  static const _keyAyah = 'last_ayah';
  static const _keyName = 'last_surah_name';
  static const _keyTotal = 'last_total_ayahs';

  @override
  LastViewedState build() {
    if (kIsWeb) return const LastViewedState(); // Disabled on Web
    _prefs = ref.watch(sharedPreferencesProvider);
    return _load();
  }

  LastViewedState _load() {
    if (kIsWeb) return const LastViewedState();
    
    final s = _prefs.getInt(_keySurah);
    final a = _prefs.getInt(_keyAyah);
    final n = _prefs.getString(_keyName);
    final t = _prefs.getInt(_keyTotal);

    if (s != null && a != null && n != null && t != null) {
      return LastViewedState(
        surahNumber: s,
        ayahNumber: a,
        surahName: n,
        totalAyahs: t,
      );
    }
    return const LastViewedState();
  }

  Future<void> savePosition(int surah, int ayah, String name, int total) async {
    if (kIsWeb) return; // Disable on web

    await _prefs.setInt(_keySurah, surah);
    await _prefs.setInt(_keyAyah, ayah);
    await _prefs.setString(_keyName, name);
    await _prefs.setInt(_keyTotal, total);
    
    state = LastViewedState(
      surahNumber: surah,
      ayahNumber: ayah,
      surahName: name,
      totalAyahs: total,
    );
  }
}

final lastViewedNotifierProvider =
    NotifierProvider<LastViewedNotifier, LastViewedState>(
        LastViewedNotifier.new);
