import 'dart:async';
import 'dart:convert';

import 'package:alkitab_core/alkitab_core.dart'; // Core providers (Groq) & Logger
import 'package:alkitab_models/alkitab_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/research_models.dart';

part 'research_viewmodel.g.dart';

@riverpod
class ResearchNotifier extends _$ResearchNotifier {
  StreamSubscription? _subscription;

  @override
  List<ResearchMessage> build(String key) {
    ref.keepAlive();

    return [
      ResearchMessage(
        isUser: false,
        content: TextContent(
          'I am your Quranic research assistant. Ask me about grammar, history, or insights.',
        ),
      ),
    ];
  }

  Future<void> sendQuery({
    required String query,
    required AyahWithTranslations ayah,
    required Surah surah,
    String mode = 'text',
  }) async {
    final userMsg = ResearchMessage(isUser: true, content: TextContent(query));

    final aiMsg = ResearchMessage(
      isUser: false,
      content: TextContent('...'),
      isTyping: true,
    );

    state = [...state, userMsg, aiMsg];

    final prompt = _constructPrompt(query, mode, ayah, surah);
    final groq = ref.read(groqServiceProvider);
    final buffer = StringBuffer();

    await _subscription?.cancel();
    _subscription = groq
        .streamContent(prompt)
        .listen(
          (chunk) {
            buffer.write(chunk);
            if (mode == 'text') {
              _updateLastMessage(
                TextContent(buffer.toString()),
                isTyping: true,
              );
            }
          },
          onDone: () {
            final fullText = buffer.toString();

            if (mode == 'text') {
              _updateLastMessage(TextContent(fullText), isTyping: false);
              return;
            }

            try {
              // Improved Regex to catch JSON even if surrounded by text
              final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(fullText);
              if (jsonMatch == null) throw FormatException("No JSON found");

              final cleanJson = jsonMatch.group(0)!;
              final Map<String, dynamic> data = jsonDecode(cleanJson);

              // Freezed requires 'runtimeType', but LLM gives 'type'. Map it:
              if (data.containsKey('type')) {
                String type = (data['type'] as String).toLowerCase();
                // Handle common AI hallucinations/synonyms
                if (type == 'revelation') type = 'history';
                if (type == 'reflection') type = 'insight';

                data['runtimeType'] = type;
              }

              final content = ResearchContent.fromJson(data);

              _updateLastMessage(content, isTyping: false);
            } catch (e) {
              // TEMPORARY DEBUG PRINT
              print("DEBUG_TEST_EXCEPTION: $e");
              AppLogger.e("Parsing Error: $e");
              _updateLastMessage(
                TextContent('Could not parse response:\n\n$fullText'),
                isTyping: false,
              );
            }
          },
          onError: (err) {
            _updateLastMessage(TextContent('AI error: $err'), isTyping: false);
          },
        );
  }

  void _updateLastMessage(ResearchContent content, {required bool isTyping}) {
    if (state.isEmpty) return;

    final updated = [...state];
    final lastIndex = updated.length - 1;

    if (!updated[lastIndex].isUser) {
      updated[lastIndex] = updated[lastIndex].copyWith(
        content: content,
        isTyping: isTyping,
      );
    }

    state = updated;
  }

  String _constructPrompt(
    String query,
    String mode,
    AyahWithTranslations ayah,
    Surah surah,
  ) {
    final context =
        'Surah ${surah.englishName} (${surah.number}), '
        'Ayah ${ayah.numberInSurah}. '
        'Arabic: ${ayah.arabicText}.';

    const base = 'You are a specialized Quranic Scholar AI.';

    switch (mode) {
      case 'grammar':
        return '''
$base
Context: $context
Analyze the grammar of the key words in this Ayah.
Return ONLY valid JSON.
The JSON must contain a "words" array.
Structure:
{
  "type": "grammar",
  "words": [
    {
      "arabicWord": "Word 1",
      "transliteration": "...",
      "root": "...",
      "form": "...",
      "tense": "...",
      "mood": "...",
      "meaning": "..."
    },
    {
      "arabicWord": "Word 2",
      "..." : "..."
    }
  ]
}
''';

      case 'history':
        return '''
$base
Context: $context
Return ONLY valid JSON.
For "events", provide a list of simple strings, not objects.
Structure:
{
  "type": "history",
  "title": "",
  "era": "",
  "events": ["event string 1", "event string 2"],
  "sources": []
}
''';

      case 'insight':
        return '''
$base
Context: $context
Return ONLY valid JSON:
{
  "type": "insight",
  "title": "",
  "body": "",
  "tags": [],
  "reference": ""
}
''';

      default:
        return '''
$base
Context: $context
Question: $query
Answer concisely.
''';
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
