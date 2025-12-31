import 'package:flutter/material.dart';
import '../../../../data/models/quran_models.dart';
import 'selection_card.dart';

class ReciterCard extends StatelessWidget {
  final Reciter reciter;
  final bool isSelected;
  final VoidCallback onTap;

  const ReciterCard({
    super.key,
    required this.reciter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const goldColor = Color(0xFFFFD700);

    return SelectionCard(
      isSelected: isSelected,
      title: reciter.name,
      subtitle: "Murattal • High Quality",
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? goldColor.withOpacity(0.2)
              : theme.colorScheme.surfaceContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            reciter.name.isNotEmpty ? reciter.name[0] : '?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? goldColor : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: goldColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Active",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
