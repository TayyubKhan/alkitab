import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/controllers/controllers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/repositories/quran_repository.dart';
import '../../../viewmodels/audio_viewmodel.dart';
import '../../../viewmodels/quran_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../settings/settings_sheet.dart';
import 'ayah_list_screen.dart';
import 'quran_search_delegate.dart';

// -----------------------------------------------------------------------------
// UI WIDGET
// -----------------------------------------------------------------------------

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  Future<void> _handleReset(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Reset Application?', style: theme.textTheme.headlineSmall),
        content: Text(
            'This will delete ALL downloaded data and settings. Are you sure?',
            style: theme.textTheme.bodyMedium),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel',
                style: TextStyle(color: theme.colorScheme.tertiary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Reset Data',
                style: TextStyle(color: theme.colorScheme.error)),
          )
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        await ref.read(quranRepositoryProvider).deleteAllLocalData();
        ref.invalidate(surahListProvider);
        ref.invalidate(lastViewedProvider);
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

    // 2. Data
    final surahsAsync = ref.watch(surahListProvider);
    final config = ref.watch(appConfigViewModelProvider);
    final lastSeen = ref.watch(lastViewedProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Void Black
      appBar: AppBar(
        title:
            Text("The Noble Quran", style: textTheme.headlineMedium), // Poppins
        centerTitle: true,
        actions: [
          // Search
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onSurface),
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
              child: Icon(Icons.settings, color: colorScheme.onSurface),
            ),
          ),

          // Theme Toggle (Icon changes based on state)
          IconButton(
            icon: Icon(config.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
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
            if (lastSeen.surah != null && lastSeen.ayah != null)
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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: surahList.length,
                separatorBuilder: (c, i) => Divider(
                    height: 1,
                    indent: 70,
                    endIndent: 20,
                    color: colorScheme.outline),
                itemBuilder: (context, index) {
                  final surah = surahList[index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    // Leading: Number in Gold Circle/Text
                    leading: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: Text(
                        "${surah.number}",
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.secondary, // Gold
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
                      "${surah.revelationType} • ${surah.numberOfAyahs} Ayahs",
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
                      FadePageRoute(
                          builder: (_) => AyahListScreen(surah: surah)),
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

    // Calculate progress
    final current = lastSeen.ayah ?? 0;
    final total = lastSeen.totalAyah ?? 1;
    final progress = (total > 0) ? (current / total).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color:
            colorScheme.surfaceContainer, // More appropriate surface for cards
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          // Subtle Gold Glow
          BoxShadow(
            color: colorScheme.secondary.withOpacity(0.08),
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
                        color: colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: colorScheme.secondary.withOpacity(0.2)),
                      ),
                      child: Icon(Icons.auto_stories_rounded,
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
                            lastSeen.surahName ?? 'Surah ${lastSeen.surah}',
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
                      "Ayah $current",
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "$total Ayahs",
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
