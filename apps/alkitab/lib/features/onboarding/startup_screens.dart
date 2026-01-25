import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab/l10n/gen/app_localizations.dart';

import '../../core/controllers/controllers.dart';
import '../../core/utils/language_utils.dart';
import 'package:alkitab_core/alkitab_core.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/models/quran_models.dart';
import '../../data/repositories/quran_repository.dart' as local_repo;
import '../../viewmodels/download_viewmodel.dart';
import '../../viewmodels/quran_viewmodel.dart' hide SurahListScreen;
import '../../viewmodels/settings_viewmodel.dart';
import 'package:alkitab_quran/alkitab_quran.dart' hide SurahListScreen;
import '../quran/screens/surah_list_screen.dart'; // Local implementation with Settings/Reset
import 'widgets/onboarding_components.dart';
import 'widgets/reciter_card.dart';
import 'widgets/selection_card.dart';
import 'widgets/translation_card.dart';

// -----------------------------------------------------------------------------
// STARTUP COORDINATOR
// -----------------------------------------------------------------------------
class StartupCoordinator extends ConsumerStatefulWidget {
  const StartupCoordinator({super.key});

  @override
  ConsumerState<StartupCoordinator> createState() => _StartupCoordinatorState();
}

class _StartupCoordinatorState extends ConsumerState<StartupCoordinator> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Use local provider because we need specific download methods
    final repo = ref.read(local_repo.mobileQuranRepositoryProvider);
    final isDownloaded = await repo.isBaseDataDownloaded();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              isDownloaded ? const SurahListScreen() : const AutoSetupScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

class AutoSetupScreen extends ConsumerStatefulWidget {
  const AutoSetupScreen({super.key});

  @override
  ConsumerState<AutoSetupScreen> createState() => _AutoSetupScreenState();
}

class _AutoSetupScreenState extends ConsumerState<AutoSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // 1. Language, 2. Core, 3. Reciter, 4. Audio DL, 5. WBW, 6. Tafsir, 7. Translations
  final int _totalSteps = 7;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final downloadState = ref.watch(dataDownloadViewModelProvider);
    final setupController = ref.watch(autoSetupControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            _OnboardingHeader(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _currentStep > 0 ? _prevPage : null,
            ),

            // --- MULTI-PAGE VIEW ---
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  // STEP 0: Language Selection
                  _LanguageSelectionPage(onNext: _nextPage),

                  // STEP 1: Core System
                  _CoreSystemPage(onNext: _nextPage),

                  // STEP 2: Reciter
                  _ReciterSelectionPage(onNext: _nextPage),

                  // STEP 3: Audio Selection
                  _AudioSelectionPage(onNext: _nextPage),

                  // STEP 4: Word-by-Word
                  _WbwSelectionPage(onNext: _nextPage),

                  // STEP 5: Tafsir
                  _TafsirSelectionPage(onNext: _nextPage),

                  // STEP 6: Translations & Download
                  _TranslationPage(
                    onDownload: () async {
                      final success =
                          await setupController.startDownloadSequence();
                      if (success && mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SurahListScreen()),
                        );
                      }
                    },
                    downloadState: downloadState,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HEADER COMPONENT
