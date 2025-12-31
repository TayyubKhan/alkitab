import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // We don't need to watch all providers here anymore!
    // The Sections will watch what they need.

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // --- HEADER ---
              _buildHeader(context),

              // --- SEARCH BAR ---
              // (Note: Functional search logic would filter the sections.
              // For now, keeping the UI as per refactor request to keep structure)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: "Search settings...",
                    hintStyle: TextStyle(color: colorScheme.tertiary),
                    prefixIcon: Icon(Icons.search, color: colorScheme.tertiary),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              // --- CONTENT ---
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  children: [
                    const GeneralSection(),
                    const SizedBox(height: 24),
                    const ReadingSection(),
                    const SizedBox(height: 24),
                    const ContentSection(),
                    const SizedBox(height: 24),
                    const WordByWordSection(),
                    const SizedBox(height: 24),
                    const AISection(),
                    const SizedBox(height: 24),
                    const AudioSection(),
                    const SizedBox(height: 24),
                    const DataSection(),

                    // FOOTER
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: colorScheme.secondary),
                                boxShadow: [
                                  BoxShadow(
                                      color: colorScheme.secondary
                                          .withOpacity(0.1),
                                      blurRadius: 20)
                                ]),
                            child: Icon(Icons.menu_book,
                                size: 32, color: colorScheme.secondary),
                          ),
                          const SizedBox(height: 16),
                          Text("Quran Journey",
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text("Version 1.0.0",
                              style: TextStyle(
                                  color: colorScheme.tertiary, fontSize: 12)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Made with ",
                                  style: TextStyle(
                                      color: colorScheme.tertiary,
                                      fontSize: 10)),
                              const Icon(Icons.favorite,
                                  color: Colors.red, size: 12),
                              Text(" for the Ummah",
                                  style: TextStyle(
                                      color: colorScheme.tertiary,
                                      fontSize: 10)),
                            ],
                          )
                        ],
                      ),
                    )
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          const Text("Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Done",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
