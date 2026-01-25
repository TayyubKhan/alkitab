import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alkitab/viewmodels/settings_viewmodel.dart';
import 'package:alkitab/data/repositories/quran_repository.dart';

void main() {
  late SharedPreferences prefs;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SettingsViewModel Normalization Tests', () {
    test('should map legacy names to quranfont', () {
      final vm = container.read(appConfigViewModelProvider.notifier);

      vm.setArabicFontStyle('pdms');
      expect(container.read(appConfigViewModelProvider).arabicFontStyle,
          'quranfont');

      vm.setArabicFontStyle('naskh');
      expect(container.read(appConfigViewModelProvider).arabicFontStyle,
          'quranfont');

      vm.setArabicFontStyle('indopak');
      expect(container.read(appConfigViewModelProvider).arabicFontStyle,
          'quranfont');
    });

    test('should map legacy names to amiri', () {
      final vm = container.read(appConfigViewModelProvider.notifier);

      vm.setArabicFontStyle('uthmani');
      expect(
          container.read(appConfigViewModelProvider).arabicFontStyle, 'amiri');

      vm.setArabicFontStyle('amiri');
      expect(
          container.read(appConfigViewModelProvider).arabicFontStyle, 'amiri');
    });
  });
}
