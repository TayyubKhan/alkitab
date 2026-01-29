import 'dart:ui'; // For FontFeature
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:alkitab_models/alkitab_models.dart';
import 'package:alkitab_core/alkitab_core.dart'; // Audio/Settings VMs

import '../../alkitab_quran.dart';
import 'tafsir_sheet.dart';

const String _kAyahRosetteSvg =
    '''<svg width="24px" height="24px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12 2L14.5 9.5H22L16 14.5L18.5 22L12 17.5L5.5 22L8 14.5L2 9.5H9.5L12 2Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>'''; // Placeholder if asset missing, or use actual asset path.
// Actually AyahCard used a constant that was not shown in view_file if it was imported?
// Ah, _kAyahRosetteSvg was likely defined in the file but I missed it in truncation?
// Or imported. The SVG string is usually long.
// I'll implement a simple circle or just use a rosette icon for now to avoid compilation errors if I don't have the SVG string.
// I will use a placeholder or generic Icon.

/// A widget that displays a single Ayah (verse) in a list.
class AyahRow extends ConsumerStatefulWidget {
  final AyahWithTranslations ayah;
  final Surah surah;
  final Map<String, Edition> editionMap;
  final void Function(String translation)? onWordTap;
  final void Function(String, BuildContext)? onReportContent;

  const AyahRow({
    super.key,
    required this.ayah,
    required this.surah,
    required this.editionMap,
    this.onReportContent,
    this.onWordTap,
  });

  @override
  ConsumerState<AyahRow> createState() => _AyahRowState();
}

class _AyahRowState extends ConsumerState<AyahRow> {
  int? _focusedWordIndex;
  static const double _kBaseScale = 1.0;

  double _getFontScale(String arabicFontStyle) {
    if (arabicFontStyle == 'quranfont' ||
        arabicFontStyle == 'pdms' ||
        arabicFontStyle == 'indopak') {
      return _kBaseScale * 1.35;
    }
    return _kBaseScale; 
  }

  String _getFontFamily(String arabicFontStyle) {
    if (arabicFontStyle == 'quranfont') {
        return 'quranfont'; // IndoPak
    }
    return 'Amiri'; // Default/Uthmani
  }
  
