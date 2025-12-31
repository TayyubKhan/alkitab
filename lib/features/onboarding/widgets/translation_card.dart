import 'package:flutter/material.dart';
import '../../../../data/models/quran_models.dart';
import 'selection_card.dart';

class TranslationCard extends StatelessWidget {
  final Edition edition;
  final bool isSelected;
  final VoidCallback onTap;

  const TranslationCard({
    super.key,
    required this.edition,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SelectionCard(
        isSelected: isSelected,
        title: edition.name,
        subtitle: edition.type.toUpperCase(),
        leading: const Icon(Icons.book, size: 20),
        onTap: onTap,
      ),
    );
  }
}
