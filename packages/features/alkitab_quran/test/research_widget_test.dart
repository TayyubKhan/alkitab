import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alkitab_quran/alkitab_quran.dart';
import 'package:alkitab_models/alkitab_models.dart';
import 'package:alkitab_core/alkitab_core.dart';
// Note: flutter_riverpod / riverpod_annotation might be needed for the override logic if implementation differs,
// but overrideWithValue(instance) works with Provider.

class FakeGroqService implements GroqService {
  @override
  Stream<String> streamContent(String fullPrompt) async* {
    if (fullPrompt.contains("grammar")) {
      yield "Here is the analysis:\n\n";
      // Simulate delay is tricky in tests without pump, but async* handles it.
      yield '{"type": "grammar", "words": [{"arabicWord": "TEST", "meaning": "Testing", "transliteration": "tst"}]}';
    } else if (fullPrompt.contains("revelation")) {
      yield '{"type": "revelation", "title": "Baqarah", "era": "Medinan", "events": ["Migration"], "sources": []}';
    } else {
      yield "Generic response";
    }
  }
}

void main() {
  testWidgets('ResearchSheet parses unknown types (revelation) gracefully', (
    tester,
  ) async {
    final surah = Surah(
      number: 1,
      name: 'Fatiha',
      englishName: 'Al-Fatiha',
      englishNameTranslation: 'Opening',
      numberOfAyahs: 7,
      revelationType: 'Meccan',
    );
    final ayah = AyahWithTranslations(
      numberInSurah: 1,
      arabicText: 'Bismillah',
      translations: {},
      tafsirs: {},
      words: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [groqServiceProvider.overrideWithValue(FakeGroqService())],
        child: MaterialApp(
          home: Scaffold(
            body: ResearchSheet(ayah: ayah, surah: surah),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), "Tell me about revelation");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(find.textContaining("Could not parse"), findsNothing);
    expect(find.text("Baqarah"), findsOneWidget);
  });

  testWidgets('ResearchSheet parses loose JSON grammar response correctly', (
    tester,
  ) async {
    // 1. Setup Models
    final surah = Surah(
      number: 1,
      name: 'Fatiha',
      englishName: 'Al-Fatiha',
      englishNameTranslation: 'Opening',
      numberOfAyahs: 7,
      revelationType: 'Meccan',
    );
    final ayah = AyahWithTranslations(
      numberInSurah: 1,
      arabicText: 'Bismillah',
      translations: {},
      tafsirs: {},
      words: [],
    );

    // 2. Pump Widget
    await tester.pumpWidget(
      ProviderScope(
        overrides: [groqServiceProvider.overrideWithValue(FakeGroqService())],
        child: MaterialApp(
          home: Scaffold(
            body: ResearchSheet(ayah: ayah, surah: surah),
          ),
        ),
      ),
    );

    // 3. Verify Initial State
    // "AI Research" is in the header
    expect(find.text("AI Research"), findsOneWidget);
    // Chips should be visible
    expect(find.text('Grammar'), findsOneWidget);

    // 4. Trigger Grammar Request
    await tester.tap(find.text('Grammar'));
    await tester.pump(); // Start animation/process

    // 5. Wait for Stream to complete
    // The fake stream yields twice. We pump to settle.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // 6. Verify GrammarCard is present
    // GrammarCard is a widget in the package.
    expect(find.byType(GrammarCard), findsOneWidget);

    // Check for specific content inside the card
    expect(find.text("TEST"), findsOneWidget); // Arabic word
    expect(find.text("Testing"), findsOneWidget); // Meaning

    // 7. Verify NO "Could not parse" error
    expect(find.textContaining("Could not parse"), findsNothing);
  });
}
