import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qudwa/data/models/quran_models.dart';
import 'package:qudwa/viewmodels/settings_viewmodel.dart';
import 'package:qudwa/viewmodels/quran_viewmodel.dart';
import 'font_preview_card.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "GENERAL"),
        _SettingsCard(
          children: [
            _SettingTile(
              icon: Icons.language,
              title: "App Language",
              trailingText: language,
              onTap: () => _SectionHelpers.showSelectionDialog(
                context,
                "Select Language",
                ['English', 'Urdu', 'Arabic', 'Indonesian', 'French'],
                language,
                (val) => vm.setAppLanguage(val),
              ),
            ),
            const _Divider(),
            _SettingToggle(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              value: isDark,
              onChanged: (v) => vm.toggleTheme(v),
            ),
          ],
        ),
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
    // Watch specific props
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "READING"),
        _SettingsCard(
          children: [
            _SettingToggle(
              icon: Icons.notes,
              title: "Show Arabic Text",
              value: showArabic,
              onChanged: (v) => vm.setShowArabic(v),
            ),
            const _Divider(),

            // FONT PREVIEW (Isolated Widget)
            const FontPreviewCard(),

            // Font Style Segment Control
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Arabic Font Style", style: theme.textTheme.labelLarge),
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
            const _Divider(),

            // Font Size Sliders
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FontSizeControl(
                      label: "Font Size",
                      value: arabicFontSize,
                      min: 20,
                      max: 60,
                      onChanged: (v) => vm.setArabicFontSize(v)),
                  const SizedBox(height: 16),
                  _FontSizeControl(
                      label: "Translation Font Size",
                      value: translationFontSize,
                      min: 10,
                      max: 30,
                      onChanged: (v) => vm.setTranslationFontSize(v)),
                  const SizedBox(height: 16),
                  _FontSizeControl(
                      label: "Tafsir Font Size",
                      value: tafsirFontSize,
                      min: 10,
                      max: 30,
                      onChanged: (v) => vm.setTafsirFontSize(v)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 3. CONTENT SECTION (Translations & Tafsirs)
// -----------------------------------------------------------------------------
class ContentSection extends ConsumerStatefulWidget {
  const ContentSection({super.key});

  @override
  ConsumerState<ContentSection> createState() => _ContentSectionState();
}

class _ContentSectionState extends ConsumerState<ContentSection> {
  // Local state for download progress to avoid global rebuilds
  final Map<String, String> _downloadProgress = {};

  Future<void> _downloadEdition(
      String id, String type, AppConfigViewModel vm) async {
    if (_downloadProgress.containsKey(id)) return;

    setState(() {
      _downloadProgress[id] = "Starting...";
    });

    try {
      await vm.downloadEdition(id, (msg) {
        if (mounted) {
          setState(() {
            _downloadProgress[id] = msg;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Download failed for $id")));
      }
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
    final isTranslationOnly = ref
        .watch(appConfigViewModelProvider.select((s) => s.isTranslationOnly));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    // We need to pass config to the list items (active IDs)
    // We can watch just the active IDs for the lists
    // Actually the Provider below watches 'config' inside it? No, we need to pass props.

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "CONTENT"),
        _SettingsCard(
          children: [
            _SettingToggle(
              title: "Translation Only Mode",
              subtitle: "Hide all Arabic and focus on meaning",
              value: isTranslationOnly,
              onChanged: (v) => vm.setTranslationOnly(v),
            ),
            const _Divider(),
            _EditionList(
              title: "Translations",
              type: 'translation',
              downloadProgress: _downloadProgress,
              onDownload: (id) => _downloadEdition(id, 'translation', vm),
            ),
            const _Divider(),
            _EditionList(
              title: "Tafsirs",
              type: 'tafsir',
              downloadProgress: _downloadProgress,
              onDownload: (id) => _downloadEdition(id, 'tafsir', vm),
            ),
          ],
        )
      ],
    );
  }
}

class _EditionList extends ConsumerWidget {
  final String title;
  final String type;
  final Map<String, String> downloadProgress;
  final Function(String) onDownload;

  const _EditionList({
    required this.title,
    required this.type,
    required this.downloadProgress,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get Sorted List from Logic Layer
    final editionsAsync = ref.watch(sortedEditionsProvider(type));

    // 2. Get Active IDs
    final activeIds = ref.watch(appConfigViewModelProvider
        .select((s) => s.activeTranslationIdentifiers));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    return editionsAsync.when(
      data: (editions) {
        return ExpansionTile(
          title: Text(title, style: Theme.of(context).textTheme.labelLarge),
          subtitle: Text("${editions.length} available",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary, fontSize: 12)),
          children: editions.map((edition) {
            // We need to know if it's downloaded. The Sorting Provider used downloadedIds,
            // but didn't return them. Use a separate check or assume sorted list implies intent?
            // Actually, we need to show checkboxes for downloaded items and download buttons for others.
            // We should watch downloadedIds again here or trust the UI logic.
            // Let's watch downloadedIds to be correct.
            final downloadedIds =
                ref.watch(downloadedEditionIdsProvider).asData?.value ?? {};

            final isDownloaded = downloadedIds.contains(edition.identifier);
            final isActive = activeIds.contains(edition.identifier);
            final progress = downloadProgress[edition.identifier];

            if (isDownloaded) {
              return _CheckboxTile(
                title: edition.name,
                subtitle: edition.englishName,
                value: isActive,
                onChanged: (val) {
                  if (val == true) {
                    vm.addActiveTranslation(edition.identifier);
                  } else {
                    vm.removeActiveTranslation(edition.identifier);
                  }
                },
              );
            } else {
              return ListTile(
                title: Text(edition.name),
                subtitle: Text(edition.englishName),
                trailing: progress != null
                    ? SizedBox(
                        width: 90,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                                width: 12,
                                height: 12,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(progress,
                                    style: const TextStyle(fontSize: 10),
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.cloud_download_outlined),
                        onPressed: () => onDownload(edition.identifier),
                      ),
              );
            }
          }).toList(),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Error loading editions"),
      ),
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
    final enabled = ref
        .watch(appConfigViewModelProvider.select((s) => s.isDirectWBWEnabled));
    final language =
        ref.watch(appConfigViewModelProvider.select((s) => s.wbwLanguage));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "WORD BY WORD"),
        _SettingsCard(
          children: [
            _SettingToggle(
              title: "Enable WBW",
              value: enabled,
              onChanged: (v) => vm.setDirectWBW(v),
            ),
            if (enabled) ...[
              const _Divider(),
              _SettingTile(
                title: "WBW Language",
                trailingText: language,
                onTap: () => _SectionHelpers.showSelectionDialog(
                  context,
                  "WBW Language",
                  ['English', 'Urdu', 'Hindi', 'Indonesian', 'Bengali'],
                  language,
                  (val) => vm.setWbwLanguage(val),
                ),
              ),
            ]
          ],
        )
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 5. AI SECTION
// -----------------------------------------------------------------------------
class AISection extends ConsumerWidget {
  const AISection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pref =
        ref.watch(appConfigViewModelProvider.select((s) => s.aiPreference));
    final vm = ref.read(appConfigViewModelProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "ARTIFICIAL INTELLIGENCE"),
        _SettingsCard(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("AI Preference", style: theme.textTheme.labelLarge),
                  const SizedBox(height: 12),
                  _RadioItem(
                    label: "Balanced (Recommended)",
                    isSelected: pref == 0,
                    onTap: () => vm.setAiPreference(0),
                  ),
                  const SizedBox(height: 8),
                  _RadioItem(
                    label: "Maximum Accuracy (Slower)",
                    isSelected: pref == 1,
                    onTap: () => vm.setAiPreference(1),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.lock, size: 12, color: colorScheme.tertiary),
                      const SizedBox(width: 4),
                      Text("No personal data is sent to external servers.",
                          style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.tertiary,
                              fontStyle: FontStyle.italic)),
                    ],
                  )
                ],
              ),
            )
          ],
        )
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
    final allReciters = ref.watch(allRecitersProvider).asData?.value ?? [];
    final selectedId = ref.watch(
        appConfigViewModelProvider.select((s) => s.selectedReciterIdentifier));
    final playbackSpeed =
        ref.watch(appConfigViewModelProvider.select((s) => s.playbackSpeed));

    final vm = ref.read(appConfigViewModelProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "AUDIO"),
        _SettingsCard(
          children: [
            ExpansionTile(
              title: Text("Reciter", style: theme.textTheme.labelLarge),
              subtitle: Text(
                  _SectionHelpers.getReciterName(allReciters, selectedId),
                  style: TextStyle(
                      color: theme.colorScheme.secondary, fontSize: 12)),
              children: allReciters.map((reciter) {
                return RadioListTile<String>(
                  title: Text(reciter.name),
                  subtitle: Text(reciter.englishName),
                  value: reciter.identifier,
                  groupValue: selectedId,
                  onChanged: (val) {
                    if (val != null) vm.setSelectedReciter(val);
                  },
                  activeColor: theme.colorScheme.secondary,
                  dense: true,
                );
              }).toList(),
            ),
            const _Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Playback Speed", style: theme.textTheme.labelLarge),
                      Text("${playbackSpeed.toStringAsFixed(1)}x",
                          style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: colorScheme.tertiary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text("0.5x",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.tertiary)),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: colorScheme.secondary,
                            inactiveTrackColor: colorScheme.outline,
                            thumbColor: colorScheme.secondary,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            trackHeight: 2,
                          ),
                          child: Slider(
                            value: playbackSpeed,
                            min: 0.5,
                            max: 2.0,
                            divisions: 6,
                            onChanged: (v) => vm.setPlaybackSpeed(v),
                          ),
                        ),
                      ),
                      Text("2.0x",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.tertiary)),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 7. DATA SECTION
