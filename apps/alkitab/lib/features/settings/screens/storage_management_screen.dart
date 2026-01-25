import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodels/storage_viewmodel.dart';
import '../../settings/widgets/settings_widgets.dart';

class StorageManagementScreen extends ConsumerWidget {
  const StorageManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(storageViewModelProvider);
    final notifier = ref.read(storageViewModelProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Storage Management", style: theme.textTheme.headlineSmall),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error loading storage info: $e")),
        data: (stats) {
          return RefreshIndicator(
            onRefresh: () => notifier.refresh(),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // 1. TOTAL SUMMARY CARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text("Total Used Storage",
                              style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onSecondaryContainer)),
                          const SizedBox(height: 8),
                          Text(stats.formattedTotal,
                              style: theme.textTheme.displayMedium?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. SYSTEM DATA (DB + Cache)
                const SectionHeader(title: "System Data"),
                SettingsCard(
                  children: [
                    ListTile(
                      leading: Icon(Icons.storage, color: colorScheme.tertiary),
                      title: const Text("Database"),
                      subtitle: const Text("Translations, Text, Metadata"),
                      trailing: Text(stats.formattedDatabase,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.cached, color: colorScheme.tertiary),
                      title: const Text("App Cache"),
                      subtitle: const Text("Temporary files"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(stats.formattedCache,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          if (stats.cacheBytes > 0)
                            IconButton(
                              icon: Icon(Icons.delete_outline,
                                  color: colorScheme.error),
                              onPressed: () {
                                _confirmDelete(context, "Clear Cache?",
                                    "This will remove temporary files.", () {
                                  notifier.clearCache();
                                });
                              },
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. AUDIO DOWNLOADS
                const SectionHeader(title: "Downloaded Audio"),
                if (stats.reciters.isEmpty)
                  SettingsCard(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: Text("No audio downloaded yet.",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                      )
                    ],
                  )
                else
                  SettingsCard(
                    children: stats.reciters.map((reciter) {
                      return Column(children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.surface,
                              child: Icon(Icons.mic,
                                  color: colorScheme.primary, size: 20),
                            ),
                            title: Text(reciter.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "${reciter.surahs.length} Surahs • ${reciter.formattedSize}"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Delete all for this reciter?",
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                                color: colorScheme.error)),
                                    TextButton.icon(
                                      onPressed: () {
                                        _confirmDelete(
                                            context,
                                            "Delete All?",
                                            "Remove all audio for ${reciter.name}?",
                                            () => notifier
                                                .deleteReciter(reciter.id));
                                      },
                                      icon: const Icon(Icons.delete_forever,
                                          size: 16),
                                      label: const Text("DELETE ALL"),
                                      style: TextButton.styleFrom(
                                          foregroundColor: colorScheme.error),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              ...reciter.surahs.map((surah) {
                                return ListTile(
                                  dense: true,
                                  title: Text("Surah ${surah.number}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(surah.formattedSize,
                                          style: TextStyle(
                                              color: colorScheme.tertiary,
                                              fontSize: 12)),
                                      IconButton(
                                        icon: Icon(Icons.close,
                                            size: 16, color: colorScheme.error),
                                        onPressed: () {
                                          notifier.deleteSurahAudio(
                                              reciter.id, surah.number);
                                        },
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        if (reciter != stats.reciters.last)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ]);
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String title, String content,
      VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }
}
