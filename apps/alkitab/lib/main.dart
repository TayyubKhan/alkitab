import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alkitab/l10n/gen/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/l10n/quran_localizations_adapter.dart';
import 'data/local/app_database.dart';
import 'data/repositories/quran_repository.dart' show mobileQuranRepositoryProvider;
import 'features/onboarding/startup_screens.dart';
import 'services/feedback_service.dart';
import 'services/local_file_service.dart';
import 'package:alkitab_core/alkitab_core.dart';
import 'viewmodels/settings_viewmodel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database early to hook logger
  final database = AppDatabase();
  
  // Hook Logger to DB
  AppLogger.init((level, message, stackTrace) {
    // Fire and forget logging
    database.insertLog(level, message, stackTrace);
  });

  AppLogger.i("Application initializing...");

  // Error Trapping
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.e("Flutter UI Error", details.exception, details.stack);
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.e("Async Platform Error", error, stack);
    return true;
  };

  // Load Preferences
  final prefs = await SharedPreferences.getInstance();
  AppLogger.i("SharedPreferences loaded successfully.");

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
        fileServiceProvider.overrideWith((ref) => LocalFileService()),
        quranRepositoryProvider.overrideWith((ref) => ref.watch(mobileQuranRepositoryProvider)),
      ],
      child: const QuranApp(),
    ),
  );
}

class QuranApp extends ConsumerStatefulWidget {
  const QuranApp({super.key});

  @override
  ConsumerState<QuranApp> createState() => _QuranAppState();
}

class _QuranAppState extends ConsumerState<QuranApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Feedback Service listener
    ref.read(feedbackServiceProvider).initialize();
  }

  @override
  void dispose() {
    // Note: feedbackServiceProvider handles its own lifecycle if it were an AutoDisposeProvider,
    // but here we manually stop the listener if needed. 
    // Actually FeedbackService.initialize starts a ShakeDetector.
    ref.read(feedbackServiceProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigViewModelProvider);

    AppLogger.d(
        "Building QuranApp. Theme: ${config.isDarkTheme ? 'Void (Dark)' : 'Clarity (Light)'}");

    return Screenshot(
      controller: ref.watch(screenshotControllerProvider),
      child: MaterialApp(
        navigatorKey: ref.watch(navigatorKeyProvider),
        title: 'Alkitab',
        debugShowCheckedModeBanner: false,


        // --- LOCALIZATION ---
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          AppQuranLocalizationsDelegate(),
        ],
        supportedLocales: AppLocalizations.supportedLocales,
  
        // --- THEME CONNECTION ---
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
  
        // Controlled by your SettingsViewModel
        themeMode: config.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
  
        // Locale Connection
        locale: _getLocale(config.appLanguage),
  
        // Entry Point
        home: const StartupCoordinator(),
      ),
    );
  }

  Locale _getLocale(String languageName) {
    switch (languageName) {
      case 'Urdu':
        return const Locale('ur');
      case 'Arabic':
        return const Locale('ar');
      case 'Indonesian':
        return const Locale('id');
      case 'French':
        return const Locale('fr');
      case 'Spanish':
        return const Locale('es');
      case 'German':
        return const Locale('de');
      case 'Russian':
        return const Locale('ru');
      case 'Turkish':
        return const Locale('tr');
      case 'Hindi':
        return const Locale('hi');
      case 'Bengali':
        return const Locale('bn');
      case 'English':
      default:
        return const Locale('en');
    }
  }
}
