import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../data/models/quran_models.dart';
import '../../../../viewmodels/audio_viewmodel.dart';
import '../../../../viewmodels/settings_viewmodel.dart';
import 'research_sheet.dart';

/// A widget that displays a single Ayah (verse) in a list.
///
/// It supports two main display modes based on [AppConfig]:
/// 1. **Word-by-Word (WBW) Grid**: Displays words in a grid layout.
/// 2. **Flowing Text**: Displays words in a continuous flowing text layout.
///
/// Features:
/// - Audio playback control and buffering indication.
/// - Interaction with individual words (tap to show translation/transliteration).
/// - Copy to clipboard functionality.
/// - Access to "Research" (Tafsir/Reflection) sheet.
/// - Dynamic styling based on theme (Dark/Light) and user configuration.

class AyahRow extends ConsumerStatefulWidget {
  final AyahWithTranslations ayah;
  final Surah surah;
  final Map<String, Edition> editionMap;

  // CONST Constructor for performance
  const AyahRow({
    super.key,
    required this.ayah,
    required this.surah,
    required this.editionMap,
  });

  @override
  ConsumerState<AyahRow> createState() => _AyahRowState();
}

class _AyahRowState extends ConsumerState<AyahRow> {
  /// The index of the word currently tapped/focused by the user.
  /// If null, no word is focused.
  int? _focusedWordIndex;

  /// Base Scale factor for Arabic text.
  static const double _kBaseScale = 1.0;

  /// Returns the effective scale factor based on the selected font.
  /// IndoPak is scaled up to match visual weight of others.
  double _getFontScale(String arabicFontStyle) {
    if (arabicFontStyle == 'quranfont' ||
        arabicFontStyle == 'pdms' ||
        arabicFontStyle == 'indopak') {
      return _kBaseScale * 1.35; // 35% larger for IndoPak
    }
    return _kBaseScale; // Default for Amiri
  }

  /// Returns the correct font family string.
  String _getFontFamily(String arabicFontStyle) {
    if (arabicFontStyle == 'quranfont' ||
        arabicFontStyle == 'pdms' ||
        arabicFontStyle == 'indopak') {
      return 'quranfont';
    }
    return 'Amiri';
  }

  bool _showTafsir = false;

  /// Toggles the focus state of a word at [index].
  void _onWordTap(int index) {
    setState(() {
      _focusedWordIndex = (_focusedWordIndex == index) ? null : index;
    });
  }

  void _toggleTafsir() {
    setState(() {
      _showTafsir = !_showTafsir;
    });
  }

