import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alkitab_core/alkitab_core.dart';
import '../data/models/quran_models.dart';
import '../data/repositories/quran_repository.dart' as local_repo;
import '../data/local/app_database.dart'; // For databaseProvider
import 'package:alkitab_core/alkitab_core.dart' show SetupOptions;
import 'settings_viewmodel.dart';

// -----------------------------------------------------------------------------
// 1. SETUP OPTIONS MODEL
// -----------------------------------------------------------------------------
// SetupOptions moved to alkitab_core

// -----------------------------------------------------------------------------
// 2. SETUP OPTIONS NOTIFIER
// -----------------------------------------------------------------------------
class SetupOptionsNotifier extends Notifier<SetupOptions> {
  @override
  SetupOptions build() => const SetupOptions(fullEditions: {}, wbwEditions: {});

  void toggleFullEdition(String i) {
    final s = {...state.fullEditions};
    s.contains(i) ? s.remove(i) : s.add(i);
    state = state.copyWith(fullEditions: s);
  }

  void toggleWbWEdition(String i) {
    final s = {...state.wbwEditions};
    s.contains(i) ? s.remove(i) : s.add(i);
    state = state.copyWith(wbwEditions: s);
  }

  void setReciter(String? i) {
    state = state.copyWith(offlineReciterId: i, clearReciter: i == null);
  }

  void setShouldDownloadReciter(bool v) {
    state = state.copyWith(shouldDownloadReciter: v);
  }
}

final setupOptionsProvider =
    NotifierProvider<SetupOptionsNotifier, SetupOptions>(
        SetupOptionsNotifier.new);

// -----------------------------------------------------------------------------
// 3. DOWNLOAD STATE MODEL
// -----------------------------------------------------------------------------
@immutable
class DataDownloadState {
  final bool isLoading;
  final String progressMessage;
  final String? errorMessage;

  // Advanced Math Stats
  final double progress; // 0.0 to 1.0
  final double downloadedMB;
  final double totalMB;
  final double speedMBps;
  final Duration? remainingTime;

  const DataDownloadState({
    this.isLoading = false,
    this.progressMessage = '',
    this.errorMessage,
    this.progress = 0.0,
    this.downloadedMB = 0.0,
    this.totalMB = 0.0,
    this.speedMBps = 0.0,
    this.remainingTime,
  });

