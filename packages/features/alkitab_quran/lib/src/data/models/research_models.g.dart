// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResearchMessage _$ResearchMessageFromJson(Map<String, dynamic> json) =>
    _ResearchMessage(
      isUser: json['isUser'] as bool,
      content: ResearchContent.fromJson(
        json['content'] as Map<String, dynamic>,
      ),
      isTyping: json['isTyping'] as bool? ?? false,
    );

Map<String, dynamic> _$ResearchMessageToJson(_ResearchMessage instance) =>
    <String, dynamic>{
      'isUser': instance.isUser,
      'content': instance.content,
      'isTyping': instance.isTyping,
    };

TextContent _$TextContentFromJson(Map<String, dynamic> json) =>
    TextContent(json['text'] as String, $type: json['runtimeType'] as String?);

Map<String, dynamic> _$TextContentToJson(TextContent instance) =>
    <String, dynamic>{'text': instance.text, 'runtimeType': instance.$type};

GrammarContent _$GrammarContentFromJson(Map<String, dynamic> json) =>
    GrammarContent(
      words: (json['words'] as List<dynamic>)
          .map((e) => GrammarWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$GrammarContentToJson(GrammarContent instance) =>
    <String, dynamic>{'words': instance.words, 'runtimeType': instance.$type};

HistoryContent _$HistoryContentFromJson(
  Map<String, dynamic> json,
) => HistoryContent(
  title: json['title'] as String? ?? '',
  era: json['era'] as String? ?? '',
  events:
      (json['events'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sources:
      (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$HistoryContentToJson(HistoryContent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'era': instance.era,
      'events': instance.events,
      'sources': instance.sources,
      'runtimeType': instance.$type,
    };

InsightContent _$InsightContentFromJson(Map<String, dynamic> json) =>
    InsightContent(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      reference: json['reference'] as String? ?? '',
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$InsightContentToJson(InsightContent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'tags': instance.tags,
      'reference': instance.reference,
      'runtimeType': instance.$type,
    };

_GrammarWord _$GrammarWordFromJson(Map<String, dynamic> json) => _GrammarWord(
  arabicWord: json['arabicWord'] as String,
  transliteration: json['transliteration'] as String? ?? '',
  root: json['root'] as String? ?? '',
  form: json['form'] as String? ?? '',
  tense: json['tense'] as String? ?? '',
  mood: json['mood'] as String? ?? '',
  meaning: json['meaning'] as String? ?? '',
);

Map<String, dynamic> _$GrammarWordToJson(_GrammarWord instance) =>
    <String, dynamic>{
      'arabicWord': instance.arabicWord,
      'transliteration': instance.transliteration,
      'root': instance.root,
      'form': instance.form,
      'tense': instance.tense,
      'mood': instance.mood,
      'meaning': instance.meaning,
    };
