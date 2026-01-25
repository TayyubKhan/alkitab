import 'package:alkitab/viewmodels/quran_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Research Models Tests', () {
    test('ResearchContent.fromJson should return GrammarContent', () {
      final json = {
        'type': 'grammar',
        'words': [
          {'arabicWord': 'بِسْمِ', 'meaning': 'In the name', 'root': 'b-s-m'}
        ]
      };
      final content = ResearchContent.fromJson(json);
      expect(content, isA<GrammarContent>());
      expect((content as GrammarContent).words.first.arabicWord, 'بِسْمِ');
    });

    test('GrammarContent should handle old flat format', () {
      final json = {
        'type': 'grammar',
        'arabicWord': 'اللَّهِ',
        'meaning': 'Allah'
      };
      final content = GrammarContent.fromJson(json);
      expect(content.words.length, 1);
      expect(content.words.first.arabicWord, 'اللَّهِ');
    });

    test('HistoryContent.fromJson should handle robust event parsing', () {
      final json = {
        'type': 'history',
        'title': 'The Revelation',
        'era': 'Meccan',
        'events': [
          'First Revelation in Hira',
          {'name': 'Event 2', 'description': 'Description 2'}
        ],
        'sources': ['Source 1']
      };
      final content = ResearchContent.fromJson(json) as HistoryContent;
      expect(content.title, 'The Revelation');
      expect(content.events[0], 'First Revelation in Hira');
      expect(content.events[1], 'Event 2: Description 2');
    });

    test('InsightContent.fromJson should map correctly', () {
      final json = {
        'type': 'insight',
        'title': 'Deep Meaning',
        'body': 'This is a test body',
        'tags': ['tag1', 'tag2'],
        'reference': 'Ref 1'
      };
      final content = ResearchContent.fromJson(json) as InsightContent;
      expect(content.title, 'Deep Meaning');
      expect(content.tags, contains('tag1'));
    });

    test('ResearchContent.fromJson fallback to TextContent', () {
      final json = {'text': 'Hello World'};
      final content = ResearchContent.fromJson(json);
      expect(content, isA<TextContent>());
      expect((content as TextContent).text, 'Hello World');
    });
  });
}