// -----------------------------------------------------------------------------
class _OnboardingHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const _OnboardingHeader({
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: onBack != null
                ? IconButton(
                    icon: DirectionAwareIcon(EvaIcons.arrow_back_outline,
                        color: theme.colorScheme.onSurface),
                    onPressed: onBack,
                  )
                : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (index) {
                final isActive = index <= currentStep;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 4,
                  width: isActive ? 24 : 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 0: LANGUAGE SELECTION
// -----------------------------------------------------------------------------
class _LanguageSelectionPage extends ConsumerWidget {
  final VoidCallback onNext;
  const _LanguageSelectionPage({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context); // Nullable safely if not ready? Should be ready.
    // If context doesn't have localizations yet (very start), we might default or it might just work if MaterialApp is set up.
    // Since this is inside MaterialApp, it should be fine.
    
    // Watch current language
    final currentLang = ref.watch(appConfigViewModelProvider.select((s) => s.appLanguage));
    final vm = ref.read(appConfigViewModelProvider.notifier);

    final languages = [
      {'code': 'English', 'label': strings?.english ?? 'English', 'icon': '🇺🇸'},
      {'code': 'Arabic', 'label': strings?.arabic ?? 'Arabic', 'icon': '🇸🇦'},
      {'code': 'Urdu', 'label': strings?.urdu ?? 'Urdu', 'icon': '🇵🇰'},
      {'code': 'Indonesian', 'label': strings?.indonesian ?? 'Indonesian', 'icon': '🇮🇩'},
      {'code': 'French', 'label': strings?.french ?? 'French', 'icon': '🇫🇷'},
      {'code': 'Spanish', 'label': strings?.spanish ?? 'Spanish', 'icon': '🇪🇸'},
      {'code': 'German', 'label': strings?.german ?? 'German', 'icon': '🇩🇪'},
      {'code': 'Russian', 'label': strings?.russian ?? 'Russian', 'icon': '🇷🇺'},
      {'code': 'Turkish', 'label': strings?.turkish ?? 'Turkish', 'icon': '🇹🇷'},
      {'code': 'Hindi', 'label': strings?.hindi ?? 'Hindi', 'icon': '🇮🇳'},
      {'code': 'Bengali', 'label': strings?.bengali ?? 'Bengali', 'icon': '🇧🇩'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           OnboardingSectionHeader(
            title: strings?.selectLanguage ?? "Select Language",
            subtitle: "Choose your preferred language / اختر لغتك",
            icon: EvaIcons.globe_outline,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = lang['code'] == currentLang;

                return SelectionCard(
                  isSelected: isSelected,
                  title: lang['label']!,
                  subtitle: lang['code']!, 
                  leading: Text(
                    lang['icon']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  onTap: () => vm.setAppLanguage(lang['code']!),
                );
              },
            ),
          ),
          OnboardingActionButton(
              label: strings?.save ?? "Continue", 
              icon: EvaIcons.arrow_forward_outline,
              onPressed: onNext),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 1: CORE SYSTEM
// -----------------------------------------------------------------------------
class _CoreSystemPage extends StatelessWidget {
  final VoidCallback onNext;
  const _CoreSystemPage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingSectionHeader(
            title: "Core System",
            subtitle: "Essential components for precision and accuracy.",
            icon: EvaIcons.layers_outline,
          ),
          const SizedBox(height: 32),
          SelectionCard(
            isSelected: true,
            title: "Uthmani Script",
            subtitle: "Standard meditative script used globally.",
            leading: const Icon(EvaIcons.brush_outline, size: 28),
            onTap: () {}, // Locked
          ),
          const SizedBox(height: 16),
          SelectionCard(
            isSelected: true,
            title: "Transliteration",
            subtitle: "Phonetic guide for pronunciation.",
            leading: const Icon(EvaIcons.text_outline, size: 28),
            onTap: () {}, // Locked
          ),
          const Spacer(),
          OnboardingActionButton(
              label: "Continue",
              icon: EvaIcons.arrow_forward_outline,
              onPressed: onNext),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 2: RECITER SELECTION
// -----------------------------------------------------------------------------
class _ReciterSelectionPage extends ConsumerWidget {
  final VoidCallback onNext;
  const _ReciterSelectionPage({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recitersAsync = ref.watch(allRecitersProvider);
    final selectedId = ref.watch(autoSetupControllerProvider);
    final controller = ref.read(autoSetupControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingSectionHeader(
            title: "Select Reciter",
            subtitle: "Choose the voice that leads your journey.",
            icon: EvaIcons.mic_outline,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: recitersAsync.when(
              loading: () => Center(
                  child: CircularProgressIndicator(
                      color: theme.colorScheme.secondary)),
              error: (e, _) => Text("Error: $e"),
              data: (reciters) {
                final activeId = selectedId ?? reciters.first.identifier;

                return ListView.separated(
                  itemCount: reciters.length,
                  padding: const EdgeInsets.only(bottom: 24),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final reciter = reciters[index];
                    final isSelected = reciter.identifier == activeId;

                    return ReciterCard(
                      reciter: reciter,
                      isSelected: isSelected,
                      onTap: () =>
                          controller.setSelectedReciter(reciter.identifier),
                    );
                  },
                );
              },
            ),
          ),
          OnboardingActionButton(
              label: "Continue",
              icon: EvaIcons.arrow_forward_outline,
              onPressed: onNext),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 3: AUDIO SELECTION
// -----------------------------------------------------------------------------
class _AudioSelectionPage extends ConsumerWidget {
  final VoidCallback onNext;
  const _AudioSelectionPage({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupOptions = ref.watch(setupOptionsProvider);
    final setupNotifier = ref.read(setupOptionsProvider.notifier);
    final bool isDownloading = setupOptions.shouldDownloadReciter;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingSectionHeader(
            title: "Audio Access",
            subtitle: "Optimize your experience for offline or online use.",
            icon: EvaIcons.headphones_outline,
          ),
          const SizedBox(height: 32),
          SelectionCard(
            isSelected: isDownloading,
            title: "Download Full Quran",
            subtitle: "Best for offlifne use. Requires ~500MB+ storage.",
            leading: const Icon(EvaIcons.download_outline, size: 28),
            onTap: () => setupNotifier.setShouldDownloadReciter(true),
          ),
          const SizedBox(height: 16),
          SelectionCard(
            isSelected: !isDownloading,
            title: "Stream / Download Later",
            subtitle: "Save storage space. Internet required.",
            leading: const Icon(EvaIcons.cloud_upload_outline, size: 28),
            onTap: () => setupNotifier.setShouldDownloadReciter(false),
          ),
          const Spacer(),
          OnboardingActionButton(
              label: "Continue",
              icon: EvaIcons.arrow_forward_outline,
              onPressed: onNext),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 4: WORD-BY-WORD SELECTION
// -----------------------------------------------------------------------------
class _WbwSelectionPage extends ConsumerWidget {
  final VoidCallback onNext;
  const _WbwSelectionPage({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupOptions = ref.watch(setupOptionsProvider);
    final setupNotifier = ref.read(setupOptionsProvider.notifier);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingSectionHeader(
            title: "Word-by-Word",
            subtitle: "Understand the Quran, word by word.",
            icon: EvaIcons.text_outline,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: wbwOptionsList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final wbw = wbwOptionsList[index];
                final isSelected = setupOptions.wbwEditions.contains(wbw.id);

                return SelectionCard(
                  isSelected: isSelected,
                  title: wbw.title,
                  subtitle: wbw.id.toUpperCase(),
                  leading: Text(
                    wbw.id.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  onTap: () => setupNotifier.toggleWbWEdition(wbw.id),
                );
              },
            ),
          ),
          OnboardingActionButton(
              label: "Continue",
              icon: EvaIcons.arrow_forward_outline,
              onPressed: onNext),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 5: TAFSIR SELECTION
// -----------------------------------------------------------------------------
class _TafsirSelectionPage extends ConsumerWidget {
  final VoidCallback onNext;
  const _TafsirSelectionPage({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final editionsAsync = ref.watch(allEditionsProvider);
    final setupOptions = ref.watch(setupOptionsProvider);
    final setupNotifier = ref.read(setupOptionsProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: const OnboardingSectionHeader(
            title: "Select Tafsir",
            subtitle: "Deepen understanding with scholarly commentary.",
            icon: EvaIcons.book_open_outline,
          ),
        ),
        Expanded(
          child: editionsAsync.when(
            loading: () => Center(
                child: CircularProgressIndicator(
                    color: theme.colorScheme.secondary)),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (allEditions) {
              final tafsirs =
                  allEditions.where((e) => e.type == 'tafsir').toList();

              if (tafsirs.isEmpty) {
                return Center(
                  child: Text(
                    "No Tafsirs available",
                    style: TextStyle(color: theme.colorScheme.tertiary),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: tafsirs.length,
                itemBuilder: (context, index) {
                  final tafsir = tafsirs[index];
                  final isSelected =
                      setupOptions.fullEditions.contains(tafsir.identifier);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SelectionCard(
                      isSelected: isSelected,
                      title: tafsir.name,
                      subtitle: tafsir.language.toUpperCase(),
                      leading: const Icon(EvaIcons.book_open_outline, size: 24),
                      onTap: () =>
                          setupNotifier.toggleFullEdition(tafsir.identifier),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: OnboardingActionButton(
              label: "Next Step",
              icon: EvaIcons.arrow_forward_outline,
              onPressed: onNext),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// STEP 6: TRANSLATIONS & DOWNLOAD
// -----------------------------------------------------------------------------
class _TranslationPage extends ConsumerWidget {
  final VoidCallback onDownload;
  final DataDownloadState downloadState;

  const _TranslationPage({
    required this.onDownload,
    required this.downloadState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sortedTrans = ref.watch(sortedTranslationsProvider);
    final setupOptions = ref.watch(setupOptionsProvider);
    final setupNotifier = ref.read(setupOptionsProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const OnboardingSectionHeader(
            title: "Translations",
            subtitle: "Select translations for offline access.",
            icon: EvaIcons.globe_outline,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: AbsorbPointer(
            absorbing: downloadState.isLoading,
            child: Opacity(
              opacity: downloadState.isLoading ? 0.3 : 1.0,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: sortedTrans.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                      child: Theme(
                        data: theme.copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide.none),
                          leading: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // Minimal Outline Style
                              shape: BoxShape.circle, 
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              entry.key.substring(0, 2).toUpperCase(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          title: Text(LanguageUtils.getLanguageName(entry.key),
                              style: theme.textTheme.labelLarge),
                          children: entry.value.map((edition) {
                            final isSelected = setupOptions.fullEditions
                                .contains(edition.identifier);
                            return TranslationCard(
                              edition: edition,
                              isSelected: isSelected,
                              onTap: () => setupNotifier
                                  .toggleFullEdition(edition.identifier),
                            );
                          }).toList(),
                        ),
                      ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        // Progress Section
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              if (downloadState.isLoading)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: downloadState.progress > 0
                          ? downloadState.progress
                          : null,
                      backgroundColor: theme.colorScheme.surfaceContainer,
                      color: theme.colorScheme.secondary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${(downloadState.progress * 100).clamp(0, 100).toInt()}%",
                            style: theme.textTheme.labelMedium),
                        if (downloadState.totalMB > 0)
                          Text(
                            "${downloadState.downloadedMB.toStringAsFixed(1)} / ${downloadState.totalMB.toStringAsFixed(1)} MB",
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: theme.colorScheme.tertiary),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(downloadState.progressMessage,
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: theme.colorScheme.tertiary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                )
              else
                OnboardingActionButton(
                    label: "Download & Start",
                    icon: EvaIcons.cloud_download_outline,
                    onPressed: onDownload),
            ],
          ),
        ),
      ],
    );
  }
}
