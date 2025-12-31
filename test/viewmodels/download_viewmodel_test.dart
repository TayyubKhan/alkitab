import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qudwa/viewmodels/download_viewmodel.dart';
import 'package:qudwa/data/repositories/quran_repository.dart';
import 'package:qudwa/viewmodels/settings_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

class SetupOptionsFake extends Fake implements SetupOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(SetupOptionsFake());
  });

  group('DownloadViewModel Tests', () {
    late MockQuranRepository mockRepo;
    late SharedPreferences prefs;

    setUp(() async {
      mockRepo = MockQuranRepository();
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('Initial state should not be loading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(dataDownloadViewModelProvider);
      expect(state.isLoading, false);
      expect(state.progress, 0.0);
    });

    test('toggleFullEdition updates setup options', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(setupOptionsProvider.notifier);
      notifier.toggleFullEdition('131');

      final state = container.read(setupOptionsProvider);
      expect(state.fullEditions, contains('131'));

      notifier.toggleFullEdition('131');
      expect(container.read(setupOptionsProvider).fullEditions, isEmpty);
    });

    test('startDownload handles success', () async {
      final container = ProviderContainer(
        overrides: [
          quranRepositoryProvider.overrideWithValue(mockRepo),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      when(() => mockRepo.downloadInitialData(any(), any()))
          .thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[1] as Function(String);
        callback('Downloading structure...');
        callback('Downloading Audio: 50%');
      });

      final success = await container
          .read(dataDownloadViewModelProvider.notifier)
          .startDownload();

      expect(success, true);
      final state = container.read(dataDownloadViewModelProvider);
      expect(state.progressMessage, 'Download Complete');
      expect(state.progress, 1.0);
    });
  });
}
