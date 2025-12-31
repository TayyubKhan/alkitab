import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/quran_models.dart';
import '../../../data/repositories/quran_repository.dart';
import '../../../viewmodels/quran_viewmodel.dart';
import 'ayah_list_screen.dart';

// -----------------------------------------------------------------------------
// SEARCH DELEGATE (Void & Gold)
// -----------------------------------------------------------------------------

class QuranSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  QuranSearchDelegate({required this.ref});

  // 1. THEME STYLING
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return theme.copyWith(
      // Ensure the search bar matches the "Void" aesthetic
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface, // #121212 or White
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        toolbarHeight: 70, // Slightly taller for better touch targets
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.tertiary, // Muted Grey
          fontSize: 18,
        ),
      ),
      // Text selection and cursor colors
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.secondary, // Gold Cursor
        selectionColor: colorScheme.secondary.withOpacity(0.3),
        selectionHandleColor: colorScheme.secondary,
      ),
      textTheme: textTheme.copyWith(
        titleLarge: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
          fontSize: 18,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  // 2. ACTIONS
  @override
  List<Widget>? buildActions(BuildContext context) {
    final theme = Theme.of(context);
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, color: theme.colorScheme.tertiary),
          onPressed: () => query = '',
        ),
    ];
  }

  // 3. LEADING
  @override
  Widget? buildLeading(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
      onPressed: () => close(context, null),
    );
  }

  // 4. RESULTS
  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  // 5. SUGGESTIONS
  @override
  Widget buildSuggestions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // --- EMPTY STATE ---
    if (query.trim().length < 3) {
      return Container(
        color: theme.scaffoldBackgroundColor, // Void Black
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search,
                  size: 64, color: colorScheme.tertiary.withOpacity(0.2)),
              const SizedBox(height: 16),
              Text(
                "Type at least 3 characters...",
                style:
                    textTheme.bodyMedium?.copyWith(color: colorScheme.tertiary),
              ),
            ],
          ),
        ),
      );
    }

    final searchAsync = ref.watch(quranSearchProvider(query));

    return Container(
      color: theme.scaffoldBackgroundColor, // Void Black
      child: searchAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.secondary)),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (results) {
          if (results.isEmpty) {
            return Center(
              child: Text("No matches found.",
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.tertiary)),
            );
          }

          return ListView.separated(
            itemCount: results.length,
            // Subtle Divider
            separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: colorScheme.outline),
            itemBuilder: (context, index) {
              final result = results[index];
              final isArabicMatch =
                  RegExp(r'[\u0600-\u06FF]').hasMatch(result.text);

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book_rounded,
                        color: colorScheme.secondary
                            .withOpacity(0.7)), // Gold Book Icon
                  ],
                ),
                title: Text(
                  result.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  // --- TYPOGRAPHY LOGIC ---
                  style: isArabicMatch
                      ? textTheme.displayLarge
                          ?.copyWith(fontSize: 22, height: 1.8) // Quran Font
                      : textTheme.bodyLarge
                          ?.copyWith(height: 1.4), // Inter Font
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      // Tag Style
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surface, // Surface Color
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Text(
                          "${result.surahEnglishName} : ${result.ayahNumber}",
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.secondary, // Gold Text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (result.translationId != null) ...[
                        const SizedBox(width: 8),
                        Text("Translation",
                            style: textTheme.labelSmall
                                ?.copyWith(color: colorScheme.tertiary)),
                      ]
                    ],
                  ),
                ),
                onTap: () => _handleResultTap(context, result),
              );
            },
          );
        },
      ),
    );
  }

  void _handleResultTap(BuildContext context, QuranSearchResult result) {
    final surahList = ref.read(surahListProvider).asData?.value;

    if (surahList != null) {
      final surah = surahList.firstWhere(
        (s) => s.number == result.surahNumber,
        orElse: () => surahList.first,
      );

      close(context, null);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AyahListScreen(
            surah: surah,
            initialAyah: result.ayahNumber,
          ),
        ),
      );
    }
  }
}

// -----------------------------------------------------------------------------
// SEARCH PROVIDER
// -----------------------------------------------------------------------------
final quranSearchProvider = FutureProvider.family
    .autoDispose<List<QuranSearchResult>, String>((ref, query) async {
  return ref.read(quranRepositoryProvider).searchAyahs(query);
});
