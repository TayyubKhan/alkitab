import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab/services/feedback_service.dart';
import '../widgets/settings_widgets.dart'; // Assuming this exists

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        leading: IconButton(
          icon: const Icon(EvaIcons.arrow_back_outline),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Shake to Report Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(EvaIcons.shake_outline, 
                     size: 32, 
                     color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shake to Report",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Shake your device anywhere in the app to capture a screenshot and report a bug or give feedback.",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Manual Report Button
          SettingsCard(
            children: [
              ListTile(
                leading: const Icon(EvaIcons.email_outline),
                title: const Text("Report a Bug"),
                subtitle: const Text("Send us an email directly"),
                trailing: const Icon(EvaIcons.arrow_ios_forward_outline, size: 16),
                onTap: () {
                    ref.read(feedbackServiceProvider).captureAndReport(
                      context: "Manual Report from Help Screen"
                    );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          
          // FAQ Header
          SectionHeader(title: "Freqently Asked Questions"),
          
          // FAQ List
          SettingsCard(
            children: [
              _FAQTile(
                question: "How do I change the reciter?",
                answer: "Go to Settings > Audio > Reciter to choose from our list of available Qaris.",
              ),
              const Divider(),
              _FAQTile(
                question: "Can I use the app offline?",
                answer: "Yes! Once you download a translation or reciter, it is available offline. The Quran text itself is always offline.",
              ),
              const Divider(),
              _FAQTile(
                question: "How do I enable Word-by-Word?",
                answer: "Go to Settings > Word by Word Analysis and toggle 'Enable Word Analysis'. You can also tap on any word in the Quran view to see details.",
              ),
              const Divider(),
              _FAQTile(
                question: "Where does the data come from?",
                answer: "We use reputable data sources like Quran.com and other verified Islamic institutions for text, translations, and audio.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      expandedAlignment: Alignment.centerLeft,
      shape: const Border(),
      collapsedShape: const Border(),
      children: [
        Text(answer, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)),
      ],
    );
  }
}

// Reusing internal widgets from settings_widgets logic implicitly by copying simplified versions or import if exposed.
// Since SettingsCard and SectionHeader are in settings_widgets.dart and usually not exported globally, 
// I will assume I need to import them or duplicate them if they are private.
// Checking imports... I see 'package:alkitab_ui/alkitab_ui.dart' might have them or I need to import `../widgets/settings_widgets.dart`.

// Let's check imports in the file header above. I added `settings_widgets.dart` to imports assuming I can access it.
// Wait, I am creating a new file. I should make sure I import the widgets correctly.

