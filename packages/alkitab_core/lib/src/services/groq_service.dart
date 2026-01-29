import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groq/groq.dart';
import '../../alkitab_core.dart'; // For AppLogger

class GroqService {
  late final Groq _groq;
  late final String _currentKey;
  // Use --dart-define=GROQ_API_KEY=your_key or .env
  static const String _apiKeyEnv = String.fromEnvironment('GROQ_API_KEY');
  static const String _defaultKey = '';

  static const String _modelId = 'llama-3.3-70b-versatile';

  GroqService() {
    _currentKey = _apiKeyEnv.isNotEmpty ? _apiKeyEnv : _defaultKey;
    if (_currentKey.isEmpty) {
      AppLogger.e('GROQ_API_KEY is missing');
    }

    final config = Configuration(
      model: _modelId,
      temperature: 0.5,
    );

    _groq = Groq(
      apiKey: _currentKey,
      configuration: config,
    );
  }

  /// Streams the content from Groq API
  Stream<String> streamContent(String fullPrompt) async* {
    if (_currentKey.isEmpty) {
      yield 'Error: GROQ API Key is missing. Please check your configuration.';
      return;
    }

    try {
      _groq.startChat();
      final response = await _groq.sendMessage(fullPrompt);
      final text = response.choices.firstOrNull?.message.content;
      if (text != null && text.isNotEmpty) {
        yield text;
      }
    } catch (e) {
      AppLogger.e('Groq Stream Error', e);
      if (e.toString().contains('401')) {
        yield '\n\n*(Error: Invalid API Key)*';
      } else {
        yield '\n\n*(AI Error: ${e.toString()})*';
      }
    }
  }
}

final groqServiceProvider = Provider<GroqService>((ref) {
  return GroqService(); 
});