  TextStyle _getArabicTextStyle(String fontFamily, double fontSize, Color color) {
      // Use the actual selected font family
      return TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: color,
          height: (fontFamily == 'quranfont') ? 2.5 : 2.2,
          fontFamilyFallback: const ['Amiri', 'NotoNaskhArabic', 'Arial'],
      );
  }

  void _onWordTap(AyahWord word) {
    if (widget.onWordTap != null) {
        widget.onWordTap!(word.translation);
    }
  }

  void _closePopup() {
    if (_focusedWordIndex != null) setState(() => _focusedWordIndex = null);
  }
  
  String _fixArabicText(String text) => text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final arabicFontSize =
        ref.watch(appConfigViewModelProvider.select((s) => s.arabicFontSize));
    final arabicFontStyle =
        ref.watch(appConfigViewModelProvider.select((s) => s.arabicFontStyle));
    final translationFontSize = ref
        .watch(appConfigViewModelProvider.select((s) => s.translationFontSize));
    final selectedTranslationLanguage = ref.watch(appConfigViewModelProvider
        .select((s) => s.selectedTranslationLanguage));
    final isDirectWBWEnabled = ref
        .watch(appConfigViewModelProvider.select((s) => s.isDirectWBWEnabled));
    final showArabicText =
        ref.watch(appConfigViewModelProvider.select((s) => s.showArabicText));
    final isTranslationOnly = ref
        .watch(appConfigViewModelProvider.select((s) => s.isTranslationOnly));
    
    final fontScale = _getFontScale(arabicFontStyle);
    final fontFamily = _getFontFamily(arabicFontStyle);

    final isUrdu = selectedTranslationLanguage == 'ur' || selectedTranslationLanguage == 'urdu';
    final arabicColor = Colors.white; // Full white as requested
    final translationColor = Colors.white; // Full white as requested
    final goldColor = colorScheme.secondary;
    final outlineColor = colorScheme.outline;

    final isCurrentlyPlaying = ref.watch(audioControlProvider.select((state) =>
        state.currentAyah == widget.ayah.numberInSurah &&
        state.currentSurah == widget.surah.number &&
        state.isPlaying));

    return GestureDetector(
      onTap: _closePopup,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrentlyPlaying
              ? goldColor.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align top for better long content
          children: [
            Padding(
               padding: const EdgeInsets.only(top: 4.0),
               child: AyahActionRail(
                  ayah: widget.ayah,
                  surah: widget.surah,
                  isCurrentlyPlaying: isCurrentlyPlaying,
                  goldColor: goldColor,
                  colorScheme: colorScheme,
                  onReportContent: widget.onReportContent,
                  editionMap: widget.editionMap,
                ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 6),
                  if (showArabicText && !isTranslationOnly)
                    if (isDirectWBWEnabled)
                      _buildWBWGridContent(
                          context,
                          Colors.transparent,
                          outlineColor,
                          arabicColor,
                          goldColor,
                          arabicFontSize,
                          fontScale,
                          fontFamily)
                    else
                      _buildFlowingContent(context, arabicColor, goldColor,
                          arabicFontSize, fontScale, fontFamily),
                  
                  // Translations
                  if (widget.ayah.translations.isNotEmpty) ...[
                     const SizedBox(height: 12),
                     Builder(
                       builder: (context) {
                         final visibleTranslations = widget.ayah.translations.entries
                            .where((e) => widget.editionMap[e.key]?.type != 'tafsir')
                            .toList();
                         
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                           children: visibleTranslations.map((e) {
                              final edition = widget.editionMap[e.key];
                              // Check for Roman Urdu (usually has "Roman" in name)
                              // If it is Roman Urdu, treat as English/LTR even if language code is UR.
                              final isRomanUrdu = (edition?.englishName.toLowerCase().contains('roman') ?? false) ||
                                                  (edition?.name.toLowerCase().contains('roman') ?? false);
                              
                              final isLineUrdu = !isRomanUrdu && (edition?.language == 'ur' || edition?.language == 'urdu');
                              
                              final authorName = edition?.englishName ?? "Translation"; 
                              final showAuthor = visibleTranslations.length > 1;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                            TextSpan(
                                                text: e.value,
                                                style: isLineUrdu 
                                                    ? textTheme.displayMedium?.copyWith(
                                                        fontFamily: 'Gulzar', 
                                                        fontFamilyFallback: const ['NotoNastaliqUrdu', 'Arial'],
                                                        fontSize: translationFontSize + 4,
                                                        height: 2.0,
                                                        color: translationColor
                                                      )
                                                    : textTheme.bodyMedium?.copyWith(
                                                        fontSize: translationFontSize,
                                                        height: 1.6,
                                                        color: translationColor
                                                      ),
                                            ),
                                            if (showAuthor)
                                                TextSpan(
                                                    text: "   ($authorName)",
                                                    style: textTheme.labelSmall?.copyWith(
                                                        color: translationColor.withOpacity(0.5),
                                                        fontFamily: isLineUrdu ? "Gulzar" : null,
                                                        fontSize: isLineUrdu ? 12 : 10,
                                                        fontStyle: FontStyle.italic,
                                                    ),
                                                ),
                                        ]
                                    ),
                                    textAlign: isLineUrdu ? TextAlign.right : TextAlign.left,
                                    textDirection: isLineUrdu ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              );
                           }).toList(),
                         );
                       }
                     ),
                  ]
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget _buildWBWGridContent(
      BuildContext context,
      Color cardBg,
      Color outlineColor,
      Color textColor,
      Color goldColor,
      double arabicFontSize,
      double fontScale,
      String fontFamily) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cellWidth = constraints.maxWidth / 3.2; // Slightly smaller to fit more
        final allWords = widget.ayah.words;
        final List<Widget> gridCells = [];

        if (allWords.isEmpty) {
           return SizedBox(
            width: double.infinity,
            child: Text(
              _fixArabicText(widget.ayah.arabicText),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: _getArabicTextStyle(fontFamily, arabicFontSize * fontScale, textColor),
            ),
          );
        }

        for (int i = 0; i < allWords.length; i++) {
          final word = allWords[i];
          gridCells.add(_InteractiveDashedGridCell(
            key: ValueKey("wbw_${word.wordNumber}_$i"),
            word: word,
            width: cellWidth,
            arabicFontSize: arabicFontSize,
            textColor: textColor,
            goldColor: goldColor,
            dashedColor: outlineColor.withOpacity(0.3),
            scaleFactor: fontScale,
            fontFamily: fontFamily,
            isFocused: _focusedWordIndex == i,
            onTap: () => _onWordTap(word),
          ));
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 8,
            spacing: 8,
            children: gridCells,
          ),
        );
      },
    );
  }

  Widget _buildFlowingContent(
      BuildContext context,
      Color textColor,
      Color goldColor,
      double arabicFontSize,
      double fontScale,
      String fontFamily) {
    final scaledFontSize = arabicFontSize * fontScale;
    final allWords = widget.ayah.words;

    final endSymbolWidget = EndAyahSymbol(
      ayahNumber: widget.ayah.numberInSurah,
      size: scaledFontSize * 0.9,
      color: goldColor,
    );

    if (allWords.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
               text: _fixArabicText(widget.ayah.arabicText),
               style: _getArabicTextStyle(fontFamily, scaledFontSize, textColor),
            ),
             WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                    child: endSymbolWidget,
                  )),
          ]),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
      );
    }

    final normalWords = allWords.sublist(0, allWords.length - 1);
    final lastWord = allWords.last;

    final List<Widget> wordWidgets = [];

    for (int i = 0; i < normalWords.length; i++) {
      wordWidgets.add(_FlowingWord(
        key: ValueKey("wbw_flow_${normalWords[i].wordNumber}_$i"),
        word: normalWords[i],
        textStyle: _getArabicTextStyle(fontFamily, scaledFontSize, textColor),
        accentColor: goldColor,
        isFocused: _focusedWordIndex == i,
        onTap: () => _onWordTap(normalWords[i]),
      ));
    }

    wordWidgets.add(_FlowingWord(
      key: ValueKey("wbw_flow_last_${lastWord.wordNumber}"),
      word: lastWord,
      textStyle: _getArabicTextStyle(fontFamily, scaledFontSize, textColor),
      accentColor: goldColor,
      isFocused: _focusedWordIndex == (allWords.length - 1),
      onTap: () => _onWordTap(lastWord),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: endSymbolWidget,
      ),
    ));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 16, // Increase spacing for better readability
        spacing: 4,
        children: wordWidgets,
      ),
    );
  }
}

