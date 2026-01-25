import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab_web/l10n/gen/app_localizations.dart';
import 'package:alkitab_core/alkitab_core.dart';
import 'widgets/settings_sections.dart';

class SettingsBottomSheet extends ConsumerStatefulWidget {
  const SettingsBottomSheet({super.key});

  @override
  ConsumerState<SettingsBottomSheet> createState() =>
      _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends ConsumerState<SettingsBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(settingsSearchQueryProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.bottomSheetTheme.backgroundColor ??
                theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // --- HEADER ---
              _buildHeader(context),

              // --- SEARCH BAR ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyLarge,
                  onChanged: (val) {
                    ref.read(settingsSearchQueryProvider.notifier).setQuery(val);
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchSettings,
                    prefixIcon: Icon(EvaIcons.search_outline,
                        color: theme.inputDecorationTheme.hintStyle?.color),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(EvaIcons.close_circle_outline),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(settingsSearchQueryProvider.notifier)
                                  .setQuery('');
                              setState(() {});
                            },
                          )
                        : null,
                  ).applyDefaults(theme.inputDecorationTheme),
                ),
              ),

              // --- CONTENT ---
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  children: [
                    const GeneralSection(),
                    const SizedBox(height: 16),
                    const ReadingSection(),
                    const SizedBox(height: 16),
                    const ContentSection(),
                    const SizedBox(height: 16),
                    const WordByWordSection(),
                    const SizedBox(height: 16),
                    const AISection(),
                    const SizedBox(height: 16),
                    const AudioSection(),
                    const SizedBox(height: 16),
                    const DataSection(),

                    // Minimal Footer
                    const SizedBox(height: 32),
                    Center(
                        child: Text("${AppLocalizations.of(context)!.version} 1.0.0",
                            style:
                                const TextStyle(fontSize: 10, color: Colors.grey))),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(EvaIcons.close_outline),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text(AppLocalizations.of(context)!.settingsTitle,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
