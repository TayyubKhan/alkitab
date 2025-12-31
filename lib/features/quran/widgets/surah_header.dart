import 'package:flutter/material.dart';

import '../../../data/models/quran_models.dart';

class SurahHeader extends StatelessWidget {
  final Surah surah;

  const SurahHeader({
    super.key,
    required this.surah,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // 1. Ornate Top Divider (Optional, simple line for now)
          Container(
            width: 120,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withOpacity(0.0),
                  colorScheme.secondary,
                  colorScheme.secondary.withOpacity(0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Surah Name in Arabic Calligraphy
          // Using a specialized font if available, otherwise large text
          // Ideally this would be an SVG or a specific font family like 'Amiri' or 'Scheherazade'
          Text(
            surah.name, // The Arabic name
            style: textTheme.displayLarge?.copyWith(
              fontFamily: 'quranfont', // Corrected to Arabic Font
              fontSize: 48,
              height: 1.2,
              color: colorScheme.onSurface,
              shadows: [
                Shadow(
                  color: colorScheme.secondary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // 3. English Name
          Text(
            surah.englishName,
            style: textTheme.headlineSmall?.copyWith(
              fontFamily: 'GT-Super-Text-Book', // Applied serif font
              color: colorScheme.secondary,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // 4. Metadata Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.2)),
            ),
            child: Text(
              "${surah.revelationType} • ${surah.numberOfAyahs} AYAHS",
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 5. Bismillah (Exclude for Surah At-Tawbah, #9 AND Al-Fatiha, #1)
          if (surah.number != 9 && surah.number != 1)
            Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/bismillah.png', // Ensure this exists, or use text fallback
                height: 40,
                color: colorScheme.onSurface,
                errorBuilder: (context, error, stackTrace) {
                  // Text Fallback if image missing
                  return Text(
                    "بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'quranfont',
                      fontSize: 48,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),

          if (surah.number != 9 && surah.number != 1)
            const SizedBox(height: 24),

          // Bottom Divider
          Container(
            width: 120,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withOpacity(0.0),
                  colorScheme.secondary,
                  colorScheme.secondary.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