  /// Closes the currently active word popup/overlay.
  void _closePopup() {
    if (_focusedWordIndex != null) setState(() => _focusedWordIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final arabicFontSize = ref.watch(appConfigViewModelProvider.select((s) => s.arabicFontSize));
    final arabicFontStyle = ref.watch(appConfigViewModelProvider.select((s) => s.arabicFontStyle));
    final translationFontSize = ref.watch(appConfigViewModelProvider.select((s) => s.translationFontSize));
    final selectedTranslationLanguage = ref.watch(appConfigViewModelProvider.select((s) => s.selectedTranslationLanguage));
    final isDirectWBWEnabled = ref.watch(appConfigViewModelProvider.select((s) => s.isDirectWBWEnabled));
    final showArabicText = ref.watch(appConfigViewModelProvider.select((s) => s.showArabicText));
    final isTranslationOnly = ref.watch(appConfigViewModelProvider.select((s) => s.isTranslationOnly));
    final tafsirFontSize = ref.watch(appConfigViewModelProvider.select((s) => s.tafsirFontSize));

    final fontScale = _getFontScale(arabicFontStyle);
    final fontFamily = _getFontFamily(arabicFontStyle);

    final isUrdu = selectedTranslationLanguage == 'ur';
    final textColor = colorScheme.onSurface;
    final goldColor = colorScheme.secondary;

    // Very subtle separator line between rows
    final outlineColor =
        isDark ? colorScheme.onSurface.withOpacity(0.08) : colorScheme.outline;

    // SCOPED AUDIO STATE (Only rebuilds if THIS ayah's playing status changes)
    final isCurrentlyPlaying = ref.watch(audioControlProvider.select((state) =>
        state.currentAyah == widget.ayah.numberInSurah &&
        state.currentSurah == widget.surah.number &&
        state.isPlaying));

    return GestureDetector(
      onTap: _closePopup,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrentlyPlaying
              ? goldColor.withOpacity(0.05)
              : Colors.transparent,
          border: Border(bottom: BorderSide(color: outlineColor, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AyahActionRail(
              ayah: widget.ayah,
              surah: widget.surah,
              isCurrentlyPlaying: isCurrentlyPlaying,
              goldColor: goldColor,
              colorScheme: colorScheme,
              isTafsirVisible: _showTafsir,
              onTafsirToggle: _toggleTafsir,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 6),
                  if (showArabicText && !isTranslationOnly)
                    if (isDirectWBWEnabled)
                      _buildWBWGridContent(context, Colors.transparent,
                          outlineColor, textColor, goldColor, arabicFontSize, fontScale, fontFamily)
                    else
                      _buildFlowingContent(context, textColor, goldColor,
                          arabicFontSize, fontScale, fontFamily),
                  const SizedBox(height: 8),
                  if (widget.ayah.translations.isNotEmpty)
                    Column(
                      crossAxisAlignment:
                          isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: widget.ayah.translations.entries.map((e) {
                        final edition = widget.editionMap[e.key];
                        final authorName = edition?.englishName ?? "Translation";
                        final showAuthor = widget.ayah.translations.length > 1;
                        final baseStyle = isUrdu
                            ? textTheme.displayMedium?.copyWith(
                                fontSize: translationFontSize + 2,
                                color: textColor.withOpacity(0.95),
                                height: 1.8)
                            : textTheme.bodyMedium?.copyWith(
                                fontSize: translationFontSize,
                                color: textColor.withOpacity(0.95),
                                height: 1.5);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: e.value),
                                if (showAuthor)
                                  TextSpan(
                                    text: " ($authorName)",
                                    style: baseStyle?.copyWith(
                                      fontSize: (baseStyle.fontSize ?? 8) * 0.7,
                                      color: textColor.withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            style: baseStyle,
                            textAlign: isUrdu ? TextAlign.right : TextAlign.left,
                            textDirection:
                                isUrdu ? TextDirection.rtl : TextDirection.ltr,
                          ),
                        );
                      }).toList(),
                    ),
                  if (widget.ayah.tafsirs.isNotEmpty)
                    _buildTafsirContent(
                        context, goldColor, textColor, tafsirFontSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTafsirContent(BuildContext context, Color goldColor,
      Color textColor, double tafsirFontSize) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: _showTafsir
          ? Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainer
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: goldColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- FIXED HEADER ---
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainer
                          .withOpacity(0.9),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      border: Border(
                          bottom: BorderSide(
                              color: goldColor.withOpacity(0.1), width: 1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book, size: 14, color: goldColor),
                        const SizedBox(width: 8),
                        Text(
                          "Tafsir",
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: goldColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: _toggleTafsir,
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.close,
                                size: 18, color: textColor.withOpacity(0.7)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- SCROLLABLE CONTENT ---
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.ayah.tafsirs.entries.map((e) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                e.value,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: tafsirFontSize,
                                      color: textColor.withOpacity(0.9),
                                      height: 1.8,
                                    ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
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
        final double cellWidth = constraints.maxWidth / 3;
        final allWords = widget.ayah.words;
        final List<Widget> gridCells = [];

        for (int i = 0; i < allWords.length; i++) {
          gridCells.add(_InteractiveDashedGridCell(
            key: ValueKey(
                "wbw_${allWords[i].wordNumber}_$i"), // Fix: id -> wordNumber
            word: allWords[i],
            width: cellWidth,
            arabicFontSize: arabicFontSize,
            textColor: textColor,
            goldColor: goldColor,
            dashedColor: outlineColor,
            scaleFactor: fontScale,
            fontFamily: fontFamily,
            isFocused: _focusedWordIndex == i,
            onTap: () => _onWordTap(i),
          ));
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 0,
            spacing: 0,
            children: gridCells,
          ),
        );
      },
    );
  }

  Widget _buildFlowingContent(BuildContext context, Color textColor,
      Color goldColor, double arabicFontSize, double fontScale, String fontFamily) {
    final scaledFontSize = arabicFontSize * fontScale;
    final activeFontFamily = fontFamily;
    final allWords = widget.ayah.words;

    final endSymbolWidget = EndAyahSymbol(
      ayahNumber: widget.ayah.numberInSurah,
      size: scaledFontSize * 0.9,
      color: goldColor,
    );

    if (allWords.isEmpty) return const SizedBox.shrink();

    final normalWords = allWords.sublist(0, allWords.length - 1);
    final lastWord = allWords.last;

    final List<Widget> wordWidgets = [];

    for (int i = 0; i < normalWords.length; i++) {
      wordWidgets.add(_FlowingWord(
        key: ValueKey(
            "wbw_flow_${normalWords[i].wordNumber}_$i"), // Fix: id -> wordNumber
        word: normalWords[i],
        arabicFontSize: arabicFontSize,
        color: textColor,
        accentColor: goldColor,
        isFocused: _focusedWordIndex == i,
        onTap: () => _onWordTap(i),
        scaleFactor: fontScale,
        fontFamily: activeFontFamily,
      ));
    }

    wordWidgets.add(_FlowingWord(
      key: ValueKey(
          "wbw_flow_last_${lastWord.wordNumber}"), // Fix: id -> wordNumber
      word: lastWord,
      arabicFontSize: arabicFontSize,
      color: textColor,
      accentColor: goldColor,
      isFocused: _focusedWordIndex == (allWords.length - 1),
      onTap: () => _onWordTap(allWords.length - 1),
      scaleFactor: fontScale,
      fontFamily: activeFontFamily,
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
        runSpacing: 4, // Reduced line spacing for flow
        spacing: 2,
        children: wordWidgets,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER WIDGETS
// -----------------------------------------------------------------------------

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
          child: Icon(icon, size: 18, color: color),
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
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.string(
            _kAyahRosetteSvg,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$ayahNumber",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveDashedGridCell extends StatefulWidget {
  final AyahWord word;
  final double width;
  final double arabicFontSize;
  final Color textColor;
  final Color goldColor;
  final Color dashedColor;
  final double scaleFactor;
  final String fontFamily; // Added
  final bool isFocused;
  final VoidCallback onTap;

  const _InteractiveDashedGridCell({
    super.key, // Added super.key
    required this.word,
    required this.width,
    required this.arabicFontSize,
    required this.textColor,
    required this.goldColor,
    required this.dashedColor,
    required this.scaleFactor,
    required this.fontFamily, // Added
    required this.isFocused,
    required this.onTap,
  });

  @override
  State<_InteractiveDashedGridCell> createState() =>
      _InteractiveDashedGridCellState();
}

class _InteractiveDashedGridCellState
    extends State<_InteractiveDashedGridCell> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void didUpdateWidget(covariant _InteractiveDashedGridCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused != oldWidget.isFocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.isFocused) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final theme = Theme.of(context);
    final tooltipColor = theme.colorScheme.surfaceContainer;
    final textColor = theme.colorScheme.onSurface;
    final borderColor = widget.goldColor.withOpacity(0.5);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 180,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
          followerAnchor: Alignment.bottomCenter,
          offset: const Offset(0, -8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: tooltipColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.2),
                            blurRadius: 15)
                      ],
                    ),
                    child: Text(
                      widget.word.translation,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visualSize = widget.arabicFontSize * widget.scaleFactor;
    final bgColor = widget.isFocused
        ? widget.goldColor.withOpacity(0.1)
        : Colors.transparent;

    // OPTIMIZATION: Created the content widget separately
    final content = Material(
      color: bgColor,
      child: InkWell(
        onTap: widget.onTap,
        splashColor: widget.goldColor.withOpacity(0.1),
        child: CustomPaint(
          painter: _DashedBorderPainter(
              color: widget.dashedColor,
              dashWidth: 2,
              dashSpace: 4,
              strokeWidth: 2),
          child: Container(
            width: widget.width,
            constraints: const BoxConstraints(minHeight: 120),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _fixArabicText(widget.word.arabicText),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: widget.fontFamily,
                    height: widget.fontFamily == 'quranfont'
                        ? 2.5
                        : 2.0, // Taller for Nastaliq
                    fontSize: visualSize, // Applied here properly
                    fontWeight: widget.fontFamily == 'quranfont'
                        ? FontWeight.w100 // Thinnest possible
                        : FontWeight.normal,
                    letterSpacing: widget.fontFamily == 'quranfont'
                        ? -1.0
                        : 0.0, // Tighter for Nastaliq
                    locale: const Locale('ur', 'PK'),
                    fontFeatures: const [
                      FontFeature.enable('liga'),
                      FontFeature.enable('kern'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.word.translation,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: widget.goldColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // OPTIMIZATION: Only wrap with CompositedTransformTarget if focused
    if (widget.isFocused) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: content,
      );
    }
    return content;
  }
}

class _FlowingWord extends StatefulWidget {
  final AyahWord word;
  final double arabicFontSize;
  final Color color;
  final Color accentColor;
  final bool isFocused;
  final VoidCallback onTap;
  final double scaleFactor;
  final String fontFamily; // Added
  final Widget? trailing;

  const _FlowingWord({
    super.key, // Added super.key
    required this.word,
    required this.arabicFontSize,
    required this.color,
    required this.accentColor,
    required this.isFocused,
    required this.onTap,
    required this.scaleFactor,
    required this.fontFamily, // Added
    this.trailing,
  });

  @override
  State<_FlowingWord> createState() => _FlowingWordState();
}

class _FlowingWordState extends State<_FlowingWord> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void didUpdateWidget(covariant _FlowingWord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused != oldWidget.isFocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.isFocused) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final theme = Theme.of(context);
    final tooltipColor = theme.colorScheme.surfaceContainer;
    final textColor = theme.colorScheme.onSurface;
    final borderColor = widget.accentColor.withOpacity(0.5);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 150,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
          followerAnchor: Alignment.bottomCenter,
          offset: const Offset(0, -8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: tooltipColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.2),
                        blurRadius: 10)
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.word.translation,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.word.transliteration.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          widget.word.transliteration,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontStyle: FontStyle.italic,
                            fontSize: 9,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only fetch theme if needed? No, needed for styles.
    // final theme = Theme.of(context); // Not used in this snippet directly
    final visualSize = widget.arabicFontSize * widget.scaleFactor;

    // OPTIMIZATION: Created content widget separately
    final content = InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(4),
      overlayColor:
          WidgetStateProperty.all(widget.accentColor.withOpacity(0.1)),
      child: Container(
        decoration: widget.isFocused
            ? BoxDecoration(
                color: widget.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4))
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: _fixArabicText(widget.word.arabicText),
              style: TextStyle(
                fontFamily: widget.fontFamily,
                fontSize: visualSize,
                color: widget.color,
                height: widget.fontFamily == 'quranfont'
                    ? 2.5
                    : 2.0, // Taller for Nastaliq
                letterSpacing: widget.fontFamily == 'quranfont'
                    ? -1.0
                    : 0.0, // Tighter for Nastaliq
                fontWeight: widget.fontFamily == 'quranfont'
                    ? FontWeight.w100 // Thinnest possible
                    : FontWeight.normal,
                locale: const Locale('ur', 'PK'),
                fontFeatures: const [
                  FontFeature.enable('liga'),
                  FontFeature.enable('kern'),
                ],
              ),
            ),
            if (widget.trailing != null)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Transform.translate(
                      offset: const Offset(0, -5), child: widget.trailing!)),
          ]),
          textDirection: TextDirection.rtl,
        ),
      ),
    );

    // OPTIMIZATION: Only wrap with CompositedTransformTarget if focused
    if (widget.isFocused) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: content,
      );
    }

    return content;
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter(
      {required this.color,
      this.dashWidth = 4.0,
      this.dashSpace = 3.0,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height),
          Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}

