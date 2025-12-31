import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../core/utils/app_logger.dart';
import '../data/models/quran_models.dart';
import 'settings_viewmodel.dart';

// -----------------------------------------------------------------------------
// 1. AUDIO PLAYER INSTANCE
// -----------------------------------------------------------------------------

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final p = AudioPlayer();
  // Ensure resources are released when the app is closed or provider disposed
  ref.onDispose(p.dispose);
  return p;
});

// -----------------------------------------------------------------------------
// 2. STATE MODEL
// -----------------------------------------------------------------------------

@immutable
class AudioControlState {
  final bool isPlaying;
  final bool isBuffering;
  final bool isSurahMode;
  final int? currentSurah;
  final int? currentAyah;
  final Duration? position;
  final Duration? duration;

  const AudioControlState({
    this.isPlaying = false,
    this.isBuffering = false,
    this.isSurahMode = false,
    this.currentSurah,
    this.currentAyah,
    this.position,
    this.duration,
  });

  AudioControlState copyWith({
    bool? isPlaying,
    bool? isBuffering,
    bool? isSurahMode,
    int? currentSurah,
    int? currentAyah,
    Duration? position,
    Duration? duration,
  }) {
    return AudioControlState(
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      isSurahMode: isSurahMode ?? this.isSurahMode,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyah: currentAyah ?? this.currentAyah,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  /// Initial empty state
  factory AudioControlState.initial() => const AudioControlState();
}

// -----------------------------------------------------------------------------
// 3. AUDIO CONTROLLER NOTIFIER
// -----------------------------------------------------------------------------

class AudioControlNotifier extends Notifier<AudioControlState> {
  late final AudioPlayer _player;

  // Subscriptions
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _indexSubscription;
  StreamSubscription? _posSubscription;
  StreamSubscription? _durSubscription;

  @override
  AudioControlState build() {
    _player = ref.watch(audioPlayerProvider);
    _setupListeners();

    // Listen to Playback Speed Changes
    ref.listen(
      appConfigViewModelProvider.select((value) => value.playbackSpeed),
      (_, next) {
        _player.setSpeed(next);
      },
    );

    // Set initial speed
    final initialSpeed = ref.read(appConfigViewModelProvider).playbackSpeed;
    _player.setSpeed(initialSpeed);

    ref.onDispose(() {
      _playerStateSubscription?.cancel();
      _indexSubscription?.cancel();
      _posSubscription?.cancel();
      _durSubscription?.cancel();
    });

    return AudioControlState.initial();
  }

  void _setupListeners() {
    // 1. Listen to Playback State
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      final isBuffering = processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering;

      final isCompleted = processingState == ProcessingState.completed;

      state = state.copyWith(
        isPlaying: isPlaying,
        isBuffering: isBuffering,
      );

      // On completion, reset state to stop UI indicators
      if (isCompleted) {
        state = AudioControlState.initial();
      }
    });

    // 2. Listen to Current Item Index (for Playlist support)
    _indexSubscription = _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentAyahFromTag(index);
      }
    });

    // 3. Listen to Position & Duration
    _posSubscription = _player.positionStream.listen((p) {
      if (state.position != p) state = state.copyWith(position: p);
    });

    _durSubscription = _player.durationStream.listen((d) {
      if (state.duration != d) state = state.copyWith(duration: d);
    });
  }

  void _updateCurrentAyahFromTag(int index) {
    final source = _player.audioSource;
    Map<String, dynamic>? tag;

    if (source is ConcatenatingAudioSource) {
      if (index >= 0 && index < source.sequence.length) {
        tag = source.sequence[index].tag as Map<String, dynamic>?;
      }
    } else if (source is IndexedAudioSource) {
      tag = source.tag as Map<String, dynamic>?;
    }

    if (tag != null) {
      // Only update if changed to avoid unnecessary rebuilds
      final newSurah = tag['surahNumber'] as int?;
      final newAyah = tag['numberInSurah'] as int?;

      if (state.currentSurah != newSurah || state.currentAyah != newAyah) {
        state = state.copyWith(
          currentSurah: newSurah,
          currentAyah: newAyah,
        );
      }
    }
  }

  // --- ACTIONS ---

  Future<void> setSurahPlaylistAndPlay(
      int surahNumber, List<AyahWithTranslations> ayahs) async {
    final playlist = <AudioSource>[];
    for (final a in ayahs) {
      if (a.audioUrl == null) continue;
      final url = a.audioUrl!;
      final isLocal = !url.startsWith('http');

      if (isLocal) {
        String filePath = url;
        if (url.startsWith('file://')) {
          filePath = Uri.parse(url).toFilePath();
        }
        final file = File(filePath);
        if (!file.existsSync()) {
          AppLogger.w(
              "Audio: Local file missing for $surahNumber:${a.numberInSurah} at $filePath");
          continue; // Skip missing files to avoid crash
        }
        playlist.add(AudioSource.uri(
          Uri.file(filePath),
          tag: {'surahNumber': surahNumber, 'numberInSurah': a.numberInSurah},
        ));
      } else {
        playlist.add(AudioSource.uri(
          Uri.parse(url),
          tag: {'surahNumber': surahNumber, 'numberInSurah': a.numberInSurah},
        ));
      }
    }

    if (playlist.isEmpty) {
      AppLogger.w("Audio: No audio URLs found for Surah $surahNumber");
      return;
    }

    try {
      // Reset logic before new track
      await _player.stop();

      state = state.copyWith(
        isBuffering: true,
        currentSurah: surahNumber,
        isSurahMode: true,
      );

      await _player.setAudioSource(
        ConcatenatingAudioSource(children: playlist),
        initialIndex: 0,
        initialPosition: Duration.zero,
      );

      await _player.play();
    } catch (e) {
      AppLogger.e("Audio: Playlist Playback Failed", e);
      state = AudioControlState.initial();
    }
  }

  Future<void> playAyah(
      int surahNumber, int ayahNumber, String audioUrl) async {
    // If tapping the same ayah that is currently paused/playing
    if (state.currentSurah == surahNumber &&
        state.currentAyah == ayahNumber &&
        !_player.playing) {
      await _player.play();
      return;
    }

    try {
      await _player.stop();

      state = state.copyWith(
        isBuffering: true,
        currentSurah: surahNumber,
        currentAyah: ayahNumber,
      );

      final isLocal = !audioUrl.startsWith('http');
      Uri uri;

      if (isLocal) {
        String filePath = audioUrl;
        if (audioUrl.startsWith('file://')) {
          filePath = Uri.parse(audioUrl).toFilePath();
        }
        final file = File(filePath);
        if (!file.existsSync()) {
          AppLogger.e("Audio: Local file missing at $audioUrl");
          state = AudioControlState.initial();
          return;
          return;
        }
        uri = Uri.file(filePath);
      } else {
        uri = Uri.parse(audioUrl);
      }

      await _player.setAudioSource(
        AudioSource.uri(uri,
            tag: {'surahNumber': surahNumber, 'numberInSurah': ayahNumber}),
      );

      await _player.play();
      state = state.copyWith(isSurahMode: false);
    } catch (e) {
      AppLogger.e("Audio: Single Ayah Playback Failed", e);
      state = AudioControlState.initial();
    }
  }

  void playPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  Future<void> stop() async {
    AppLogger.i("Audio: Stopping playback manually.");
    await _player.stop();
    state = AudioControlState.initial();
  }
}

final audioControlProvider =
    NotifierProvider<AudioControlNotifier, AudioControlState>(
        AudioControlNotifier.new);

// -----------------------------------------------------------------------------
// 4. LEGACY / HELPER PROVIDERS
// -----------------------------------------------------------------------------

// Kept for backward compatibility if other files reference it
class CurrentPlayingAyah extends Notifier<String?> {
  @override
  String? build() => null;
  void setAyah(String? id) => state = id;
}

final currentPlayingAyahProvider =
    NotifierProvider<CurrentPlayingAyah, String?>(CurrentPlayingAyah.new);
