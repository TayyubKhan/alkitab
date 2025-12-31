import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:qudwa/data/repositories/quran_repository.dart';
import 'package:qudwa/data/local/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('QuranRepository Tests', () {
    late MockAppDatabase mockDb;
    late MockHttpClient mockClient;
    late SharedPreferences prefs;
    late QuranRepository repository;

    setUp(() async {
      mockDb = MockAppDatabase();
      mockClient = MockHttpClient();
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      // We need to inject the mock client. QuranRepository creates its own if null.
      // However, the current implementation doesn't allow injecting a client.
      // I might need to refactor QuranRepository to accept an optional client for testing.
      // Let's check the constructor again.
      repository = QuranRepository(mockDb, prefs);
    });

    test('isBaseDataDownloaded should check both prefs and DB', () async {
      await prefs.setBool('is_base_data_v11_complete', true);
      when(() => mockDb.isBaseDataDownloaded()).thenAnswer((_) async => true);

      final result = await repository.isBaseDataDownloaded();
      expect(result, true);
      verify(() => mockDb.isBaseDataDownloaded()).called(1);
    });

    test('isEditionDownloaded should delegate to DB', () async {
      when(() => mockDb.isEditionDownloaded('131'))
          .thenAnswer((_) async => true);
      final result = await repository.isEditionDownloaded('131');
      expect(result, true);
    });
  });
}
