import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab/l10n/gen/app_localizations.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _categories = [
    'Audio Issue',
    'Ayah Content',
    'Translation',
    'AI Response',
    'App Crash/Bug',
    'Other'
  ];
  final Set<String> _selectedCategories = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedCategories.isEmpty && _controller.text.trim().isEmpty) {
      // Allow empty submission? Probably better to require at least one signal.
      // But for low friction, maybe we just send what we have.
      // Let's at least show a snackbar warning if completely empty, or just disable button.
    }
    
    Navigator.of(context).pop({
      'description': _controller.text.trim(),
      'categories': _selectedCategories.toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final strings = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(EvaIcons.shake_outline, color: colorScheme.secondary),
                const SizedBox(width: 12),
                Text(
                  strings.feedbackTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              strings.feedbackHint, // Using hint as subtitle too for context
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                  backgroundColor: colorScheme.surfaceContainer,
                  selectedColor: colorScheme.secondary.withValues(alpha: 0.2),
                  checkmarkColor: colorScheme.secondary,
                  labelStyle: TextStyle(
                    color: isSelected ? colorScheme.secondary : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected 
                          ? colorScheme.secondary 
                          : colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Text Field
            TextField(
              controller: _controller,
              maxLines: 3,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: strings.feedbackHint,
                hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4)),
                filled: true,
                fillColor: colorScheme.surfaceContainer.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(
                    "Cancel", // Hardcoded fallback for now
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(EvaIcons.paper_plane_outline, size: 18),
                  label: Text(strings.send),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
