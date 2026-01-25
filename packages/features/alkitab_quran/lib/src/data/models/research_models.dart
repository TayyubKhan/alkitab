import 'package:freezed_annotation/freezed_annotation.dart';

part 'research_models.freezed.dart';
part 'research_models.g.dart';

@freezed
abstract class ResearchMessage with _$ResearchMessage {
  const ResearchMessage._();
  const factory ResearchMessage({
    required bool isUser,
    required ResearchContent content,
    @Default(false) bool isTyping,
  }) = _ResearchMessage;

  factory ResearchMessage.fromJson(Map<String, dynamic> json) =>
      _$ResearchMessageFromJson(json);
}

@freezed
sealed class ResearchContent with _$ResearchContent {
  const factory ResearchContent.text(String text) = TextContent;
  
  const factory ResearchContent.grammar({
    required List<GrammarWord> words,
  }) = GrammarContent;

  const factory ResearchContent.history({
    @Default('') String title,
    @Default('') String era,
    @Default([]) List<String> events,
    @Default([]) List<String> sources,
  }) = HistoryContent;

  const factory ResearchContent.insight({
    @Default('') String title,
    @Default('') String body,
    @Default([]) List<String> tags,
    @Default('') String reference,
  }) = InsightContent;

  factory ResearchContent.fromJson(Map<String, dynamic> json) =>
      _$ResearchContentFromJson(json);
}

@freezed
abstract class GrammarWord with _$GrammarWord {
  const GrammarWord._();
  const factory GrammarWord({
    required String arabicWord,
    @Default('') String transliteration,
    @Default('') String root,
    @Default('') String form,
    @Default('') String tense,
    @Default('') String mood,
    @Default('') String meaning,
  }) = _GrammarWord;

  factory GrammarWord.fromJson(Map<String, dynamic> json) =>
      _$GrammarWordFromJson(json);
}
