import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'data/repositories/quran_repository.dart';
import 'features/onboarding/startup_screens.dart'; // Ensure StartupScreen is in this file
import 'viewmodels/settings_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // Inject prefs so providers can access it synchronously if needed
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const QuranApp(),
    ),
  );
}

class QuranApp extends ConsumerWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigViewModelProvider);

    AppLogger.d(
        "Building QuranApp. Theme: ${config.isDarkTheme ? 'Void (Dark)' : 'Clarity (Light)'}");

    return MaterialApp(
      title: 'Qudwa',
      debugShowCheckedModeBanner: false,

      // --- THEME CONNECTION ---
      // These connect to the static 'light' and 'dark' fields in your new AppTheme class
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // Controlled by your SettingsViewModel
      themeMode: config.isDarkTheme ? ThemeMode.dark : ThemeMode.light,

      // Locale Connection
      locale: _getLocale(config.appLanguage),

      // Entry Point
      home: const StartupCoordinator(),
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
      case 'English':
      default:
        return const Locale('en');
    }
  }
}
