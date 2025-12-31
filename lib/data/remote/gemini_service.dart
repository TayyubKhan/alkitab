import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../core/utils/app_logger.dart';
import '../local/app_database.dart';

class GeminiService {
  final AppDatabase _db;

  // Use --dart-define=GEMINI_API_KEY=your_key
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String _modelId = 'gemini-2.5-flash';

  GeminiService(this._db);

  /// The exact method called by your ResearchViewModel.
  /// It takes the fully constructed prompt (including system instructions and JSON schema)
  /// and streams the response text.
  Stream<String> streamContent(String fullPrompt) async* {
    if (_apiKey.isEmpty) {
      AppLogger.e('GEMINI_API_KEY is missing');
      yield 'Error: API Key is missing. Please check your configuration.';
      return;
    }

    // 1. Configure Model
    // We use a lower temperature (0.3) here because we want precise JSON output
    // based on the strict schema defined in the ViewModel.
    final model = GenerativeModel(
      model: _modelId,
      apiKey: _apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
      generationConfig: GenerationConfig(
        temperature: 0.3, // Low temp = better compliance with JSON formatting
        maxOutputTokens: 8192,
      ),
    );

    // 2. Start Streaming
    final content = [Content.text(fullPrompt)];

    try {
      final responseStream = model.generateContentStream(content);

      await for (final chunk in responseStream) {
        final text = chunk.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      }
    } catch (e) {
      AppLogger.e('Gemini Stream Error', e);
      if (e is GenerativeAIException) {
        yield '\n\n*(AI Error: ${e.message})*';
      } else {
        yield '\n\n*(Connection error. Please check internet.)*';
      }
    }
  }
}

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(ref.watch(databaseProvider));
});
