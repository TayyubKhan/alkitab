import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback onTap;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const SelectionCard({
    super.key,
    required this.isSelected,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.secondary;

    // MINIMAL UI: List Tile Style
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: const BoxDecoration(
          // Minimal: No dividers
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? activeColor // Gold text if selected
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // Rounded box
                  color: isSelected ? activeColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected 
                        ? activeColor 
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5), // Visible Grey
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary) // White check
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