// -----------------------------------------------------------------------------
class DataSection extends ConsumerWidget {
  const DataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheSizeAsync = ref.watch(cacheSizeProvider);
    final vm = ref.read(appConfigViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "DATA & STORAGE"),
        _SettingsCard(
          children: [
            ListTile(
              onTap: () async {
                await vm.clearCache();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cache Cleared Successfully")),
                  );
                }
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text("Clear Cache",
                  style: TextStyle(
                      color: colorScheme.error, fontWeight: FontWeight.w600)),
              trailing: cacheSizeAsync.when(
                data: (size) => Text(size,
                    style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: colorScheme.tertiary)),
                loading: () => const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                error: (_, __) => const Text("ERR"),
              ),
            )
          ],
        )
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER CLASSES & WIDGETS
// -----------------------------------------------------------------------------

class _SectionHelpers {
  static void showSelectionDialog(BuildContext context, String title,
      List<String> options, String current, Function(String) onSelect) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final opt = options[index];
                      return ListTile(
                        title: Text(opt),
                        trailing: opt == current
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          onSelect(opt);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  static String getReciterName(List<Reciter> list, String? id) {
    if (id == null) return "Select Reciter";
    if (list.isEmpty) return "Loading...";
    return list
        .firstWhere((r) => r.identifier == id,
            orElse: () => Reciter(
                identifier: '', language: '', name: 'Unknown', englishName: ''))
        .name;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const _SettingTile({
    this.icon,
    required this.title,
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
                ],
              ),
            ),
            if (trailingText != null)
              Text(trailingText!,
                  style: TextStyle(
                      color: theme.colorScheme.tertiary, fontSize: 14)),
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.arrow_forward_ios,
                    size: 14,
                    color: theme.colorScheme.tertiary.withOpacity(0.5)),
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
    required this.onChanged,
    this.subtitle,
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
                      style: TextStyle(
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
                        color: Colors.black.withOpacity(0.1), blurRadius: 2)
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

class _CheckboxTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckboxTile({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CheckboxListTile(
      title: Text(title,
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(color: theme.colorScheme.tertiary, fontSize: 12))
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: theme.colorScheme.secondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
    );
  }
}

class _RadioItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioItem(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? theme.colorScheme.secondary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.tertiary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: theme.colorScheme.onSurface, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Theme.of(context).colorScheme.outline);
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
