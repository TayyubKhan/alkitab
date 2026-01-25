import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alkitab_models/alkitab_models.dart';
import 'package:alkitab_ui/alkitab_ui.dart';
import 'package:alkitab_core/alkitab_core.dart'; // For LastViewedProvider
import 'ayah_list_screen.dart'; // Internal import
import '../viewmodels/quran_viewmodel.dart'; // Internal import
import '../l10n/quran_localizations.dart';

// Note: surahListProvider should be in quran_viewmodel.dart and exported.
// I will check if quran_viewmodel.dart indeed has it.
// If it does, we use it. If not, we use the one defined here (which threw unimplemented).
// In step 437 I wrote quran_viewmodel.dart but didn't check content.
// Usually it's better to rely on ViewModel.

import 'package:flutter/foundation.dart'; // For kIsWeb

class SurahListScreen extends ConsumerWidget {
  final Future<void> Function(BuildContext context, Surah surah, int? ayah)? onSurahTap;
  final VoidCallback? onSettingsTap;
  final void Function(String content, BuildContext context)? onReportContent;

  const SurahListScreen({
    super.key, 
    this.onSurahTap,
    this.onSettingsTap,
    this.onReportContent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Theme & Colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final strings = QuranLocalizations.of(context);
    
    // 2. Data
    final surahsAsync = ref.watch(surahListProvider);
    final lastViewed = ref.watch(lastViewedNotifierProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // Minimal AppBar or Standard?
      // Mobile used CustomScrollView in earlier iterations but let's stick to simple Scaffold for now.
      appBar: AppBar(
        title: Text("Alkitab", style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
        )),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
            if (onSettingsTap != null)
                IconButton(
                    icon: Icon(Icons.settings_outlined),
                    onPressed: onSettingsTap,
                )
        ]
      ),
      body: surahsAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.secondary)),
        error: (e, _) =>
            Center(child: Text("Error: $e", style: textTheme.bodyMedium)),
        data: (surahList) => Column(
          children: [
            // Continue Reading - HIDDEN ON WEB
             if (!kIsWeb && lastViewed.surahNumber != null)
              _ContinueReadingBanner(
                lastViewed: lastViewed,
                onTap: () {
                    // Navigate to Last Viewed
                     // We need to find the Surah object
                     final surah = surahList.firstWhere(
                         (s) => s.number == lastViewed.surahNumber,
                         orElse: () => surahList.first // Fallback
                     );
                     _navigateToSurah(context, surah, lastViewed.ayahNumber);
                },
              ),
              
             Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: surahList.length,
                separatorBuilder: (context, index) => Divider(
                    height: 1, 
                    color: colorScheme.outline.withOpacity(0.1), 
                    indent: 70, 
                    endIndent: 16
                ),
                itemBuilder: (context, index) {
                  final surah = surahList[index];
                  // Localize
                  String type = surah.revelationType;
                  if (strings != null) {
                      if (type.toLowerCase().contains("meccan")) type = strings.meccan;
                      if (type.toLowerCase().contains("medinan")) type = strings.medinan;
                  }
                  
                  return InkWell(
                    onTap: () => _navigateToSurah(context, surah, null),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                             // 1. Green Number
                             SizedBox(
                               width: 40,
                               child: Text(
                                 "${surah.number}",
                                 textAlign: TextAlign.center,
                                 style: textTheme.titleMedium?.copyWith(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                             const SizedBox(width: 16),
                             
                             // 2. Info
                             Expanded(
                               child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                         surah.englishName,
                                         style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                         )
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                         "$type • ${surah.numberOfAyahs} ${strings?.ayahs ?? 'Ayahs'}",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: textTheme.bodySmall?.color?.withOpacity(0.7)
                                          )
                                      )
                                  ]
                               )
                             ),
                             
                             // 3. Arabic Name
                             Text(
                                 surah.name,
                                 style: textTheme.titleLarge?.copyWith(
                                     fontFamily: 'quranfont', // Or generic if not loaded on web?
                                     // Provide fallback for web in case font fails
                                     fontFamilyFallback: ['Amiri', 'serif'],
                                     color: colorScheme.primary, // Android screenshot shows Black/Dark. User theme uses Primary Green or Text.
                                     // Screenshot shows Black text for Arabic. Surah 1 "Al-Fatihah" text is black.
                                     // Let's use onSurface for consistency in Dark Mode.
                                     // However, usually Arabic titles are ornate.
                                     // Screenshot: "Al-Fatihah" (Arabic) looks black.
                                     // Screenshot 2 (Dark Mode): "Al-Fatihah" (Arabic) is Green.
                                     // So use primary/secondary color.
                                 ),
                             ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToSurah(BuildContext context, Surah surah, int? ayah) {
      if (onSurahTap != null) {
          onSurahTap!(context, surah, ayah);
      } else {
          // Default Internal Navigation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AyahListScreen(
                surah: surah,
                initialAyah: ayah,
                onShowSettings: onSettingsTap != null 
                    ? (_) => onSettingsTap!() 
                    : null,
                onReportContent: onReportContent,
              ),
            ),
          );
      }
  }
}

class _ContinueReadingBanner extends StatelessWidget {
  final LastViewedState lastViewed;
  final VoidCallback onTap;

  const _ContinueReadingBanner({
    required this.lastViewed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.secondary.withOpacity(0.2))
                ),
                child: Row(
                    children: [
                        Icon(Icons.history, color: colorScheme.secondary),
                        const SizedBox(width: 16),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text("Continue Reading", style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary)),
                                Text("${lastViewed.surahName} : Ayah ${lastViewed.ayahNumber}", 
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)
                                )
                            ]
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.onSurface.withOpacity(0.5))
                    ]
                )
            )
        )
    );
  }
}
