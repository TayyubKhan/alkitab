import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab/l10n/gen/app_localizations.dart';
import '../../core/controllers/controllers.dart';
import '../../viewmodels/settings_viewmodel.dart';
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
    // Initialize with current query if any
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

    // Clear search on close (optional, but good UX)
    // We can't do it easily in dispose if the sheet is kept alive,
    // but typically bottom sheets are destroyed.

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
                    GeneralSection(),
                    SizedBox(height: 16),
                    ReadingSection(),
                    SizedBox(height: 16),
                    ContentSection(),
                    SizedBox(height: 16),
                    WordByWordSection(),
                    SizedBox(height: 16),
                    AISection(),
                    SizedBox(height: 16),
                    AudioSection(),
                    SizedBox(height: 16),
                    DataSection(),

                    // Minimal Footer
                    SizedBox(height: 32),
                    Center(
                        child: Text("${AppLocalizations.of(context)!.version} 1.0.0",
                            style:
                                TextStyle(fontSize: 10, color: Colors.grey))),
                    SizedBox(height: 16),
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
