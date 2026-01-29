import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:alkitab_models/alkitab_models.dart';

class TafsirSheet extends StatefulWidget {
  final AyahWithTranslations ayah;
  final Surah surah;
  final double fontSize;
  final Color titleColor;
  final Map<String, String>? explicitTafsirs;
  final Map<String, Edition>? editionMap;

  const TafsirSheet({
    super.key,
    required this.ayah,
    required this.surah,
    this.fontSize = 16.0,
    required this.titleColor,
    this.explicitTafsirs,
    this.editionMap,
  });

  @override
  State<TafsirSheet> createState() => _TafsirSheetState();
}

class _TafsirSheetState extends State<TafsirSheet> with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, String> _data;
  
  @override
  void initState() {
    super.initState();
    _data = widget.explicitTafsirs ?? widget.ayah.tafsirs;
    _tabController = TabController(length: _data.length, vsync: this);
    _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
             setState(() {}); // Rebuild to Switch displayed content
        }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Refresh data in case of rebuilds (though usually static in this sheet)
    _data = widget.explicitTafsirs ?? widget.ayah.tafsirs;
    
    // Ensure controller matches data length (if changed vaguely possible)
    if (_data.length != _tabController.length) {
      _tabController.dispose();
      _tabController = TabController(length: _data.length, vsync: this);
      _tabController.addListener(() => setState((){}));
    }

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                   color: theme.colorScheme.surface,
                   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(EvaIcons.bulb_outline, color: widget.titleColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tafsir / Commentary", style: theme.textTheme.labelLarge),
                              Text(
                                "${widget.surah.englishName} : ${widget.ayah.numberInSurah}",
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
                    
                    if (_data.length > 1) ...[
                        const SizedBox(height: 12),
                        TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            indicatorColor: widget.titleColor,
                            labelColor: widget.titleColor,
                            unselectedLabelColor: theme.colorScheme.tertiary,
                            dividerColor: Colors.transparent,
                            tabs: _data.keys.map((key) {
                                final edition = widget.editionMap?[key];
                                final authorName = edition?.englishName ?? edition?.name ?? "Unknown";
                                return Tab(text: authorName);
                            }).toList(),
                            onTap: (index) {
                                setState(() {}); // Trigger rebuild of body
                            },
                        ),
                    ] else const SizedBox(height: 16),
                  ]
                ),
              ),
              const Divider(height: 1),
              
              // Content - Displaying ONLY the selected tab's content
              // We do not use TabBarView because we need to attach the single 'scrollController'
              // from DraggableScrollableSheet to the active list.
              Expanded(
                child: Builder(
                    builder: (_) {
                        final currentIndex = _tabController.index;
                        final key = _data.keys.elementAt(currentIndex);
                        final text = _data.values.elementAt(currentIndex);
                        final isUrdu = key.startsWith('ur'); 
                        
                        return ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.all(20),
                            children: [
                                Text(
                                   text,
                                   textAlign: TextAlign.justify,
                                   textDirection: TextDirection.rtl,
                                   style: theme.textTheme.bodyMedium?.copyWith(
                                       fontSize: widget.fontSize,
                                       height: isUrdu ? 2.2 : 1.8,
                                       fontFamily: isUrdu ? 'Gulzar' : null,
                                       color: Colors.white, // Full white as requested
                                   ),
                                ),
                            ]
                        );
                    }
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
