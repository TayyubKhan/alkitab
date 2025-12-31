import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:qudwa/features/settings/widgets/settings_sections.dart';
import 'package:qudwa/data/repositories/quran_repository.dart';
import 'package:qudwa/viewmodels/audio_viewmodel.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  late SharedPreferences prefs;
  late MockAudioPlayer mockPlayer;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    mockPlayer = MockAudioPlayer();

    when(() => mockPlayer.playerStateStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.positionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.durationStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.currentIndexStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.setSpeed(any())).thenAnswer((_) async => null);
  });

  testWidgets('ReadingSection should display IndoPak font style option',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          audioPlayerProvider.overrideWithValue(mockPlayer),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ReadingSection(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('IndoPak'), findsOneWidget);
    expect(find.text('Amiri'), findsOneWidget);
  });
}
