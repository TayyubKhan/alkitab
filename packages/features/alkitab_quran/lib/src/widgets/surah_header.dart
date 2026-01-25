import 'package:flutter/material.dart';
import 'package:alkitab_models/alkitab_models.dart';
import '../l10n/quran_localizations.dart';

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
    final strings = QuranLocalizations.of(context);
    // If strings are missing (e.g. no adapter yet/web), use English defaults or empty
    // But since we are building for parity, we should assume adapter is provided.
    // Fallback logic could be complex. Let's rely on null awareness if needed?
    // strings is nullable in interface? standard practice is ! or ?.
    // of(context) returns nullable.
    
    final s_meccan = strings?.meccan ?? 'Meccan';
    final s_medinan = strings?.medinan ?? 'Medinan';
    final s_ayah = strings?.ayah ?? 'Ayah';
    final s_ayahs = strings?.ayahs ?? 'Ayahs';

    // Helper for revelation type
    String localizedRevelation = surah.revelationType;
    if (localizedRevelation.toLowerCase().contains('meccan') || localizedRevelation.toLowerCase().contains('makkah')) {
      localizedRevelation = s_meccan;
    } else if (localizedRevelation.toLowerCase().contains('medinan') || localizedRevelation.toLowerCase().contains('madinah')) {
      localizedRevelation = s_medinan;
    }

    // Helper for Ayahs label
    final String ayahsLabel = surah.numberOfAyahs == 1 ? s_ayah : s_ayahs;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // 1. Ornate Top Divider
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
          Text(
            surah.name, // The Arabic name
            style: textTheme.displayLarge?.copyWith(
              fontFamily: 'quranfont', 
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
              fontFamily: 'GT-Super-Text-Book', 
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
              "$localizedRevelation • ${surah.numberOfAyahs} $ayahsLabel",
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 5. Bismillah
          if (surah.number != 9 && surah.number != 1)
             Text(
               "بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
               style: textTheme.titleLarge?.copyWith(
                 fontWeight: FontWeight.w400,
                 fontFamily: 'quranfont',
                 fontSize: 48,
                 color: colorScheme.onSurface,
               ),
               textAlign: TextAlign.center,
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
