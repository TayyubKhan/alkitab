import 'package:alkitab_core/alkitab_core.dart';
import 'package:alkitab_quran/alkitab_quran.dart';
import 'package:alkitab_ui/alkitab_ui.dart';
import 'package:alkitab_models/alkitab_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart'; // To remove hash from URL

import 'package:alkitab_web/l10n/gen/app_localizations.dart';
import 'l10n/quran_localizations_adapter.dart';
import 'repositories/web_quran_repository.dart';
import 'components/settings/settings_sheet.dart';

// --- ROUTER CONFIGURATION ---
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SurahListScreen(
        onSettingsTap: () {
            showModalBottomSheet(
                context: context, 
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const SettingsBottomSheet()
            );
        },
        onSurahTap: (context, surah, ayah) async {
             context.go('/surah/${surah.number}', extra: surah);
        },
      ),
      routes: [
        GoRoute(
          path: 'surah/:surahNumber',
          builder: (context, state) {
            final surahNumber = int.parse(state.pathParameters['surahNumber']!);
             
             final surah = state.extra as Surah?;
             if (surah != null) {
                 return AyahListScreen(
                     surah: surah,
                     onShowSettings: (context) { // AyahList accepts onShowSettings
                         showModalBottomSheet(
                            context: context, 
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const SettingsBottomSheet()
                        );
                     }
                 );
             }
             
             return SurahLoader(surahNumber: surahNumber);
          },
        ),
      ],
    ),
  ],
);

// --- MAIN ENTRY POINT ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy(); // Remove # from URL
  
  // Even if unused by LastViewed, it's safer to have a valid instance 
  // than an UnimplementedError if any other code touches it.
  // final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override the abstract repository with the Web implementation
        quranRepositoryProvider.overrideWithValue(WebQuranRepository()),
        // sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AlkitabWebApp(),
    ),
  );
}

class AlkitabWebApp extends ConsumerWidget {
  const AlkitabWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch settings to trigger rebuild on theme toggle
    final config = ref.watch(appConfigViewModelProvider);
    final isDark = config.isDarkTheme;

    return MaterialApp.router(
      title: 'Alkitab Web',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: [
         AppLocalizations.delegate,
         const AppQuranLocalizationsDelegate(),
         ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('id'), 
        // Add others
      ],
    );
  }
}

// --- HELPER WIDGETS ---

class SurahLoader extends ConsumerWidget {
    final int surahNumber;
    const SurahLoader({super.key, required this.surahNumber});
    
    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final surahsAsync = ref.watch(surahListProvider);
        
        return surahsAsync.when(
            data: (surahs) {
                final surah = surahs.firstWhere(
                    (s) => s.number == surahNumber, 
                    orElse: () => surahs.first
                );
                return AyahListScreen(
                    surah: surah,
                    onShowSettings: (context) {
                         showModalBottomSheet(
                            context: context, 
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const SettingsBottomSheet()
                        );
                    }
                );
            },
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (e, s) => Scaffold(body: Center(child: Text("Error: $e"))),
        );
    }
}
