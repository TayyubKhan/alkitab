import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alkitab_models/alkitab_models.dart';
import '../data/models/research_models.dart';
import '../viewmodels/research_viewmodel.dart';

class ResearchSheet extends ConsumerStatefulWidget {
  final AyahWithTranslations ayah;
  final Surah surah;
  final void Function(String content, BuildContext context)? onReportContent;

  const ResearchSheet({
    super.key,
    required this.ayah,
    required this.surah,
    this.onReportContent,
  });

  @override
  ConsumerState<ResearchSheet> createState() => _ResearchSheetState();
}

class _ResearchSheetState extends ConsumerState<ResearchSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String _sessionKey;

  @override
  void initState() {
    super.initState();
    _sessionKey = "${widget.surah.number}_${widget.ayah.numberInSurah}";
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({String mode = 'text'}) {
    final text = _controller.text.trim();

    // Auto-fill query if using chips
    String finalQuery = text;
    if (finalQuery.isEmpty) {
      if (mode == 'text') return;
      if (mode == 'grammar') finalQuery = "Analyze the grammar of this Ayah.";
      if (mode == 'history') {
        finalQuery = "What is the historical context / Sabab al-Nuzul?";
      }
      if (mode == 'insight') finalQuery = "Give me a practical reflection.";
    }

    ref.read(researchProvider(_sessionKey).notifier).sendQuery(
          query: finalQuery,
          ayah: widget.ayah,
          surah: widget.surah,
          mode: mode,
        );

    _controller.clear();

    // Scroll handling
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = ref.watch(researchProvider(_sessionKey));
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ResearchHeader(surah: widget.surah, ayah: widget.ayah),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 180),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageItemRenderer(
                        message: messages[index],
                        onReport: widget.onReportContent != null
                            ? (content) => widget.onReportContent!(content, context)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: bottomInset,
              left: 0,
              right: 0,
              child: ResearchInputArea(
                controller: _controller,
                onSend: (mode) => _sendMessage(mode: mode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResearchHeader extends StatelessWidget {
  final Surah surah;
  final AyahWithTranslations ayah;

  const ResearchHeader({
    super.key,
    required this.surah,
    required this.ayah,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        children: [
          Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome,
                  color: theme.colorScheme.secondary, size: 16),
              const SizedBox(width: 8),
              Text("AI Research",
                  style: theme.textTheme.labelLarge
                      ?.copyWith(letterSpacing: 1.0)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Surah ${surah.englishName} : ${ayah.numberInSurah}",
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.tertiary),
          ),
        ],
      ),
    );
  }
}

class ResearchInputArea extends StatelessWidget {
  final TextEditingController controller;
  final Function(String mode) onSend;

  const ResearchInputArea({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
            border: Border(top: BorderSide(color: theme.colorScheme.outline)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ActionChip(
                        label: "Grammar",
                        icon: Icons.spellcheck,
                        onTap: () => onSend('grammar')),
                    const SizedBox(width: 8),
                    _ActionChip(
                        label: "History",
                        icon: Icons.history_edu,
                        onTap: () => onSend('history')),
                    const SizedBox(width: 8),
                    _ActionChip(
                        label: "Reflect",
                        icon: Icons.light_mode,
                        onTap: () => onSend('insight')),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(Icons.mic,
                              size: 20, color: theme.colorScheme.tertiary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              style:
                                  TextStyle(color: theme.colorScheme.onSurface),
                              decoration: InputDecoration(
                                hintText: "Ask AI...",
                                hintStyle: TextStyle(
                                    color: theme.colorScheme.tertiary),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 4),
                              ),
                              onSubmitted: (_) => onSend('text'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => onSend('text'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.secondary,
                      child: Icon(Icons.arrow_upward,
                          color: theme.colorScheme.onSecondary),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionChip(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.outline)),
            child: Row(children: [
              Icon(icon, size: 14, color: theme.colorScheme.secondary),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: theme.colorScheme.onSurface))
            ]),
          ),
        ),
      ),
    );
  }
}

