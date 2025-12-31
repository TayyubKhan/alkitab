import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/quran_models.dart';
import '../../../viewmodels/audio_viewmodel.dart';
import '../../../viewmodels/quran_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';

class AudioMiniPlayer extends ConsumerWidget {
  const AudioMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Theme Data
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 2. State
    final audioState = ref.watch(audioControlProvider);
    final allReciters = ref.watch(allRecitersProvider).asData?.value ?? [];
    final config = ref.watch(appConfigViewModelProvider);

    // 3. Visibility Check
    if (!audioState.isPlaying &&
        audioState.currentSurah == null &&
        !audioState.isBuffering) {
      return const SizedBox.shrink();
    }

    // 4. Resolve Reciter Name
    final reciterName = allReciters.isEmpty
        ? 'Loading Reciter...'
        : allReciters
            .firstWhere(
              (r) => r.identifier == config.selectedReciterIdentifier,
              orElse: () => Reciter(
                  identifier: '',
                  language: '',
                  name: 'Unknown Reciter',
                  englishName: ''),
            )
            .name;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface, // Matches Card Surface
        border: Border(top: BorderSide(color: colorScheme.outline)),
        boxShadow: [
          if (theme.brightness == Brightness.dark)
            BoxShadow(
              color: colorScheme.secondary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- PROGRESS BAR ---
          if (audioState.duration != null && audioState.position != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: (audioState.position!.inMilliseconds /
                          audioState.duration!.inMilliseconds)
                      .clamp(0.0, 1.0),
                  backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                  color: colorScheme.secondary, // Gold
                  minHeight: 2,
                ),
              ),
            ),

          Row(
            children: [
              // --- ICON CONTAINER ---
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.graphic_eq,
                    color: colorScheme.secondary, size: 20), // Gold Icon
              ),
              const SizedBox(width: 16),

              // --- TEXT INFO ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Surah ${audioState.currentSurah ?? 'Loading...'}",
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reciterName,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.tertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // --- CONTROLS ---
              if (audioState.isBuffering)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.secondary,
                    ),
                  ),
                )
              else
                IconButton(
                  icon: Icon(
                    audioState.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                  ),
                  iconSize: 36,
                  color: colorScheme.secondary, // Gold
                  onPressed: () =>
                      ref.read(audioControlProvider.notifier).playPause(),
                ),

              IconButton(
                icon: const Icon(Icons.stop_rounded),
                color: colorScheme.error.withOpacity(0.8),
                onPressed: () => ref.read(audioControlProvider.notifier).stop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