  DataDownloadState copyWith({
    bool? isLoading,
    String? progressMessage,
    String? errorMessage,
    double? progress,
    double? downloadedMB,
    double? totalMB,
    double? speedMBps,
    Duration? remainingTime,
  }) {
    return DataDownloadState(
      isLoading: isLoading ?? this.isLoading,
      progressMessage: progressMessage ?? this.progressMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
      downloadedMB: downloadedMB ?? this.downloadedMB,
      totalMB: totalMB ?? this.totalMB,
      speedMBps: speedMBps ?? this.speedMBps,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}

// -----------------------------------------------------------------------------
// 4. DOWNLOAD VIEW MODEL
// -----------------------------------------------------------------------------
class DataDownloadViewModel extends Notifier<DataDownloadState> {
  DateTime? _startTime;

  @override
  DataDownloadState build() => const DataDownloadState();

  // Track progress of individual components for accurate aggregation
  final Map<String, double> _componentProgress = {};

  // Estimated sizes for components
  double _sizeBase = 50.0;
  double _sizeAudio = 0.0;
  double _sizeTrans = 0.0;
  double _sizeWbw = 0.0;

  Future<bool> startDownload() async {
    state = const DataDownloadState(isLoading: true, progress: 0.0);
    // Use local provider because we need specific download methods
    final repo = ref.read(local_repo.mobileQuranRepositoryProvider);
    final setup = ref.read(setupOptionsProvider);
    _calculateComponentSizes(setup);
    final estimatedTotal = _sizeBase + _sizeAudio + _sizeTrans + _sizeWbw;

    _startTime = DateTime.now();
    _componentProgress.clear();
    _lastDownloadedMB = 0.0;
    _lastUpdateTime = null;

    state = DataDownloadState(
      isLoading: true,
      progressMessage: 'Initializing...',
      progress: 0.0,
      totalMB: estimatedTotal,
    );

    try {
      final repo = ref.read(quranRepositoryProvider);

      AppLogger.i(
          "DownloadVM: Starting batch download sequence (Audio: ${setup.shouldDownloadReciter}).");

      final downloadOptions = setup.shouldDownloadReciter
          ? setup
          : setup.copyWith(clearReciter: true);

      // Using the callback to update detailed stats
      await repo.downloadInitialData(downloadOptions, (msg) {
        _updateProgress(msg);
      });

      // 2. Update Global App Settings (Post-Success)
      _updateAppConfig(setup);

      state = const DataDownloadState(
        isLoading: false,
        progressMessage: 'Download Complete',
        progress: 1.0,
        downloadedMB: 0.0,
        totalMB: 0.0,
        speedMBps: 0.0,
        errorMessage: null,
      );
      return true;
    } catch (e, st) {
      AppLogger.e("DownloadVM: Download failed", e, st);
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void _calculateComponentSizes(SetupOptions options) {
    _sizeBase = 50.0; // Base text data (Surahs + Ayahs) ~ 50MB

    // Add translations (~2MB each)
    _sizeTrans = options.fullEditions.length * 2.0;

    // WBW is heavier (~5MB each)
    _sizeWbw = options.wbwEditions.length * 5.0;

    // Add Audio (~600MB for full Quran 64kbps)
    _sizeAudio = 0.0;
    if (options.shouldDownloadReciter && options.offlineReciterId != null) {
      _sizeAudio = 600.0;
    }
  }

  // State for Instant Speed Calculation
  double _lastDownloadedMB = 0.0;
  DateTime? _lastUpdateTime;

  void _updateProgress(String msg) {
    // 1. Identify Component and update its progress
    if (msg.contains('Downloading Audio')) {
      _updateComponent('audio', msg);
    } else if (msg.contains('Downloading WbW')) {
      _updateComponent('wbw', msg);
    } else if (msg.contains('Downloading translations') ||
        msg.contains('Downloading tafsirs')) {
      _updateComponent('trans', msg);
    } else if (msg.contains('structure') ||
        msg.contains('Arabic') ||
        msg.contains('Meta')) {
      if (msg.contains('structure')) _componentProgress['base'] = 0.1;
      if (msg.contains('Arabic')) _componentProgress['base'] = 0.5;
      if (msg.contains('Meta')) _componentProgress['base'] = 0.9;
    }

    // 2. Aggregate Downloaded Size
    double downloaded = 0.0;
    downloaded += (_componentProgress['base'] ?? 0.0) * _sizeBase;
    downloaded += (_componentProgress['audio'] ?? 0.0) * _sizeAudio;
    downloaded += (_componentProgress['wbw'] ?? 0.0) * _sizeWbw;
    downloaded += (_componentProgress['trans'] ?? 0.0) * _sizeTrans;

    if (downloaded > state.totalMB) downloaded = state.totalMB;

    // 3. Calculate Global Progress
    double currentProgress =
        state.totalMB > 0 ? downloaded / state.totalMB : 0.0;

    // 4. Calculate Speed (Moving Average for Stability)
    final now = DateTime.now();
    double speed = state.speedMBps;

    if (_lastUpdateTime != null) {
      final deltaSeconds =
          now.difference(_lastUpdateTime!).inMilliseconds / 1000.0;
      if (deltaSeconds > 0.5) {
        // Update speed every 500ms min to avoid jitter
        final deltaMB = downloaded - _lastDownloadedMB;
        // Instant speed
        final instantSpeed = (deltaMB > 0) ? deltaMB / deltaSeconds : 0.0;

        // Weighted Average: 70% new, 30% old (Responsive yet Smooth)
        if (instantSpeed > 0) {
          speed = (instantSpeed * 0.7) + (speed * 0.3);
        }

        _lastDownloadedMB = downloaded;
        _lastUpdateTime = now;
      }
    } else {
      _lastDownloadedMB = downloaded;
      _lastUpdateTime = now;
    }

    // 5. Calculate ETA
    Duration remaining = Duration.zero;
    if (speed > 0.05) {
      // Threshold 50KB/s
      final remainingMB = state.totalMB - downloaded;
      final remainingSecs = remainingMB / speed;
      // Cap max ETA
      if (remainingSecs < 3600 * 24) {
        remaining = Duration(seconds: remainingSecs.ceil());
      }
    }

    state = state.copyWith(
      progressMessage: msg,
      progress: currentProgress,
      downloadedMB: downloaded,
      speedMBps: speed, // Now represents Instant/Moving Average
      remainingTime: remaining,
    );
  }

  void _updateComponent(String key, String msg) {
    // Regex for integer or decimal percentage (e.g. 12%, 12.5%)
    final regex = RegExp(r'(\d+(?:\.\d+)?)%');
    final match = regex.firstMatch(msg);
    if (match != null) {
      final val = double.tryParse(match.group(1)!) ?? 0.0;
      _componentProgress[key] = val / 100.0;
    }
  }

  void _updateAppConfig(SetupOptions options) {
    final configNotifier = ref.read(appConfigViewModelProvider.notifier);

    for (var id in options.fullEditions) {
      configNotifier.addActiveTranslation(id);
    }

    if (options.wbwEditions.isNotEmpty) {
      configNotifier.setSelectedWordByWordEdition(options.wbwEditions.first);
    }

    if (options.offlineReciterId != null) {
      configNotifier.setSelectedReciter(options.offlineReciterId!);
    }
  }
}

final dataDownloadViewModelProvider =
    NotifierProvider<DataDownloadViewModel, DataDownloadState>(
        DataDownloadViewModel.new);

// -----------------------------------------------------------------------------
// 5. STATUS CHECK PROVIDER
// -----------------------------------------------------------------------------
final isAnythingDownloadedProvider = FutureProvider<bool>((ref) async {
  // Use local repo provider
  final repo = ref.read(local_repo.mobileQuranRepositoryProvider);

  // 1. Check Base Data
  final hasBase = await repo.isBaseDataDownloaded();
  if (!hasBase) return false;

  // 2. Check for Content
  final db = ref.watch(databaseProvider);

  // FIX: Use cascade operator (..) because .limit() returns void
  final hasTranslations = await (db.select(db.translations)..limit(1))
      .get()
      .then((v) => v.isNotEmpty);

  final hasWbW = await (db.select(db.wordTranslations)..limit(1))
      .get()
      .then((v) => v.isNotEmpty);

  // Return true if base data exists. (Content is optional but good to have checked)
  return true;
});
