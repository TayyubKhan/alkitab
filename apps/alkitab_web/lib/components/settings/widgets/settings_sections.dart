import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alkitab_web/l10n/gen/app_localizations.dart';
import 'package:alkitab_core/alkitab_core.dart';
import 'package:alkitab_models/alkitab_models.dart';

import 'font_preview_card.dart';
import 'settings_widgets.dart';

// -----------------------------------------------------------------------------
// HELPER: Search Filter Logic
// -----------------------------------------------------------------------------
bool _matchesSearch(WidgetRef ref, String text) {
  final query = ref.watch(settingsSearchQueryProvider).toLowerCase();
  if (query.isEmpty) return true;
  return text.toLowerCase().contains(query);
}

// -----------------------------------------------------------------------------
// 1. GENERAL SECTION
// -----------------------------------------------------------------------------
class GeneralSection extends ConsumerWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref
        .watch(appConfigViewModelProvider.select((value) => value.appLanguage));
    final isDark = ref
        .watch(appConfigViewModelProvider.select((value) => value.isDarkTheme));
    final vm = ref.read(appConfigViewModelProvider.notifier);
    final strings = AppLocalizations.of(context)!;

    // Define tiles
    final tiles = [
      if (_matchesSearch(ref, strings.appLanguage))
        _SettingTile(
          icon: EvaIcons.globe_outline,
          title: strings.appLanguage,
          trailingText: language,
          onTap: () => _SectionHelpers.showSelectionDialog(
            context,
            strings.selectLanguage,
            [
              'English',
              'Urdu',
              'Arabic',
              'Indonesian',
              'French',
              'Spanish',
              'German',
              'Russian',
              'Turkish',
              'Hindi',
              'Bengali'
            ],
            language,
            (val) => vm.setAppLanguage(val),
          ),
        ),
      if (_matchesSearch(ref, strings.darkMode))
        _SettingToggle(
          icon: EvaIcons.moon_outline,
          title: strings.darkMode,
          value: isDark,
          onChanged: (v) => vm.toggleTheme(v),
        ),
    ];

    if (tiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: strings.generalSection),
        SettingsCard(children: _addDividers(tiles)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 2. READING SECTION
// -----------------------------------------------------------------------------
class ReadingSection extends ConsumerWidget {
  const ReadingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showArabic =
        ref.watch(appConfigViewModelProvider.select((s) => s.showArabicText));
    final arabicFontStyle =
        ref.watch(appConfigViewModelProvider.select((s) => s.arabicFontStyle));
    final arabicFontSize =
        ref.watch(appConfigViewModelProvider.select((s) => s.arabicFontSize));
    final translationFontSize = ref
        .watch(appConfigViewModelProvider.select((s) => s.translationFontSize));
    final tafsirFontSize =
        ref.watch(appConfigViewModelProvider.select((s) => s.tafsirFontSize));

    final vm = ref.read(appConfigViewModelProvider.notifier);
    final theme = Theme.of(context);
    final query = ref.watch(settingsSearchQueryProvider);
    final strings = AppLocalizations.of(context)!;

    final tiles = <Widget>[];

    if (_matchesSearch(ref, strings.showArabicText)) {
      tiles.add(_SettingToggle(
        icon: EvaIcons.file_text_outline,
        title: strings.showArabicText,
        value: showArabic,
        onChanged: (v) => vm.setShowArabic(v),
      ));
    }

    if (query.isEmpty) {
      tiles.add(const FontPreviewCard());
    }

    if (_matchesSearch(ref, strings.arabicFontStyle)) {
      tiles.add(
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.arabicFontStyle, style: theme.textTheme.labelLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _SegmentButton(
                        label: "Amiri",
                        isSelected: arabicFontStyle == 'amiri' ||
                            arabicFontStyle == 'uthmani',
                        onTap: () => vm.setArabicFontStyle('amiri')),
                    _SegmentButton(
                        label: "IndoPak",
                        isSelected: arabicFontStyle == 'quranfont' ||
                            arabicFontStyle == 'indopak' ||
                            arabicFontStyle == 'pdms',
                        onTap: () => vm.setArabicFontStyle('quranfont')),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    if (_matchesSearch(ref, "Font Size Translation Tafsir")) {
      tiles.add(Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FontSizeControl(
                label: strings.fontSize,
                value: arabicFontSize,
                min: 20,
                max: 60,
                onChanged: (v) => vm.setArabicFontSize(v)),
            const SizedBox(height: 16),
            _FontSizeControl(
                label: strings.translationFontSize,
                value: translationFontSize,
                min: 10,
                max: 30,
                onChanged: (v) => vm.setTranslationFontSize(v)),
            const SizedBox(height: 16),
            _FontSizeControl(
                label: strings.tafsirFontSize,
                value: tafsirFontSize,
                min: 10,
                max: 30,
                onChanged: (v) => vm.setTafsirFontSize(v)),
          ],
        ),
      ));
    }

    if (tiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: strings.readingSection),
        SettingsCard(children: _addDividers(tiles)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 3. CONTENT SECTION
// -----------------------------------------------------------------------------
class ContentSection extends ConsumerStatefulWidget {
  const ContentSection({super.key});

  @override
  ConsumerState<ContentSection> createState() => _ContentSectionState();
}

class _ContentSectionState extends ConsumerState<ContentSection> {
  final Map<String, String> _downloadProgress = {};

  Future<void> _downloadEdition(
      String id, String type, AppConfigViewModel vm) async {
    if (_downloadProgress.containsKey(id)) return;

    setState(() {
      _downloadProgress[id] = "Starting...";
    });

    try {
      final repo = ref.read(quranRepositoryProvider);
      await repo.downloadAndStoreTranslation(id, (msg) {
        if (mounted) {
          setState(() {
            _downloadProgress[id] = msg;
          });
        }
      });
      // Force refresh of downloaded status
      ref.invalidate(downloadedEditionIdsProvider);
    } catch (_) {
      // generic
    } finally {
      if (mounted) {
        setState(() {
          _downloadProgress.remove(id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    if (!_matchesSearch(ref, "Translations Tafsir")) {
      return const SizedBox.shrink();
    }

    final activeTranslations = ref.watch(appConfigViewModelProvider
        .select((s) => s.activeTranslationIdentifiers));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: strings.contentSection),
        SettingsCard(
          children: [
            _SettingTile(
              icon: EvaIcons.globe_outline,
              title: strings.manageTranslations,
              subtitle: "${activeTranslations.length} active",
              onTap: () => _SectionHelpers.showEditionsSheet(
                context: context,
                type: 'translation',
                vm: vm,
                progressMap: _downloadProgress,
                onDownload: (id) => _downloadEdition(id, 'translation', vm),
                title: strings.selectTranslation,
              ),
            ),
            const _Divider(),
            _SettingTile(
              icon: EvaIcons.book_outline,
              title: strings.manageTafsirs,
              onTap: () => _SectionHelpers.showEditionsSheet(
                context: context,
                type: 'tafsir',
                vm: vm,
                progressMap: _downloadProgress,
                onDownload: (id) => _downloadEdition(id, 'tafsir', vm),
                title: strings.selectTafsir,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. WORD BY WORD SECTION
// -----------------------------------------------------------------------------
class WordByWordSection extends ConsumerWidget {
  const WordByWordSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    if (!_matchesSearch(ref, "Word by Word Analysis")) {
      return const SizedBox.shrink();
    }

    final isWbw = ref
        .watch(appConfigViewModelProvider.select((s) => s.isDirectWBWEnabled));
    final wbwLang =
        ref.watch(appConfigViewModelProvider.select((s) => s.wbwLanguage));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: strings.wordByWordSection),
        SettingsCard(
          children: [
            _SettingToggle(
              icon: EvaIcons.text_outline,
              title: strings.enableWordAnalysis,
              value: isWbw,
              onChanged: vm.setDirectWBW,
            ),
            if (isWbw) ...[
              const _Divider(),
              _SettingTile(
                icon: EvaIcons.globe_2_outline,
                title: strings.analysisLanguage,
                trailingText: wbwLang,
                onTap: () => _SectionHelpers.showSelectionDialog(
                  context,
                  strings.analysisLanguage,
                  ['English', 'Urdu', 'Indonesian', 'Hindi'],
                  wbwLang,
                  vm.setWbwLanguage,
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 5. AI ASSISTANT SECTION
// -----------------------------------------------------------------------------
class AISection extends ConsumerWidget {
  const AISection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    if (!_matchesSearch(ref, "AI Assistant Mode")) {
      return const SizedBox.shrink();
    }

    final mode =
        ref.watch(appConfigViewModelProvider.select((s) => s.aiPreference));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: strings.aiAssistantSection),
        SettingsCard(
          children: [
            _SettingTile(
              icon: EvaIcons.bulb_outline,
              title: strings.assistantMode,
              trailingText: mode == 'balanced' ? "Balanced" : "Max Accuracy",
              onTap: () => _SectionHelpers.showSelectionDialog(
                context,
                strings.assistantMode,
                ['Balanced', 'Max Accuracy'],
                mode == 'balanced' ? 'Balanced' : 'Max Accuracy',
                (val) => vm.setAiPreference(val == 'Balanced' ? 'balanced' : 'accuracy'),
              ),
            ),
            const _Divider(),
            _SettingTile(
              icon: EvaIcons.alert_triangle_outline,
              title: strings.reportAiIssue,
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'report@alkitab.app',
                  query:
                      'subject=Report: AI Assistant Issue&body=Please describe the issue you encountered with the AI Assistant:',
                );
                try {
                  await launchUrl(emailLaunchUri);
                } catch (e) {
                  debugPrint("Could not launch email: $e");
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 6. AUDIO SECTION
// -----------------------------------------------------------------------------
class AudioSection extends ConsumerWidget {
  const AudioSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    if (!_matchesSearch(ref, "Audio Reciter Playback Speed")) {
      return const SizedBox.shrink();
    }

    final reciterId = ref.watch(
        appConfigViewModelProvider.select((s) => s.selectedReciterIdentifier));
    final speed =
        ref.watch(appConfigViewModelProvider.select((s) => s.playbackSpeed));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: strings.audioSection),
        SettingsCard(
          children: [
            _SettingTile(
              icon: EvaIcons.mic_outline,
              title: strings.reciter,
              trailingText: reciterId ?? "Mishary", 
              onTap: () {
                 // Open reciter picker logic
              },
            ),
            const _Divider(),
            _SettingTile(
              icon: EvaIcons.music_outline,
              title: strings.playbackSpeed,
              trailingText: "${speed}x",
              onTap: () => _SectionHelpers.showSelectionDialog(
                context,
                strings.playbackSpeed,
                ['0.5', '0.75', '1.0', '1.25', '1.5', '2.0'],
                speed.toString(),
                (val) => vm.setPlaybackSpeed(double.parse(val)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 7. DATA SECTION (Stubbed Storage)
// -----------------------------------------------------------------------------
class DataSection extends ConsumerWidget {
  const DataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    if (!_matchesSearch(ref, "Data Storage Clear Cache")) {
      return const SizedBox.shrink();
    }
    
    final vm = ref.read(appConfigViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: strings.dataStorageSection),
        SettingsCard(
          children: [
            // Removed StorageManagementScreen for Web
            _SettingTile(
              icon: EvaIcons.trash_2_outline,
              title: strings.clearCache,
              onTap: () async {
                await vm.clearCache();
              },
            ),
          ],
        ),
      ],
    );
  }
}


// -----------------------------------------------------------------------------
// HELPER CLASSES (Copied)
// -----------------------------------------------------------------------------
List<Widget> _addDividers(List<Widget> tiles) {
  if (tiles.isEmpty) return [];
  final separated = <Widget>[];
  for (int i = 0; i < tiles.length; i++) {
    separated.add(tiles[i]);
    if (i < tiles.length - 1) {
      separated.add(const _Divider());
    }
  }
  return separated;
}

class _SectionHelpers {
  static void showSelectionDialog(BuildContext context, String title,
      List<String> options, String current, ValueChanged<String> onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(title,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...options.map((opt) => ListTile(
                    title: Text(opt),
                    trailing: opt == current
                        ? Icon(EvaIcons.checkmark_outline,
                            color: Theme.of(context).colorScheme.secondary)
                        : null,
                    onTap: () {
                      onSelect(opt);
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  static void showEditionsSheet({
    required BuildContext context,
    required String type,
    required AppConfigViewModel vm,
    required Map<String, String> progressMap,
    required Function(String) onDownload,
    required String title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (_, controller) {
            return Consumer(
              builder: (context, ref, _) {
                final editionsAsync = ref.watch(sortedEditionsProvider(type));

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: editionsAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text("Error: $e")),
                        data: (editions) {
                          return ListView.separated(
                            controller: controller,
                            itemCount: editions.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final edition = editions[index];
                              final isDownloaded = ref
                                      .watch(downloadedEditionIdsProvider)
                                      .value
                                      ?.contains(edition.identifier) ??
                                  false;
                              final isActive = ref
                                  .watch(appConfigViewModelProvider)
                                  .activeTranslationIdentifiers
                                  .contains(edition.identifier);

                              return ListTile(
                                title: Text(edition.name),
                                subtitle: Text(edition.englishName),
                                trailing: isDownloaded
                                    ? (isActive
                                        ? const Icon(
                                            EvaIcons.checkmark_circle_2,
                                            color: Colors.green)
                                        : ElevatedButton(
                                            onPressed: () {
                                              if (type == 'translation') {
                                                vm.addActiveTranslation(
                                                    edition.identifier);
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Select")))
                                    : (progressMap
                                            .containsKey(edition.identifier)
                                        ? Text(progressMap[edition.identifier]!,
                                            style:
                                                const TextStyle(fontSize: 10))
                                        : IconButton(
                                            icon: const Icon(EvaIcons
                                                .cloud_download_outline),
                                            onPressed: () =>
                                                onDownload(edition.identifier),
                                          )),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  const _SettingTile({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.colorScheme.onSurface),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.tertiary, fontSize: 12)),
                  ]
                ],
              ),
            ),
            if (trailingText != null)
              Text(trailingText!,
                  style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.tertiary, fontSize: 14)),
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: DirectionAwareIcon(EvaIcons.arrow_ios_forward_outline,
                    size: 14,
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.5)),
              )
          ],
        ),
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
    this.icon,
    required this.title,
    required this.value,
    required this.onChanged, this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: theme.colorScheme.onSurface),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.tertiary, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: theme.colorScheme.secondary,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isSelected
                ? Border.all(color: theme.colorScheme.outline)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 2)
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
    );
  }
}

class _FontSizeControl extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _FontSizeControl({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.labelLarge),
            Text("${value.round()}px",
                style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: theme.colorScheme.tertiary)),
          ],
        ),
        const SizedBox(height: 12),
        _GoldSlider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _GoldSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _GoldSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("A",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary)),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).colorScheme.outline,
              thumbColor: Theme.of(context).colorScheme.secondary,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        Text("A",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary)),
      ],
    );
  }
}
