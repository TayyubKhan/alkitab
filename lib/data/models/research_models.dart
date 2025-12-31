// Distinguish between types of content
enum ResearchType { text, grammar, history, insight }

abstract class ResearchContent {
  // Factory to decide which subclass to build based on the "type" field in JSON
  static ResearchContent fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'grammar':
        return GrammarContent.fromJson(json);
      case 'history':
        return HistoryContent.fromJson(json);
      case 'insight':
        return InsightContent.fromJson(json);
      default:
        // Fallback for standard chat or errors
        return TextContent(json['text'] ?? json.toString());
    }
  }
}

class TextContent extends ResearchContent {
  final String text;
  TextContent(this.text);
}

/// Represents a single word's analysis
class GrammarWord {
  final String arabicWord;
  final String transliteration;
  final String root;
  final String form;
  final String tense;
  final String mood;
  final String meaning;

  GrammarWord({
    required this.arabicWord,
    required this.transliteration,
    required this.root,
    required this.form,
    required this.tense,
    required this.mood,
    required this.meaning,
  });

  factory GrammarWord.fromJson(Map<String, dynamic> json) {
    return GrammarWord(
      arabicWord: json['arabicWord'] ?? '',
      transliteration: json['transliteration'] ?? '',
      root: json['root'] ?? '',
      form: json['form'] ?? '',
      tense: json['tense'] ?? '',
      mood: json['mood'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }
}

/// Holds a LIST of words for the grammar card
class GrammarContent extends ResearchContent {
  final List<GrammarWord> words;

  GrammarContent({required this.words});

  factory GrammarContent.fromJson(Map<String, dynamic> json) {
    final List<GrammarWord> parsedWords = [];

    // 1. Check if the AI returned a "words" array (New Format)
    if (json.containsKey('words') && json['words'] is List) {
      for (var w in json['words']) {
        if (w is Map<String, dynamic>) {
          parsedWords.add(GrammarWord.fromJson(w));
        }
      }
    }
    // 2. Fallback: If AI returned flat fields (Old Format), wrap it as one word
    else if (json.containsKey('arabicWord')) {
      parsedWords.add(GrammarWord.fromJson(json));
    }

    return GrammarContent(words: parsedWords);
  }
}

class HistoryContent extends ResearchContent {
  final String title;
  final String era;
  final List<String> events;
  final List<String> sources;

  HistoryContent({
    required this.title,
    required this.era,
    required this.events,
    required this.sources,
  });

  factory HistoryContent.fromJson(Map<String, dynamic> json) {
    return HistoryContent(
      title: json['title'] ?? 'Historical Context',
      era: json['era'] ?? '',
      // Robust parsing: handles Strings AND Objects if AI messes up
      events: (json['events'] as List? ?? []).map<String>((e) {
        if (e is String) return e;
        if (e is Map) {
          final name = e['name']?.toString() ?? '';
          final desc = e['description']?.toString() ?? '';
          if (name.isNotEmpty && desc.isNotEmpty) return '$name: $desc';
          return name.isNotEmpty ? name : desc;
        }
        return e.toString();
      }).toList(),

      sources: List<String>.from(json['sources'] ?? []),
    );
  }
}

class InsightContent extends ResearchContent {
  final String title;
  final String body;
  final List<String> tags;
  final String reference;

  InsightContent({
    required this.title,
    required this.body,
    required this.tags,
    required this.reference,
  });

  factory InsightContent.fromJson(Map<String, dynamic> json) {
    return InsightContent(
      title: json['title'] ?? 'Insight',
      body: json['body'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      reference: json['reference'] ?? '',
    );
  }
}

class ResearchMessage {
  final bool isUser;
  final ResearchContent content;
  final bool isTyping;

  ResearchMessage({
    required this.isUser,
    required this.content,
    this.isTyping = false,
  });

  ResearchMessage copyWith({
    bool? isUser,
    ResearchContent? content,
    bool? isTyping,
  }) {
    return ResearchMessage(
      isUser: isUser ?? this.isUser,
      content: content ?? this.content,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
