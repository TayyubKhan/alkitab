import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool initiallyExpanded;

  const SectionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Cache the theme for performance and cleaner code
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      // We use the theme's default Card settings (colors/elevation),
      // but override shape slightly if you want to keep the 8px radius vs 12px default.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // Use the centralized outline color (opacity controlled in AppTheme)
        side: BorderSide(color: theme.colorScheme.outline),
      ),
      child: Theme(
        // Remove internal divider lines for a cleaner "Void" look
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            // 1. Use labelLarge (Inter, SemiBold)
            // 2. Apply Gold color (secondary) specifically for this header
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.secondary,
              letterSpacing: 1.2,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  // Use labelSmall (Inter, 11px, Muted opacity)
                  style: theme.textTheme.labelSmall,
                )
              : null,
          children: children,
        ),
      ),
    );
  }
}

class FadePageRoute<T> extends MaterialPageRoute<T> {
  FadePageRoute({required super.builder});
  @override
  Widget buildTransitions(BuildContext c, Animation<double> a,
          Animation<double> s, Widget ch) =>
      FadeTransition(opacity: a, child: ch);
}
