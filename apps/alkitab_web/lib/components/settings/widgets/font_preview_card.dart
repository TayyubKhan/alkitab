import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alkitab_core/alkitab_core.dart';
import 'dart:ui'; // For FontFeature

class FontPreviewCard extends ConsumerWidget {
  const FontPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final arabicFontStyle = ref.watch(
        appConfigViewModelProvider.select((value) => value.arabicFontStyle));
    final arabicFontSize = ref.watch(
        appConfigViewModelProvider.select((value) => value.arabicFontSize));
    final translationFontSize = ref.watch(appConfigViewModelProvider
        .select((value) => value.translationFontSize));

    final fontFamily =
        (arabicFontStyle == 'amiri' || arabicFontStyle == 'uthmani')
            ? 'Amiri'
            : 'quranfont';

    final isNastaliq = fontFamily == 'quranfont';
    final double lineHeight = isNastaliq ? 2.5 : 2.0;
    final double letterSpacing = isNastaliq ? -1.0 : 0.0;
    final FontWeight fontWeight =
        isNastaliq ? FontWeight.w100 : FontWeight.normal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: Column(
        children: [
          Text(
            "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: arabicFontSize,
              height: lineHeight,
              color: colorScheme.onSurface,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              locale: const Locale('ur', 'PK'),
              fontFeatures: const [
                FontFeature.enable('liga'),
                FontFeature.enable('kern'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: translationFontSize,
              color: colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