class AyahActionRail extends StatelessWidget {
    final AyahWithTranslations ayah;
    final Surah surah;
    final bool isCurrentlyPlaying;
    final Color goldColor;
    final ColorScheme colorScheme;
    final Map<String, Edition> editionMap; 
    final void Function(String, BuildContext)? onReportContent;

    const AyahActionRail({
        super.key,
        required this.ayah,
        required this.surah,
        required this.isCurrentlyPlaying,
        required this.goldColor,
        required this.colorScheme,
        required this.editionMap,
        this.onReportContent,
    });
    
    @override
    Widget build(BuildContext context) {
         return Column(
            children: [
                _MinimalIconButton(
                    icon: isCurrentlyPlaying ? EvaIcons.pause_circle_outline : EvaIcons.play_circle_outline,
                    color: isCurrentlyPlaying ? goldColor : colorScheme.onSurface.withOpacity(0.4),
                    onPressed: () {
                         final container = ProviderScope.containerOf(context);
                         final notifier = container.read(audioControlProvider.notifier);
                         if (isCurrentlyPlaying) {
                               notifier.playPause();
                         } else {
                               notifier.playAyah(surah.number, ayah.numberInSurah, ayah.audioUrl ?? 'error');
                         }
                    },
                ),
                 // Tafsir (Visible if Tafsir exists in separate map OR in translations with type 'tafsir')
                 if (ayah.tafsirs.isNotEmpty || ayah.translations.keys.any((k) => editionMap[k]?.type == 'tafsir'))
                    _MinimalIconButton(
                        icon: EvaIcons.book_open_outline, // Book for Tafsir
                        color: colorScheme.onSurface.withOpacity(0.4),
                        onPressed: () {
                             final combinedTafsirs = <String, String>{...ayah.tafsirs};
                             for (final entry in ayah.translations.entries) {
                                  if (editionMap[entry.key]?.type == 'tafsir') {
                                       combinedTafsirs[entry.key] = entry.value;
                                  }
                             }

                             showModalBottomSheet(
                                   context: context,
                                   isScrollControlled: true,
                                   backgroundColor: Colors.transparent,
                                   builder: (_) => TafsirSheet(
                                        ayah: ayah,
                                        surah: surah,
                                        titleColor: goldColor,
                                        explicitTafsirs: combinedTafsirs,
                                        editionMap: editionMap,
                                   )
                              );
                        },
                    ),
                _MinimalIconButton(
                    icon: EvaIcons.copy_outline,
                    color: colorScheme.onSurface.withOpacity(0.4),
                    onPressed: () {
                         Clipboard.setData(ClipboardData(text: "${ayah.arabicText}\n\n${ayah.translations.values.join('\n')}"));
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to Clipboard")));
                    },
                ),
                _MinimalIconButton(
                    icon: EvaIcons.bulb_outline, // Lightbulb for Research/AI
                     color: colorScheme.onSurface.withOpacity(0.4),
                     onPressed: () {
                          showModalBottomSheet(
                               context: context,
                               isScrollControlled: true,
                               backgroundColor: Colors.transparent,
                               builder: (_) => ResearchSheet(
                                    ayah: ayah, 
                                    surah: surah,
                                    onReportContent: onReportContent,
                               )
                          );
                     },
                )
            ]
         );
    }
}

