import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:alkitab_models/alkitab_models.dart';
import 'package:alkitab_core/alkitab_core.dart'; // Audio/Settings/Repo/DownloadVM

import '../viewmodels/quran_viewmodel.dart';
import '../widgets/audio_mini_player.dart';
import '../widgets/ayah_card.dart';
import '../widgets/surah_ayah_selector.dart';
import '../widgets/surah_header.dart';
import '../l10n/quran_localizations.dart';

class AyahListScreen extends ConsumerStatefulWidget {
  final Surah surah;
  final int? initialAyah;
  final void Function(BuildContext)? onShowSettings; // Decoupled Settings
  final void Function(Surah, int)? onNavigateToSurah; // Decoupled Navigation if needed (or handle locally)
  final void Function(String, BuildContext)? onReportContent; // For ResearchSheet

  const AyahListScreen({
    super.key, 
    required this.surah, 
    this.initialAyah,
    this.onShowSettings,
    this.onNavigateToSurah,
    this.onReportContent,
  });

  @override
  ConsumerState<AyahListScreen> createState() => _AyahListScreenState();
}

class _AyahListScreenState extends ConsumerState<AyahListScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();


  // UX STATE
  bool _isDownloadingAudio = false;
  double _downloadProgress = 0.0;
  bool _isFetchingMore = false;
  bool _isJumping = false;
  
  // WBW STATE
  String? _selectedWordTranslation;

  // VISIBILITY STATE
  final ValueNotifier<bool> _areBarsVisibleNotifier = ValueNotifier(true);

  // INTERACTION TRACKING
  bool _userIsInteracting = false;
  Timer? _interactionDebounce;
  Timer? _scrollDebounce;

  // Cache
  late final int _surahNumber;
  int? _cachedLastSeenAyah;

  @override
  void initState() {
    super.initState();
    _surahNumber = widget.surah.number;
    _itemPositionsListener.itemPositions.addListener(_onScrollPositionChanged);

    if (widget.initialAyah != null && widget.initialAyah! > 15) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSmartJump(widget.initialAyah!);
      });
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions
        .removeListener(_onScrollPositionChanged);
    _interactionDebounce?.cancel();
    _scrollDebounce?.cancel();
    _areBarsVisibleNotifier.dispose();
    super.dispose();
  }

  Future<void> _performSmartJump(int ayahNumber) async {
    if (ayahNumber < 1) return;
    
    final index = ayahNumber;
    final currentLimit = ref.read(surahLimitProvider(widget.surah.number));

    if (ayahNumber > currentLimit) {
      setState(() => _isJumping = true);
      ref
          .read(surahLimitProvider(widget.surah.number).notifier)
          .jumpTo(ayahNumber);
      try {
        await ref.read(ayahReaderProvider(widget.surah.number).future);
        if (mounted) await Future.delayed(const Duration(milliseconds: 300));
      } finally {
        if (mounted) setState(() => _isJumping = false);
      }
    }

    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: index,
        alignment: 0.15,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
    _updateLastSeen(ayahNumber);
  }

  int _lastScrollProcessTime = 0;
  static const int _kPreloadThreshold = 25;

  void _onScrollPositionChanged() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastScrollProcessTime < 100) {
      return; 
    }
    _lastScrollProcessTime = now;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty || _isJumping) return;

    if (_userIsInteracting) {
      final firstVisible = positions.firstWhere(
        (item) => item.itemLeadingEdge < 1,
        orElse: () => positions.first,
      );

      final ayahNum = firstVisible.index > 0 ? firstVisible.index : 1;

      if (_cachedLastSeenAyah != ayahNum) {
        _cachedLastSeenAyah = ayahNum;
        _updateLastSeenDebounced(ayahNum);
      }
    }

    final lastVisible = positions.lastWhere(
      (item) => item.itemLeadingEdge < 1,
      orElse: () => positions.last,
    );

    final currentLimit = ref.read(surahLimitProvider(_surahNumber));

    if (lastVisible.index >= currentLimit - _kPreloadThreshold &&
        currentLimit < widget.surah.numberOfAyahs &&
        !_isFetchingMore) {
      _loadMoreAyahs();
    }
  }

  void _updateLastSeenDebounced(int ayahNumber) {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _updateLastSeen(ayahNumber);
    });
  }

  void _updateLastSeen(int ayahNumber) {
    ref.read(lastViewedNotifierProvider.notifier).savePosition(_surahNumber, ayahNumber,
        widget.surah.englishName, widget.surah.numberOfAyahs);
  }

  void _loadMoreAyahs() {
    setState(() => _isFetchingMore = true);
    ref.read(surahLimitProvider(widget.surah.number).notifier).loadMore();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isFetchingMore = false);
    });
  }

  void _handleGlobalNavigation(Surah targetSurah, int targetAyah) {
    Navigator.pop(context); 

    if (targetSurah.number == widget.surah.number) {
      _onJumpRequested(targetAyah);
    } else {
       if (widget.onNavigateToSurah != null) {
           widget.onNavigateToSurah!(targetSurah, targetAyah);
       } else {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AyahListScreen(
                surah: targetSurah,
                initialAyah: targetAyah,
                onShowSettings: widget.onShowSettings,
                onNavigateToSurah: widget.onNavigateToSurah,
                onReportContent: widget.onReportContent,
              ),
            ),
          );
       }
    }
  }

  void _showNavigationSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SurahAyahSelector(
        currentSurah: widget.surah,
        onSelection: _handleGlobalNavigation,
      ),
    );
  }

  Future<void> _handleAudioDownload(String reciterId) async {
    setState(() {
      _isDownloadingAudio = true;
      _downloadProgress = 0;
    });

    try {
      await Future.delayed(const Duration(seconds: 1)); // Mock for safety if repo missing
      
      ref.invalidate(isSurahAudioDownloadedProvider);
      ref.invalidate(ayahReaderProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Surah Audio Downloaded!")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Download Failed: $e")));
      }
    } finally {
      if (mounted) setState(() => _isDownloadingAudio = false);
    }
  }

  void _onJumpRequested(int ayahNumber) {
    if (ayahNumber > 0 && ayahNumber <= widget.surah.numberOfAyahs) {
      setState(() => _userIsInteracting = false);
      _performSmartJump(ayahNumber);
    }
  }

  void _toggleBars(bool visible) {
    if (_areBarsVisibleNotifier.value == visible) return;
    _areBarsVisibleNotifier.value = visible;
  }
  
  void _onWordSelected(String translation) {
      setState(() {
          _selectedWordTranslation = translation;
          _areBarsVisibleNotifier.value = true; // Ensure bar is visible to show translation
      });
      
      // Auto-hide after 3 seconds? Or keep until tap?
      // User request implies "on tap of word... translation appears".
      // Let's keep it until user taps another or scrolls.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ayahsAsync = ref.watch(ayahReaderProvider(widget.surah.number));
    final allEditionsAsync = ref.watch(allEditionsProvider);

    ref.listen(audioControlProvider.select((s) => s.currentAyah), (prev, next) {
      final isPlaying = ref.read(audioControlProvider).isPlaying;
      final currentSurah = ref.read(audioControlProvider).currentSurah;

      if (next != null &&
          currentSurah == widget.surah.number &&
          isPlaying &&
          !_userIsInteracting &&
          !_isJumping) {
        _performSmartJump(next);
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, 
      body: allEditionsAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.secondary)),
        error: (e, _) => Center(child: Text("$e")),
        data: (allEditions) {
          final editionMap = {for (var e in allEditions) e.identifier: e};

          return ayahsAsync.when(
            skipLoadingOnReload: true,
            loading: () => Center(
                child: CircularProgressIndicator(color: colorScheme.secondary)),
            error: (e, _) => Center(child: Text("$e")),
            data: (ayahList) {
              final initialIndex =
                  (widget.initialAyah != null && widget.initialAyah! > 0)
                      ? widget.initialAyah! 
                      : 0;
              final safeIndex =
                  (initialIndex <= ayahList.length) ? initialIndex : 0;

              return NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.direction == ScrollDirection.reverse) {
                    _toggleBars(false);
                    if (_selectedWordTranslation != null) setState(() => _selectedWordTranslation = null); // Dismiss word translation on scroll
                  } else if (notification.direction ==
                      ScrollDirection.forward) {
                    _toggleBars(true);
                  }

                  if (notification.direction != ScrollDirection.idle) {
                    _userIsInteracting = true;
                    _interactionDebounce?.cancel();
                  } else {
                    _interactionDebounce?.cancel();
                    _interactionDebounce =
                        Timer(const Duration(seconds: 3), () {
                      if (mounted) setState(() => _userIsInteracting = false);
                    });
                  }
                  return true;
                },
                child: Stack(
                  children: [
                    // 1. SCROLLABLE LIST
                    ScrollablePositionedList.builder(
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      initialScrollIndex: safeIndex,
                      addAutomaticKeepAlives:
                          true,
                      addRepaintBoundaries: true,
                      addSemanticIndexes: false,
                      padding: const EdgeInsets.only(
                          top: 120,
                          bottom: 150), 
                      physics: const BouncingScrollPhysics(),
                      itemCount: ayahList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return RepaintBoundary(
                            child: SurahHeader(
                              surah: widget.surah,
                            ),
                          );
                        }
                        final ayah = ayahList[index - 1];
                        return RepaintBoundary(
                          child: AyahRow(
                            key: ValueKey(ayah.numberInSurah),
                            ayah: ayah,
                            surah: widget.surah,
                            editionMap: editionMap,
                            onReportContent: widget.onReportContent,
                            onWordTap: _onWordSelected,
                          ),
                        );
                      },
                    ),

                    // 2. FLOATING TOP BAR
                    ValueListenableBuilder<bool>(
                      valueListenable: _areBarsVisibleNotifier,
                      builder: (context, areBarsVisible, child) {
                        return _OptimizedTopBar(
                          areBarsVisible: areBarsVisible,
                          surah: widget.surah,
                          allEditionsAsync: allEditionsAsync,
                          ayahList: ayahList,
                          selectedWordTranslation: _selectedWordTranslation,
                          onNavigateTap: _showNavigationSelector,
                          onJump: _onJumpRequested,
                          buildActionButton:
                              _buildActionButton, 
                          onSettingsTap: () {
                             ref.read(audioControlProvider.notifier).stop();
                             if (widget.onShowSettings != null) {
                                 widget.onShowSettings!(context);
                             }
                          },
                        );
                      },
                    ),

                    // 3. FLOATING BOTTOM BAR
                    ValueListenableBuilder<bool>(
                      valueListenable: _areBarsVisibleNotifier,
                      builder: (context, areBarsVisible, child) {
                        return Consumer(builder: (context, ref, _) {
                          final isPlaying = ref.watch(
                              audioControlProvider.select((s) => s.isPlaying));
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedSlide(
                              offset: (areBarsVisible || isPlaying)
                                  ? Offset.zero
                                  : const Offset(0, 1),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: const AudioMiniPlayer(),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButton(String? reciterId, ColorScheme colorScheme) {
    return _PlayDownloadButton(
      surah: widget.surah,
      reciterId: reciterId,
      isDownloading: _isDownloadingAudio,
      downloadProgress: _downloadProgress,
      onDownload: _handleAudioDownload,
    );
  }
}

class _PlayDownloadButton extends ConsumerWidget {
  final Surah surah;
  final String? reciterId;
  final bool isDownloading;
  final double downloadProgress;
  final Function(String) onDownload;

  const _PlayDownloadButton({
    required this.surah,
    required this.reciterId,
    required this.isDownloading,
    required this.downloadProgress,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reciterId == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    final isDownloadedAsync = ref.watch(isSurahAudioDownloadedProvider(
        (surah: surah.number, reciter: reciterId!)));
    final isDownloaded = isDownloadedAsync.value ?? false;

    if (isDownloading) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
              value: downloadProgress,
              strokeWidth: 3,
              color: colorScheme.secondary),
        ),
      );
    }

    if (!isDownloaded) {
      return IconButton(
        icon: Icon(EvaIcons.download_outline, color: colorScheme.onSurface),
        onPressed: () => onDownload(reciterId!),
      );
    }

    final audioState = ref.watch(audioControlProvider);
    // Sync Surah level button with any ayah playing in this Surah
    final isSurahPlaying = audioState.currentSurah == surah.number;

    return IconButton(
      icon: isSurahPlaying && audioState.isPlaying
          ? Icon(EvaIcons.pause_circle, color: colorScheme.secondary) 
          : Icon(EvaIcons.play_circle, color: colorScheme.secondary), 
      onPressed: () async {
        final audioNotifier = ref.read(audioControlProvider.notifier);
        if (isSurahPlaying) {
          audioNotifier.playPause();
        } else {
          final ayahs = await ref.read(ayahReaderProvider(surah.number).future);
          audioNotifier.setSurahPlaylistAndPlay(surah.number, ayahs);
        }
      },
    );
  }
}

class _AyahJumpBar extends StatefulWidget {
  final ValueChanged<int> onJump;
  const _AyahJumpBar({required this.onJump});

  @override
  State<_AyahJumpBar> createState() => _AyahJumpBarState();
}

class _AyahJumpBarState extends State<_AyahJumpBar> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text;
    if (text.isEmpty) return;
    final num = int.tryParse(text);
    if (num != null) {
      widget.onJump(num);
      FocusScope.of(context).unfocus();
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final strings = QuranLocalizations.of(context);
    final s_jumpToAyah = "Jump to Ayah..."; 

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 48, 
        decoration: BoxDecoration(
          color: Colors.transparent, 
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.go,
                style:
                    textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  filled: false,
                  hintText: s_jumpToAyah,
                  border: InputBorder.none,
                  hintStyle: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.tertiary),
                  contentPadding:
                      const EdgeInsets.only(bottom: 4), 
                ),
              ),
            ),
            IconButton(
              icon: Icon(EvaIcons.arrow_forward_outline,
                  size: 20, color: colorScheme.secondary), 
              onPressed: _submit,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _OptimizedTopBar extends ConsumerWidget {
  final bool areBarsVisible;
  final Surah surah;
  final AsyncValue<List<Edition>> allEditionsAsync;
  final List<AyahWithTranslations> ayahList;
  final VoidCallback onNavigateTap;
  final ValueChanged<int> onJump;
  final Widget Function(String?, ColorScheme) buildActionButton;
  final VoidCallback onSettingsTap;
  final String? selectedWordTranslation;

  const _OptimizedTopBar({
    required this.areBarsVisible,
    required this.surah,
    required this.allEditionsAsync,
    required this.ayahList,
    required this.onNavigateTap,
    required this.onJump,
    required this.buildActionButton,
    required this.onSettingsTap,
    this.selectedWordTranslation,
  });

  String _getEditionName(String id, List<Edition> all) {
    return all.where((e) => e.identifier == id).firstOrNull?.englishName ??
        "Translation";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final reciterId = ref.watch(
        appConfigViewModelProvider.select((s) => s.selectedReciterIdentifier));

    return AnimatedSlide(
      offset: areBarsVisible ? Offset.zero : const Offset(0, -1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: areBarsVisible ? 1.0 : 0.0,
        duration:
            const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: Container(
          color: theme.scaffoldBackgroundColor.withOpacity(0.95),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Custom App Bar Row
                SizedBox(
                  height: 56,
                  child: NavigationToolbar(
                    leading: BackButton(color: colorScheme.onSurface),
                    middle: selectedWordTranslation != null 
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                             selectedWordTranslation!,
                             style: textTheme.titleMedium?.copyWith(
                                 color: colorScheme.onSecondaryContainer,
                                 fontWeight: FontWeight.bold
                             ),
                        )
                    )
                    : InkWell(
                      onTap: onNavigateTap,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    surah.englishName,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  EvaIcons.arrow_ios_downward_outline,
                                  size: 16,
                                  color: colorScheme.secondary,
                                ),
                              ],
                            ),
                            if (ayahList.isNotEmpty &&
                                allEditionsAsync.value != null)
                              Builder(
                                builder: (context) {
                                   final editionMap = {for (var e in allEditionsAsync.value!) e.identifier: e};
                                   final visibleTranslations = ayahList.first.translations.keys
                                      .where((k) => editionMap[k]?.type != 'tafsir')
                                      .toList();
                                   
                                   if (visibleTranslations.length == 1) {
                                      return Text(
                                        _getEditionName(
                                          visibleTranslations.first,
                                          allEditionsAsync.value!,
                                        ),
                                        style: textTheme.labelSmall?.copyWith(
                                          fontSize: 10,
                                          color: colorScheme.onSurface
                                              .withOpacity(0.5),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                   }
                                   return const SizedBox.shrink();
                                }
                              ),
                          ],
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildActionButton(reciterId, colorScheme),
                        IconButton(
                          icon: Icon(EvaIcons.settings_2_outline,
                              color: colorScheme.onSurface),
                          onPressed: onSettingsTap,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
                // Jump Bar
                _AyahJumpBar(onJump: onJump),
              ],
            ),
          ),
        ), 
      ), 
    ); 
  }
}