class AyahActionRail extends ConsumerWidget {
  final AyahWithTranslations ayah;
  final Surah surah;
  final bool isCurrentlyPlaying;
  final Color goldColor;
  final ColorScheme colorScheme;
  final bool isTafsirVisible;
  final VoidCallback onTafsirToggle;

  const AyahActionRail({
    super.key,
    required this.ayah,
    required this.surah,
    required this.isCurrentlyPlaying,
    required this.goldColor,
    required this.colorScheme,
    required this.isTafsirVisible,
    required this.onTafsirToggle,
  });

  void _copyToClipboard(BuildContext context) {
    final text = "${ayah.arabicText}\n\n${ayah.translations.values.join('\n')}";
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ayah copied',
            style: TextStyle(color: Theme.of(context).colorScheme.surface)),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openResearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ResearchSheet(ayah: ayah, surah: surah),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch buffering specific to this Ayah
    final isBufferingThisAyah = ref.watch(audioControlProvider.select((s) =>
        s.isBuffering &&
        s.currentAyah == ayah.numberInSurah &&
        s.currentSurah == surah.number));

    return Padding(
      padding: const EdgeInsets.only(
          right: 12.0,
          top: 4.0), // Added top padding for alignment since crossAxis is start
      child: Column(
        mainAxisSize: MainAxisSize.min, // Do not expand
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 1. PLAY/PAUSE (Mini)
          if (isBufferingThisAyah)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: goldColor,
              ),
            )
          else
            _MinimalIconButton(
              icon: isCurrentlyPlaying
                  ? EvaIcons.pause_circle // Filled/Solid usually
                  : EvaIcons.play_circle_outline,
              color: isCurrentlyPlaying
                  ? goldColor
                  : colorScheme.onSurface.withOpacity(0.5),
              onPressed: () {
                final audioNotifier = ref.read(audioControlProvider.notifier);
                if (isCurrentlyPlaying) {
                  audioNotifier.playPause();
                } else if (ayah.audioUrl != null) {
                  audioNotifier.playAyah(
                      surah.number, ayah.numberInSurah, ayah.audioUrl!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No Audio Available"),
                      duration: Duration(seconds: 1)));
                }
              },
            ),

          const SizedBox(height: 8),

          // 2. COPY
          _MinimalIconButton(
            icon: EvaIcons.copy_outline,
            color: colorScheme.onSurface.withOpacity(0.4),
            onPressed: () => _copyToClipboard(context),
          ),

          // 3. RESEARCH
          _MinimalIconButton(
            icon: EvaIcons.bulb_outline,
            color: colorScheme.onSurface.withOpacity(0.4),
            onPressed: () => _openResearch(context),
          ),

          // 4. TAFSIR TOGGLE (New)
          if (ayah.tafsirs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _MinimalIconButton(
                icon: isTafsirVisible
                    ? EvaIcons.book_open
                    : EvaIcons.book_outline,
                color: isTafsirVisible
                    ? goldColor
                    : colorScheme.onSurface.withOpacity(0.4),
                onPressed: onTafsirToggle,
              ),
            ),
        ],
      ),
    );
  }
}

const String _kAyahRosetteSvg = '''
<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="48" fill="none" stroke="currentColor" stroke-width="2" opacity="0.8"/>
  <circle cx="50" cy="50" r="40" fill="none" stroke="currentColor" stroke-width="1" opacity="0.4"/>
  <g transform="translate(50, 50)">
     <circle cx="0" cy="0" r="15" fill="currentColor" opacity="0.1"/>
  </g>
</svg>
''';

String _fixArabicText(String text) {
  // Previously used to fix Alif Khari Zabar (added NBSP).
  // Now removed as it caused awkward gaps with the new Indopak typeface.
  return text;
}
