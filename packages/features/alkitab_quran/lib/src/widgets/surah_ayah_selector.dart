import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alkitab_models/alkitab_models.dart';
import 'package:alkitab_core/alkitab_core.dart'; // For Logger if needed
import '../viewmodels/quran_viewmodel.dart';
import '../l10n/quran_localizations.dart';

// Helper for number utility (or just use string interpolation if simple)
// Core doesn't have NumberUtils exposed yet. I'll just use simple string for now or reimplement localize.
// Or create NumberUtils in Core.
// For now, simple string sufficient for MVP parity, or use English.
// Or if NumberUtils.localize was just returning string, I can do it here.

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
  
  bool _isReady = false;
  List<int>? _cachedFilteredVerseIndices;

  @override
  void initState() {
    super.initState();
    _selectedSurah = widget.currentSurah;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isReady = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _verseSearchController.dispose();
    super.dispose();
  }
  
  List<int> _getFilteredVerseIndices() {
    if (_cachedFilteredVerseIndices != null) return _cachedFilteredVerseIndices!;
    
    if (_verseSearchQuery.isEmpty) {
        _cachedFilteredVerseIndices = List.generate(_selectedSurah.numberOfAyahs, (i) => i + 1);
    } else {
        final query = _verseSearchQuery;
        final list = <int>[];
        for (int i = 1; i <= _selectedSurah.numberOfAyahs; i++) {
            if (i.toString().contains(query)) {
                list.add(i);
            }
        }
        _cachedFilteredVerseIndices = list;
    }
    return _cachedFilteredVerseIndices!;
  }

  void _onVerseSearchChanged(String val) {
      setState(() {
          _verseSearchQuery = val;
          _cachedFilteredVerseIndices = null; 
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final strings = QuranLocalizations.of(context);

    // Fallbacks
    final s_surahs = strings?.surahs ?? 'Surahs';
    final s_juz = strings?.juz ?? 'Juz';
    final s_searchSurah = strings?.searchSurah ?? 'Search Surah';
    final s_search = strings?.search ?? 'Search';
    final s_ayah = strings?.ayah ?? 'Ayah';
    final s_verses = strings?.verses ?? 'Verses';

    final brandColor = colorScheme.secondary;
    final surahsAsync = ref.watch(surahListProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // DRAG HANDLE
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

          // TABS
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: brandColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              s_surahs,
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              s_juz,
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurface
                                    .withOpacity(0.6),
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
            child: !_isReady 
              ? Center(child: CircularProgressIndicator(color: brandColor))
              : surahsAsync.when(
              loading: () =>
                  Center(child: CircularProgressIndicator(color: brandColor)),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (allSurahs) {
                final filteredSurahs = allSurahs.where((s) {
                  final q = _searchQuery.toLowerCase();
                  return s.englishName.toLowerCase().contains(q) ||
                      s.englishNameTranslation.toLowerCase().contains(q) ||
                      s.number.toString() == q;
                }).toList();

                return Row(
                  children: [
                    // LEFT: SURAH LIST
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: colorScheme.outline
                                      .withOpacity(0.05))),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: Column(
                                children: [
                                  Text(s_surahs,
                                      style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _searchController,
                                    onChanged: (val) =>
                                        setState(() => _searchQuery = val),
                                    style: textTheme.bodyMedium,
                                    decoration: InputDecoration(
                                      hintText: s_searchSurah,
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
                                        _cachedFilteredVerseIndices = null; 
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
                                                            .withOpacity(
                                                                0.8)
                                                        : colorScheme.onSurface
                                                            .withOpacity(
                                                                0.5),
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

                    // RIGHT: AYAH LIST
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 16, 8),
                            child: Column(
                              children: [
                                Text(s_verses,
                                    style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _verseSearchController,
                                  onChanged: _onVerseSearchChanged,
                                  style: textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    hintText: s_search,
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
                            child: Builder(
                                builder: (context) {
                                    final verses = _getFilteredVerseIndices();
                                    return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.fromLTRB(8, 4, 12, 24),
                                      itemCount: verses.length,
                                      itemBuilder: (context, index) {
                                        final ayahNum = verses[index];

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
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 12),
                                                child: Text(
                                                  "$s_ayah $ayahNum",
                                                  textAlign: TextAlign.center,
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
                                    );
                                }
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
