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
    final activeColor = theme.colorScheme.secondary;

    return SelectionCard(
      isSelected: isSelected,
      title: reciter.name,
      subtitle: "Murattal • High Quality",
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // Minimal Audio Style: Just a subtle circle like AyahActionRail buttons
          shape: BoxShape.circle,
          color: isSelected 
              ? activeColor.withValues(alpha: 0.1) 
              : Colors.transparent,
          border: isSelected 
              ? Border.all(color: activeColor, width: 1) 
              : null, // No border when unselected for "minimal" look
        ),
        child: isSelected 
            ? Icon(Icons.mic, color: activeColor, size: 20) // Icon when selected
            : Text(
                reciter.name.isNotEmpty ? reciter.name[0] : '?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
      ),
      // SelectionCard now handles the trailing checkbox automatically
      trailing: null,
    );
  }
}
