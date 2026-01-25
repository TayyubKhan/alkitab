import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:alkitab_core/alkitab_core.dart';
import 'package:alkitab_models/alkitab_models.dart';

import 'settings_viewmodel.dart'; // Same package import

// -----------------------------------------------------------------------------
// 1. AUDIO PLAYER INSTANCE
// -----------------------------------------------------------------------------

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final p = AudioPlayer();
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

  factory AudioControlState.initial() => const AudioControlState();
}

// -----------------------------------------------------------------------------
// 3. AUDIO CONTROLLER NOTIFIER
// -----------------------------------------------------------------------------

class AudioControlNotifier extends Notifier<AudioControlState> {
  late final AudioPlayer _player;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _indexSubscription;
  StreamSubscription? _posSubscription;
  StreamSubscription? _durSubscription;

  @override
  AudioControlState build() {
    _player = ref.watch(audioPlayerProvider);
    _setupListeners();

    ref.listen(
      appConfigViewModelProvider.select((value) => value.playbackSpeed),
      (_, next) {
        _player.setSpeed(next);
      },
    );

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

      if (isCompleted) {
        state = AudioControlState.initial();
      }
    });

    _indexSubscription = _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentAyahFromTag(index);
      }
    });

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
    final fileService = ref.read(fileServiceProvider);
    final playlist = <AudioSource>[];
    
    for (final a in ayahs) {
      if (a.audioUrl == null) continue;
      final url = a.audioUrl!;
      final isLocal = !url.startsWith('http');

      if (isLocal) {
        final exists = await fileService.fileExists(url);
        if (!exists) {
          AppLogger.w(
              "Audio: Local file missing for $surahNumber:${a.numberInSurah} at $url");
          continue; 
        }
        
        // Use Uri.file if it looks like a path, or parse if schema present
        Uri uri;
        if (url.startsWith('file://')) {
          uri = Uri.parse(url);
        } else {
          uri = Uri.file(url);
        }

        playlist.add(AudioSource.uri(
          uri,
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
        final fileService = ref.read(fileServiceProvider);
        final exists = await fileService.fileExists(audioUrl);
        if (!exists) {
           AppLogger.e("Audio: Local file missing at $audioUrl");
           state = AudioControlState.initial();
           return;
        }

        if (audioUrl.startsWith('file://')) {
          uri = Uri.parse(audioUrl);
        } else {
          uri = Uri.file(audioUrl);
        }
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

// Helper for backward compatibility
class CurrentPlayingAyah extends Notifier<String?> {
  @override
  String? build() => null;
  void setAyah(String? id) => state = id;
}

final currentPlayingAyahProvider =
    NotifierProvider<CurrentPlayingAyah, String?>(CurrentPlayingAyah.new);
