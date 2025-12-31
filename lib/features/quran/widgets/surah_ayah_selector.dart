import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/quran_models.dart';
import '../../../../viewmodels/quran_viewmodel.dart';

class SurahAyahSelector extends ConsumerStatefulWidget {
  final Surah currentSurah;
  final void Function(Surah surah, int ayahNumber) onSelection;

  const SurahAyahSelector({
    super.key,
    required this.currentSurah,
    required this.onSelection,
  });

  @override
  ConsumerState<SurahAyahSelector> createState() => _SurahAyahSelectorState();
}

class _SurahAyahSelectorState extends ConsumerState<SurahAyahSelector> {
  late Surah _selectedSurah;
  String _searchQuery = "";
  String _verseSearchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _verseSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSurah = widget.currentSurah;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _verseSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Use theme color
    final brandColor = colorScheme.secondary;

    // Fetch all Surahs
    final surahsAsync = ref.watch(surahListProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.90, // Taller sheet
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          // 1. DRAG HANDLE
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 2. HEADER TABS (Surahs / Juz)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: brandColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Surahs Tab (Active)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: brandColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: brandColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Text(
                              "Surahs (Chapters)",
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Juz Tab (Inactive)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Juz (Para)",
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: surahsAsync.when(
              loading: () =>
                  Center(child: CircularProgressIndicator(color: brandColor)),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (allSurahs) {
                // Filter Surahs
                final filteredSurahs = allSurahs.where((s) {
                  final q = _searchQuery.toLowerCase();
                  return s.englishName.toLowerCase().contains(q) ||
                      s.englishNameTranslation.toLowerCase().contains(q) ||
                      s.number.toString() == q;
                }).toList();

                return Row(
                  children: [
                    // --- LEFT: SURAH LIST (45% -> Expanded 5) ---
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color:
                                      colorScheme.outline.withOpacity(0.05))),
                        ),
                        child: Column(
                          children: [
                            // Header & Search
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: Column(
                                children: [
                                  Text("Surahs",
                                      style: textTheme.titleMedium?.copyWith(
                                          fontFamily:
                                              'Caveat', // Or handwritten style if available, else standard
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _searchController,
                                    onChanged: (val) =>
                                        setState(() => _searchQuery = val),
                                    style: textTheme.bodyMedium,
                                    decoration: InputDecoration(
                                      hintText: "Search surah",
                                      hintStyle: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.4)),
                                      filled: true,
                                      fillColor: colorScheme
                                          .surfaceContainerHighest
                                          .withOpacity(0.3),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12),
                                      isDense: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // List
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                addAutomaticKeepAlives: true,
                                padding:
                                    const EdgeInsets.only(bottom: 24, top: 4),
                                itemCount: filteredSurahs.length,
                                itemBuilder: (context, index) {
                                  final surah = filteredSurahs[index];
                                  final isSelected =
                                      surah.number == _selectedSurah.number;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedSurah = surah;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? brandColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? colorScheme.onSecondary
                                                      .withOpacity(0.2)
                                                  : colorScheme
                                                      .surfaceContainerHighest,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${surah.number}",
                                              style: textTheme.labelSmall
                                                  ?.copyWith(
                                                color: isSelected
                                                    ? colorScheme.onSecondary
                                                    : colorScheme.onSurface
                                                        .withOpacity(0.6),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  surah.englishName,
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelected
                                                        ? colorScheme
                                                            .onSecondary
                                                        : colorScheme.onSurface,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  surah.englishNameTranslation,
                                                  style: textTheme.labelSmall
                                                      ?.copyWith(
                                                    fontSize: 9,
                                                    color: isSelected
                                                        ? colorScheme
                                                            .onSecondary
                                                            .withOpacity(0.8)
                                                        : colorScheme.onSurface
                                                            .withOpacity(0.5),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
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
                    ),

                    // --- RIGHT: AYAH LIST (Expanded 7) ---
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          // Header & Search
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 16, 8),
                            child: Column(
                              children: [
                                Text("Verses",
                                    style: textTheme.titleMedium?.copyWith(
                                        fontFamily: 'Caveat',
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _verseSearchController,
                                  onChanged: (val) =>
                                      setState(() => _verseSearchQuery = val),
                                  style: textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.4)),
                                    filled: true,
                                    fillColor: colorScheme
                                        .surfaceContainerHighest
                                        .withOpacity(0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 12),
                                    isDense: true,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(8, 4, 12, 24),
                              itemCount: _selectedSurah.numberOfAyahs,
                              itemBuilder: (context, index) {
                                final ayahNum = index + 1;

                                // Filter verses
                                if (_verseSearchQuery.isNotEmpty) {
                                  if (!ayahNum
                                      .toString()
                                      .contains(_verseSearchQuery)) {
                                    return const SizedBox.shrink();
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => widget.onSelection(
                                          _selectedSurah, ayahNum),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: double.infinity,
                                        // Center alignment for content
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          // Optional: Highlight if it was the *current* ayah, but for now just clean list
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Verse $ayahNum",
                                          textAlign: TextAlign
                                              .center, // Ensure text is centered
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