class MessageItemRenderer extends StatelessWidget {
  final ResearchMessage message;
  final Function(String content)? onReport;
  const MessageItemRenderer({super.key, required this.message, this.onReport});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Text(
              (message.content is TextContent)
                  ? (message.content as TextContent).text
                  : "...",
              style: TextStyle(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.w600)),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 14,
              backgroundColor: theme.colorScheme.surface,
              child: Icon(Icons.auto_awesome,
                  size: 16, color: theme.colorScheme.secondary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("AI ASSISTANT",
                        style: theme.textTheme.labelSmall
                            ?.copyWith(fontSize: 10, letterSpacing: 1.5)),
                    // REPORT BUTTON
                    if (onReport != null)
                      InkWell(
                        onTap: () {
                          // Trigger Report
                          onReport?.call(message.content is TextContent
                              ? (message.content as TextContent).text
                              : "Reporting non-text content");
                        },
                        child: Icon(Icons.flag_outlined,
                            size: 14,
                            color: theme.colorScheme.tertiary.withValues(alpha: 0.5)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (message.isTyping &&
                    message.content is TextContent &&
                    (message.content as TextContent).text == "...")
                  Text("Thinking...",
                      style: TextStyle(
                          color: theme.colorScheme.tertiary,
                          fontStyle: FontStyle.italic))
                else
                  _renderContent(message.content),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Text Content
  Widget _renderContent(ResearchContent content) {
    if (content is TextContent) {
      return Text(content.text, style: const TextStyle(height: 1.6, color: Colors.white)); // Full white
    }
    if (content is GrammarContent) return GrammarCard(data: content);
    if (content is HistoryContent) return HistoryTimelineCard(data: content);
    if (content is InsightContent) return InsightCard(data: content);
    return const SizedBox.shrink();
  }
}

class GrammarCard extends StatefulWidget {
  final GrammarContent data;
  const GrammarCard({super.key, required this.data});

  @override
  State<GrammarCard> createState() => _GrammarCardState();
}

class _GrammarCardState extends State<GrammarCard> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outline;
    final words = widget.data.words;

    if (words.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: const Text("No grammar analysis available.", style: TextStyle(color: Colors.white)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 320,
            child: PageView.builder(
              controller: _pageController,
              itemCount: words.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return _SingleWordView(word: words[index]);
              },
            ),
          ),
          if (words.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
                color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        size: 14, color: theme.colorScheme.tertiary),
                    onPressed: _currentIndex > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        : null,
                  ),
                  Text(
                    "Word ${_currentIndex + 1} of ${words.length}",
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.tertiary, // Meta info can stay muted or be white
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        size: 14, color: theme.colorScheme.tertiary),
                    onPressed: _currentIndex < words.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SingleWordView extends StatelessWidget {
  final GrammarWord word;
  const _SingleWordView({required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outline;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor)),
            color: theme.colorScheme.surfaceContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(children: [
            Text(word.arabicWord,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(word.transliteration,
                    style: TextStyle(
                        color: theme.colorScheme.secondary, // Transliteration often distinctive, but could be white if requested. Keeping secondary as it's 'meta'.
                        fontSize: 12,
                        fontWeight: FontWeight.bold)))
          ]),
        ),
        Expanded(
          child: Column(
            children: [
              Row(children: [
                _GridItem("ROOT", word.root),
                Container(width: 1, height: 60, color: borderColor),
                _GridItem("FORM", word.form)
              ]),
              Divider(height: 1, color: borderColor),
              Row(children: [
                _GridItem("TENSE", word.tense),
                Container(width: 1, height: 60, color: borderColor),
                _GridItem("MOOD", word.mood)
              ]),
              Divider(height: 1, color: borderColor),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(word.meaning, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  final String label;
  final String value;
  const _GridItem(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.tertiary)),
              const SizedBox(height: 4),
              Text(value.isNotEmpty ? value : "-",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))
            ])));
  }
}

class HistoryTimelineCard extends StatelessWidget {
  final HistoryContent data;
  const HistoryTimelineCard({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTitle =
        data.title.trim().isEmpty ? 'Historical Context' : data.title;
    final hasEvents = data.events.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Icon(Icons.history_edu,
                  color: theme.colorScheme.secondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayTitle, style: theme.textTheme.labelLarge?.copyWith(color: Colors.white)),
                      if (data.era.isNotEmpty)
                        Text(data.era,
                            style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.tertiary))
                    ]),
              )
            ])),
        Divider(height: 1, color: theme.colorScheme.outline),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: hasEvents
                ? Column(
                    children: data.events
                        .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Icon(Icons.circle,
                                        size: 6,
                                        color: theme.colorScheme.secondary),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(e, style: const TextStyle(color: Colors.white)))
                                ])))
                        .toList())
                : Center(
                    child: Text(
                    "No specific historical events found for this context.",
                    style: TextStyle(
                        color: theme.colorScheme.tertiary,
                        fontStyle: FontStyle.italic),
                  ))),
      ]),
    );
  }
}

class InsightCard extends StatelessWidget {
  final InsightContent data;
  const InsightCard({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTitle = data.title.trim().isEmpty ? 'Insight' : data.title;
    final displayBody = data.body.trim().isEmpty
        ? 'No insights available at the moment.'
        : data.body;

    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Icon(Icons.light_mode,
                  color: theme.colorScheme.secondary, size: 20),
              const SizedBox(width: 12),
              Text("INSIGHT",
                  style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10))
            ])),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(displayTitle,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(displayBody, style: const TextStyle(height: 1.5, color: Colors.white))),
      ]),
    );
  }
}