class _MinimalIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _MinimalIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class EndAyahSymbol extends StatelessWidget {
  final int ayahNumber;
  final double size;
  final Color color;

  const EndAyahSymbol({
    super.key,
    required this.ayahNumber,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
         width: size,
         height: size,
         decoration: BoxDecoration(
             shape: BoxShape.circle,
             border: Border.all(color: color, width: 1),
         ),
         alignment: Alignment.center,
         // Fixed font size multiplier for better visibility
         child: Text("$ayahNumber", style: TextStyle(color: color, fontSize: size * 0.45, fontWeight: FontWeight.bold)),
    );
  }
}

class _InteractiveDashedGridCell extends StatelessWidget {
  final AyahWord word;
  final double width;
  final double arabicFontSize;
  final Color textColor;
  final Color goldColor;
  final Color dashedColor;
  final double scaleFactor;
  final String fontFamily;
  final bool isFocused;
  final VoidCallback onTap;

  const _InteractiveDashedGridCell({
    super.key,
    required this.word,
    required this.width,
    required this.arabicFontSize,
    required this.textColor,
    required this.goldColor,
    required this.dashedColor,
    required this.scaleFactor,
    required this.fontFamily,
    required this.isFocused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
        return InkWell(
             onTap: onTap,
             child: Container(
                  width: width,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                       border: Border.all(color: dashedColor),
                       color: isFocused ? goldColor.withOpacity(0.1) : Colors.transparent
                  ),
                  child: Column(
                       children: [
                            Text(word.arabicText, textAlign: TextAlign.center, style: TextStyle(
                                 fontSize: arabicFontSize * scaleFactor,
                                 fontFamily: fontFamily,
                                 color: textColor,
                                 // Add minimal shaping support if GoogleFonts not used here yet
                                 // But ideally we should pass textStyle
                            )),
                            Text(word.translation, textAlign: TextAlign.center, style: TextStyle(
                                 fontSize: 10,
                                 color: goldColor
                            ))
                       ]
                  ),
             ),
        );
  }
}

class _FlowingWord extends StatelessWidget {
    final AyahWord word;
    final TextStyle textStyle;
    final Color accentColor;
    final bool isFocused;
    final VoidCallback onTap;
    final Widget? trailing;

    const _FlowingWord({
        super.key,
        required this.word,
        required this.textStyle,
        required this.accentColor,
        required this.isFocused,
        required this.onTap,
        this.trailing,
    });
    
    @override
    Widget build(BuildContext context) {
        return InkWell(
            onTap: onTap,
            child: Container(
                decoration: BoxDecoration(
                     color: isFocused ? accentColor.withOpacity(0.1) : Colors.transparent,
                     borderRadius: BorderRadius.circular(4)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                          Text(word.arabicText, style: textStyle),
                          if (trailing != null) trailing!,
                     ]
                )
            )
        );
    }
}

class _WordDetailDialog extends StatelessWidget {
  final AyahWord word;
  const _WordDetailDialog({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
       backgroundColor: theme.scaffoldBackgroundColor,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
       child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
                Text(word.arabicText, style: TextStyle(fontFamily: 'quranfont', fontSize: 32, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 12),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                   decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)
                   ),
                   child: Text(word.transliteration, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold))
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(word.translation, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Text("Word ${word.wordNumber}", style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.tertiary)),
             ]
          )
       ),
    );
  }
}
