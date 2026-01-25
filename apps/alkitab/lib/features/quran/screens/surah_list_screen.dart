import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab/l10n/gen/app_localizations.dart';

import '../../../core/controllers/controllers.dart';
import '../../../data/repositories/quran_repository.dart';
import '../../../viewmodels/audio_viewmodel.dart';
import '../../../viewmodels/quran_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../settings/settings_sheet.dart';
import 'package:alkitab_quran/alkitab_quran.dart';
import 'quran_search_delegate.dart';
import 'package:alkitab_core/alkitab_core.dart' hide quranRepositoryProvider;

// -----------------------------------------------------------------------------
// UI WIDGET
// -----------------------------------------------------------------------------

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  Future<void> _handleReset(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(strings.resetAppTitle, style: theme.textTheme.headlineSmall),
        content: Text(
            strings.resetAppMessage,
            style: theme.textTheme.bodyMedium),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel",
                style: TextStyle(color: theme.colorScheme.tertiary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.resetData,
                style: TextStyle(color: theme.colorScheme.error)),
          )
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        await ref.read(quranRepositoryProvider).deleteAllLocalData();
        ref.invalidate(surahListProvider);
        ref.invalidate(lastViewedNotifierProvider);
        ref.invalidate(appConfigViewModelProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Application reset successfully")),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error resetting data: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Theme & Colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final strings = AppLocalizations.of(context)!;

    // 2. Data
    final surahsAsync = ref.watch(surahListProvider);
    final config = ref.watch(appConfigViewModelProvider);
    final lastSeen = ref.watch(lastViewedNotifierProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Void Black
      appBar: AppBar(
        title: Text("Alkitab", style: textTheme.headlineMedium), // Poppins
        centerTitle: true,
        actions: [
          // Search
          IconButton(
            icon: Icon(EvaIcons.search_outline, color: colorScheme.onSurface),
            tooltip: 'Search Quran',
            onPressed: () {
              showSearch(
                context: context,
                delegate: QuranSearchDelegate(ref: ref),
              );
            },
          ),

          // Settings
          GestureDetector(
            onTap: () {
              ref.read(audioControlProvider.notifier).stop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const SettingsBottomSheet(),
              );
            },
            onLongPress: () => _handleReset(context, ref),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(EvaIcons.settings_2_outline,
                  color: colorScheme.onSurface),
            ),
          ),

          // Theme Toggle (Icon changes based on state)
          IconButton(
            icon: Icon(
                config.isDarkTheme
                    ? EvaIcons.sun_outline
                    : EvaIcons.moon_outline,
                color: colorScheme.onSurface),
            onPressed: () => ref
                .read(appConfigViewModelProvider.notifier)
                .toggleTheme(!config.isDarkTheme),
          )
        ],
      ),
      body: surahsAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.secondary)),
        error: (e, _) =>
            Center(child: Text("Error: $e", style: textTheme.bodyMedium)),
        data: (surahList) => Column(
          children: [
            // --- CONTINUE READING BANNER ---
            if (lastSeen.surahNumber != null && lastSeen.ayahNumber != null)
              _ContinueReadingBanner(
                lastSeen: lastSeen,
                onTap: () {
                  ref
                      .read(surahListControllerProvider.notifier)
                      .navigateToLastSeen(context, lastSeen);
                },
              ),

            // --- SURAH LIST ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: surahList.length,
                itemBuilder: (context, index) {
                  final surah = surahList[index];

                  // Helper for revelation type
                  String localizedRevelation = surah.revelationType;
                  if (localizedRevelation.toLowerCase().contains('meccan') || localizedRevelation.toLowerCase().contains('makkah')) {
                    localizedRevelation = strings.meccan;
                  } else if (localizedRevelation.toLowerCase().contains('medinan') || localizedRevelation.toLowerCase().contains('madinah')) {
                    localizedRevelation = strings.medinan;
                  }

                  // Helper for Ayahs label
                  final String ayahsLabel = surah.numberOfAyahs == 1 ? strings.ayah : strings.ayahs;
                  
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    // Leading: Minimal Number
                    leading: Container(
                      width: 30, // Slightly smaller
                      alignment: Alignment.center,
                      child: Text(
                        "${surah.number}",
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary, // Gold
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Title: English Name
                    title: Text(
                      surah.englishName,
                      style: textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    // Subtitle: Metadata
                    subtitle: Text(
                      "$localizedRevelation • ${surah.numberOfAyahs} $ayahsLabel",
                      style: textTheme.labelSmall
                          ?.copyWith(color: colorScheme.tertiary),
                    ),
                    // Trailing: Arabic Name (Special Font)
                    trailing: Text(
                      surah.name,
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 20,
                        height: 1.2,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AyahListScreen(
                            surah: surah,
                            onShowSettings: (ctx) {
                              ref.read(audioControlProvider.notifier).stop();
                              showModalBottomSheet(
                                context: ctx,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const SettingsBottomSheet(),
                              );
                            },
                          )),
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
}

// -----------------------------------------------------------------------------
// CONTINUE READING BANNER (Void & Gold Style)
// -----------------------------------------------------------------------------
class _ContinueReadingBanner extends StatelessWidget {
  final LastViewedState lastSeen;
  final VoidCallback onTap;

  const _ContinueReadingBanner({
    required this.lastSeen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final strings = AppLocalizations.of(context)!;

    // Calculate progress
    final current = lastSeen.ayahNumber ?? 0;
    final total = lastSeen.totalAyahs ?? 1;
    final progress = (total > 0) ? (current / total).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color:
            colorScheme.surfaceContainer, // More appropriate surface for cards
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          // Subtle Gold Glow
          BoxShadow(
            color: colorScheme.secondary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Box
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color:
                                colorScheme.secondary.withValues(alpha: 0.2)),
                      ),
                      child: Icon(EvaIcons.book_open_outline,
                          color: colorScheme.secondary, size: 22),
                    ),
                    const SizedBox(width: 16),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CONTINUE READING",
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.tertiary,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lastSeen.surahName ?? 'Surah ${lastSeen.surahNumber}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Percentage Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Text(
                        "$percentage%",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Progress Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${strings.ayah} $current",
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "$total ${strings.ayahs}",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
