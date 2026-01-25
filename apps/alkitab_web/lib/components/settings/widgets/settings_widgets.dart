import 'package:flutter/material.dart';
import 'package:alkitab_ui/alkitab_ui.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), 
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.secondary, 
          letterSpacing: 1.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

class DirectionAwareIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const DirectionAwareIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: Directionality.of(context) == TextDirection.rtl ? -1 : 1,
      child: Icon(icon, size: size, color: color),
    );
  }
}
