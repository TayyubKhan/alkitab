import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:qudwa/features/quran/widgets/ayah_card.dart';
import 'package:qudwa/data/models/quran_models.dart';
import 'package:qudwa/viewmodels/settings_viewmodel.dart';
import 'package:qudwa/viewmodels/audio_viewmodel.dart';
import 'package:qudwa/data/repositories/quran_repository.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class FakeSurah extends Fake implements Surah {}

void main() {
  late SharedPreferences prefs;
  late MockAudioPlayer mockPlayer;

  setUpAll(() {
    registerFallbackValue(FakeSurah());
  });

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

  testWidgets('AyahRow should display Arabic and translation text',
      (WidgetTester tester) async {
    const arabicText =
        '\u0628\u0650\u0633\u0652\u0645\u0650 \u0627\u0644\u0644\u0651\u064e\u0647\u0650';

    final ayah = AyahWithTranslations(
      numberInSurah: 1,
      arabicText: arabicText,
      translations: const {'131': 'In the name of Allah'},
      tafsirs: const {},
      words: [
        AyahWord(
          wordNumber: 1,
          arabicText: '\u0628\u0650\u0633\u0652\u0645\u0650',
          translation: 'In the name of',
          transliteration: 'Bismi',
          localAudioPath: '',
        ),
        AyahWord(
          wordNumber: 2,
          arabicText: '\u0627\u0644\u0644\u0651\u064e\u0647\u0650',
          translation: 'Allah',
          transliteration: 'Allah',
          localAudioPath: '',
        ),
      ],
      audioUrl: null,
    );

    final surah = Surah(
      number: 1,
      name: 'Al-Fatiha',
      englishName: 'Al-Fatiha',
      englishNameTranslation: 'The Opening',
      revelationType: 'Meccan',
      numberOfAyahs: 7,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          audioPlayerProvider.overrideWithValue(mockPlayer),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AyahRow(
              ayah: ayah,
              surah: surah,
              editionMap: const {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AyahRow), findsOneWidget);
    expect(find.text('In the name of Allah'), findsOneWidget);
    expect(find.textContaining('\u0628\u0650\u0633\u0652\u0645\u0650'),
        findsOneWidget);
  });
}
