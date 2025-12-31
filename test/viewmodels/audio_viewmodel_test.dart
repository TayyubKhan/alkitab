import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qudwa/data/repositories/quran_repository.dart';
import 'package:qudwa/viewmodels/audio_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  group('AudioViewModel Tests', () {
    late MockAudioPlayer mockPlayer;
    late SharedPreferences prefs;

    setUp(() async {
      mockPlayer = MockAudioPlayer();
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      // Setup default mocks for AudioPlayer
      when(() => mockPlayer.playerStateStream).thenAnswer(
          (_) => Stream.value(PlayerState(false, ProcessingState.idle)));
      when(() => mockPlayer.positionStream)
          .thenAnswer((_) => Stream.value(Duration.zero));
      when(() => mockPlayer.durationStream)
          .thenAnswer((_) => Stream.value(null));
      when(() => mockPlayer.currentIndexStream)
          .thenAnswer((_) => Stream.value(null));
      when(() => mockPlayer.setSpeed(any())).thenAnswer((_) async => null);
      when(() => mockPlayer.stop()).thenAnswer((_) async => null);
    });

    test('Initial state should be empty', () {
      final container = ProviderContainer(
        overrides: [
          audioPlayerProvider.overrideWithValue(mockPlayer),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(audioControlProvider);
      expect(state.isPlaying, false);
      expect(state.currentSurah, isNull);
    });

    test('playPause should toggle player', () async {
      final container = ProviderContainer(
        overrides: [
          audioPlayerProvider.overrideWithValue(mockPlayer),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(audioControlProvider.notifier);

      when(() => mockPlayer.playing).thenReturn(false);
      when(() => mockPlayer.play()).thenAnswer((_) async => null);
      notifier.playPause();
      verify(() => mockPlayer.play()).called(1);

      when(() => mockPlayer.playing).thenReturn(true);
      when(() => mockPlayer.pause()).thenAnswer((_) async => null);
      notifier.playPause();
      verify(() => mockPlayer.pause()).called(1);
    });
  });
}
