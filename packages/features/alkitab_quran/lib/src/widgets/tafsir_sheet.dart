import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab_models/alkitab_models.dart';

class TafsirSheet extends StatelessWidget {
  final AyahWithTranslations ayah;
  final Surah surah;
  final double fontSize;
  final Color titleColor;

  const TafsirSheet({
    super.key,
    required this.ayah,
    required this.surah,
    this.fontSize = 16.0,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
             border: Border(top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2))),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                   color: theme.colorScheme.surface,
                   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Icon(EvaIcons.bulb_outline, color: titleColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tafsir / Commentary", style: theme.textTheme.labelLarge),
                          Text(
                            "${surah.englishName} : ${ayah.numberInSurah}",
                            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.tertiary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(EvaIcons.close_outline),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: ayah.tafsirs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final key = ayah.tafsirs.keys.elementAt(index);
                    final text = ayah.tafsirs.values.elementAt(index);
                    final isUrdu = key.startsWith('ur');

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                           text,
                           textAlign: TextAlign.justify,
                           textDirection: TextDirection.rtl,
                           style: theme.textTheme.bodyMedium?.copyWith(
                               fontSize: fontSize,
                               height: isUrdu ? 2.2 : 1.8,
                               fontFamily: isUrdu ? 'Gulzar' : null,
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
      },
    );
  }
}
