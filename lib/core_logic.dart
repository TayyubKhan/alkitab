// // lib/core_logic.dart
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:flutter/foundation.dart'; // For kDebugMode, compute
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart';
// import 'package:logger/logger.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// part 'core_logic.g.dart';
//
// // ──────────────────────────────────────────────────
// //  PROPER LOGGING SERVICE
// // ──────────────────────────────────────────────────
// class AppLogger {
//   static final Logger _logger = Logger(
//     printer: PrettyPrinter(
//       methodCount: 0,
//       errorMethodCount: 8,
//       lineLength: 120,
//       colors: true,
//       printEmojis: true,
//       printTime: true,
//     ),
//     filter: _ProductionFilter(),
//   );
//
//   static void d(String message) => _logger.d(message);
//   static void i(String message) => _logger.i(message);
//   static void w(String message, [dynamic error, StackTrace? stackTrace]) =>
//       _logger.w(message, error: error, stackTrace: stackTrace);
//   static void e(String message, [dynamic error, StackTrace? stackTrace]) =>
//       _logger.e(message, error: error, stackTrace: stackTrace);
// }
//
// class _ProductionFilter extends LogFilter {
//   @override
//   bool shouldLog(LogEvent event) => true;
// }
//
// // ──────────────────────────────────────────────────
// //  MODELS
// // ──────────────────────────────────────────────────
//
// class AyahWithTranslations {
//   final int numberInSurah;
//   final String arabicText;
//   final String? tajweedText;
//   final Map<String, String> translations;
//   final Map<String, String> tafsirs;
//   final String? audioUrl;
//   final List<AyahWord> words;
//   final String? transliteration;
//
//   AyahWithTranslations({
//     required this.numberInSurah,
//     required this.arabicText,
//     this.tajweedText,
//     required this.translations,
//     required this.tafsirs,
//     this.audioUrl,
//     required this.words,
//     this.transliteration,
//   });
//
//   // Helper for AudioSource Tag parsing
//   factory AyahWithTranslations.fromJson(Map<String, dynamic> json) =>
//       AyahWithTranslations(
//         numberInSurah: json['numberInSurah'] as int,
//         arabicText: '', // Placeholder, not needed for audio state lookup
//         translations: {},
//         tafsirs: {},
//         words: [],
//       );
// }
//
// class Surah {
//   final int number;
//   final String name;
//   final String englishName;
//   final String englishNameTranslation;
//   final String revelationType;
//   final int numberOfAyahs;
//   Surah(
//       {required this.number,
//       required this.name,
//       required this.englishName,
//       required this.englishNameTranslation,
//       required this.revelationType,
//       required this.numberOfAyahs});
//   factory Surah.fromData(SurahsData d) => Surah(
//       number: d.number,
//       name: d.name,
//       englishName: d.englishName,
//       englishNameTranslation: d.englishNameTranslation,
//       revelationType: d.revelationType,
//       numberOfAyahs: d.numberOfAyahs);
// }
//
// class AyahWord {
//   final int wordNumber;
//   final String arabicText;
//   final String translation;
//   final String transliteration;
//   final String? localAudioPath;
//   // REMOVED: final String? root;
//   AyahWord({
//     required this.wordNumber,
//     required this.arabicText,
//     required this.translation,
//     required this.transliteration,
//     this.localAudioPath,
//     /* REMOVED: this.root */
//   });
//   factory AyahWord.fromData(WordTranslation d) => AyahWord(
//         wordNumber: d.wordNumber,
//         arabicText: d.arabicText,
//         translation: d.translation,
//         transliteration: d.transliteration,
//         localAudioPath: d.localAudioPath,
//         // REMOVED: root: d.rootText
//       );
// }
//
// class Edition {
//   final String identifier;
//   final String language;
//   final String name;
//   final String englishName;
//   final String type;
//   Edition(
//       {required this.identifier,
//       required this.language,
//       required this.name,
//       required this.englishName,
//       required this.type});
//   factory Edition.fromJson(Map<String, dynamic> json) => Edition(
//         identifier: json['id'].toString(),
//         language: json['language_name'] ?? 'en',
//         name: json['name'],
//         englishName: json['author_name'],
//         type: json['type'] ?? 'translation',
//       );
//   factory Edition.fromData(CachedEdition d) => Edition(
//       identifier: d.identifier,
//       language: d.language,
//       name: d.name,
//       englishName: d.englishName,
//       type: d.type);
//   CachedEditionsCompanion toCompanion() => CachedEditionsCompanion(
//       identifier: Value(identifier),
//       language: Value(language),
//       name: Value(name),
//       englishName: Value(englishName),
//       type: Value(type));
// }
//
// class Reciter {
//   final String identifier;
//   final String language;
//   final String name;
//   final String englishName;
//   Reciter(
//       {required this.identifier,
//       required this.language,
//       required this.name,
//       required this.englishName});
//   factory Reciter.fromJson(Map<String, dynamic> j) => Reciter(
//       identifier: j['id'].toString(),
//       language: 'ar',
//       name: j['reciter_name'],
//       englishName: j['style'] ?? j['reciter_name']);
//   factory Reciter.fromData(CachedReciter d) => Reciter(
//       identifier: d.identifier,
//       language: d.language,
//       name: d.name,
//       englishName: d.englishName);
//   CachedRecitersCompanion toCompanion() => CachedRecitersCompanion(
//       identifier: Value(identifier),
//       language: Value(language),
//       name: Value(name),
//       englishName: Value(englishName));
// }
//
// // ──────────────────────────────────────────────────
// //  DATABASE
// // ──────────────────────────────────────────────────
// @DataClassName('SurahsData')
// class Surahs extends Table {
//   IntColumn get number => integer()();
//   TextColumn get name => text()();
//   TextColumn get englishName => text()();
//   TextColumn get englishNameTranslation => text()();
//   TextColumn get revelationType => text()();
//   IntColumn get numberOfAyahs => integer()();
// }
//
// class Ayahs extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get surahNumber => integer()();
//   IntColumn get numberInSurah => integer()();
//   TextColumn get textContent => text()();
//   TextColumn get tajweedText => text().nullable()();
//   IntColumn get juz => integer()();
//   IntColumn get manzil => integer()();
//   IntColumn get page => integer()();
//   IntColumn get ruku => integer()();
//   IntColumn get hizbQuarter => integer()();
// }
//
// @DataClassName('Translation')
// class Translations extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get surahNumber => integer()();
//   IntColumn get numberInSurah => integer()();
//   TextColumn get edition => text()();
//   TextColumn get textContent => text()();
// }
//
// @DataClassName('WordTranslation')
// class WordTranslations extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get surahNumber => integer()();
//   IntColumn get numberInSurah => integer()();
//   IntColumn get wordNumber => integer()();
//   TextColumn get edition => text()();
//   TextColumn get arabicText => text()();
//   TextColumn get translation => text()();
//   TextColumn get transliteration => text()();
//   TextColumn get audioUrl => text().nullable()();
//   TextColumn get localAudioPath => text().nullable()();
// // REMOVED: TextColumn get rootText => text().nullable()();
// }
//
// @DataClassName('DownloadedAudio')
// class DownloadedAudios extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get surahNumber => integer()();
//   IntColumn get numberInSurah => integer()();
//   TextColumn get reciterIdentifier => text()();
//   TextColumn get localPath => text()();
//   @override
//   List<String> get customConstraints =>
//       ['UNIQUE(surah_number, number_in_surah, reciter_identifier)'];
// }
//
// @DataClassName('AiCacheEntry')
// class AiCache extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get surahNumber => integer()();
//   IntColumn get numberInSura => integer()();
//   TextColumn get question => text()();
//   TextColumn get response => text()();
//   DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
//   @override
//   List<String> get customConstraints =>
//       ['UNIQUE(surah_number, number_in_sura, question)'];
// }
//
// @DataClassName('CachedEdition')
// class CachedEditions extends Table {
//   TextColumn get identifier => text()();
//   TextColumn get language => text()();
//   TextColumn get name => text()();
//   TextColumn get englishName => text()();
//   TextColumn get type => text()();
//   @override
//   Set<Column> get primaryKey => {identifier};
// }
//
// @DataClassName('CachedReciter')
// class CachedReciters extends Table {
//   TextColumn get identifier => text()();
//   TextColumn get language => text()();
//   TextColumn get name => text()();
//   TextColumn get englishName => text()();
//   @override
//   Set<Column> get primaryKey => {identifier};
// }
//
// @DriftDatabase(tables: [
//   Surahs,
//   Ayahs,
//   Translations,
//   WordTranslations,
//   DownloadedAudios,
//   AiCache,
//   CachedEditions,
//   CachedReciters
// ])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());
//   @override
//   // Schema version 5 after removing roots (was 6)
//   int get schemaVersion => 5;
//   @override
//   MigrationStrategy get migration => MigrationStrategy(
//         onCreate: (m) async {
//           AppLogger.i("DB: Creating all tables on first launch.");
//           await m.createAll();
//         },
//         onUpgrade: (m, from, to) async {
//           AppLogger.i("DB: Migrating from schema $from to $to.");
//           if (from < 2) await m.createTable(aiCache);
//           if (from < 3) {
//             await m.createTable(cachedEditions);
//             await m.createTable(cachedReciters);
//           }
//           if (from < 4) {
//             await m.addColumn(wordTranslations, wordTranslations.audioUrl);
//             await m.addColumn(
//                 wordTranslations, wordTranslations.localAudioPath);
//           }
//           if (from < 5) {
//             await m.addColumn(ayahs, ayahs.tajweedText);
//           }
//           // Migration to 6 (rootText) is intentionally skipped/removed
//         },
//       );
//
//   Future<void> addSurahs(List<SurahsCompanion> l) async {
//     AppLogger.d("DB: Batch inserting/replacing ${l.length} surahs.");
//     return batch(
//         (b) => b.insertAll(surahs, l, mode: InsertMode.insertOrReplace));
//   }
//
//   Future<void> addAyahs(List<AyahsCompanion> l) async {
//     AppLogger.d("DB: Batch inserting/replacing ${l.length} ayahs.");
//     return batch(
//         (b) => b.insertAll(ayahs, l, mode: InsertMode.insertOrReplace));
//   }
//
//   Future<void> addTranslations(List<TranslationsCompanion> l) async {
//     AppLogger.d("DB: Batch inserting/replacing ${l.length} translations.");
//     return batch(
//         (b) => b.insertAll(translations, l, mode: InsertMode.insertOrReplace));
//   }
//
//   Future<void> addWordTranslations(List<WordTranslationsCompanion> l) async {
//     AppLogger.d("DB: Batch inserting/replacing ${l.length} word translations.");
//     return batch((b) =>
//         b.insertAll(wordTranslations, l, mode: InsertMode.insertOrReplace));
//   }
//
//   Future<void> addDownloadedAudio(List<DownloadedAudiosCompanion> l) async {
//     AppLogger.d(
//         "DB: Batch inserting/replacing ${l.length} downloaded audio entries.");
//     return batch((b) =>
//         b.insertAll(downloadedAudios, l, mode: InsertMode.insertOrReplace));
//   }
//
//   Future<void> addCachedEditions(List<CachedEditionsCompanion> l) async {
//     AppLogger.d("DB: Batch inserting/replacing ${l.length} cached editions.");
//     return batch((b) =>
//         b.insertAll(cachedEditions, l, mode: InsertMode.insertOrReplace));
//   }
//
//   Future<void> addCachedReciters(List<CachedRecitersCompanion> l) async {
//     AppLogger.d("DB: Batch inserting/replacing ${l.length} cached reciters.");
//     return batch((b) =>
//         b.insertAll(cachedReciters, l, mode: InsertMode.insertOrReplace));
//   }
//
//   Future<List<SurahsData>> getAllSurahs() {
//     AppLogger.d("DB: Fetching all surahs.");
//     return select(surahs).get();
//   }
//
//   Future<SurahsData?> getSurahByNumber(int n) {
//     AppLogger.d("DB: Fetching surah number $n.");
//     return (select(surahs)..where((s) => s.number.equals(n))).getSingleOrNull();
//   }
//
//   Future<List<CachedEdition>> getAllCachedEditions() {
//     AppLogger.d("DB: Fetching all cached editions.");
//     return select(cachedEditions).get();
//   }
//
//   Future<List<CachedReciter>> getAllCachedReciters() {
//     AppLogger.d("DB: Fetching all cached reciters.");
//     return select(cachedReciters).get();
//   }
//
//   Future<bool> isBaseDataDownloaded() async {
//     final s = await select(surahs).get().then((v) => v.length);
//     final a = await select(ayahs).get().then((v) => v.length);
//     AppLogger.d("DB Check: Surahs found: $s/114, Ayahs found: $a/6236+");
//     return s == 114 && a >= 6236;
//   }
//
//   Future<bool> isEditionDownloaded(String id) async {
//     final c = await (select(translations)..where((t) => t.edition.equals(id)))
//         .get()
//         .then((v) => v.length);
//     AppLogger.d("DB Check: Edition $id found $c/6000+ entries.");
//     return c > 6000;
//   }
//
//   Future<bool> isWbWEditionDownloaded(String id) async {
//     final c = await (select(wordTranslations)
//           ..where((t) => t.edition.equals(id)))
//         .get()
//         .then((v) => v.length);
//     AppLogger.d("DB Check: WbW Edition $id found $c/77000+ entries.");
//     return c >= 77000;
//   }
//
//   Future<Map<int, String>> getDownloadedAudioPaths(int s, String r) async {
//     AppLogger.d("DB: Fetching audio paths for Surah $s, Reciter $r.");
//     final f = await (select(downloadedAudios)
//           ..where(
//               (a) => a.surahNumber.equals(s) & a.reciterIdentifier.equals(r)))
//         .get();
//     AppLogger.d("DB: Found ${f.length} downloaded audio files.");
//     return {for (var file in f) file.numberInSurah: file.localPath};
//   }
//
//   Future<String?> getCachedAiResponse(int s, int a, String q) async {
//     AppLogger.d("DB: Checking AI cache for S$s:A$a, Question: $q.");
//     final e = await (select(aiCache)
//           ..where((t) =>
//               t.surahNumber.equals(s) &
//               t.numberInSura.equals(a) &
//               t.question.equals(q)))
//         .getSingleOrNull();
//     AppLogger.d("DB: AI Cache result: ${e != null ? 'Hit' : 'Miss'}");
//     return e?.response;
//   }
//
//   Future<List<AiCacheEntry>> getCachedResponsesForAyah(int s, int a) async {
//     AppLogger.d("DB: Fetching AI history for S$s:A$a.");
//     return await (select(aiCache)
//           ..where((t) => t.surahNumber.equals(s) & t.numberInSura.equals(a))
//           ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
//         .get();
//   }
//
//   Future<void> cacheAiResponse(int s, int a, String q, String r) async {
//     AppLogger.i("DB: Caching AI response for S$s:A$a.");
//     await into(aiCache).insert(
//         AiCacheCompanion(
//             surahNumber: Value(s),
//             numberInSura: Value(a),
//             question: Value(q),
//             response: Value(r)),
//         mode: InsertMode.insertOrReplace);
//   }
//
//   // UPDATED: Added reciterIdentifier argument
//   Future<List<AyahWithTranslations>> getAyahsForSurah(
//       int surahNumber,
//       List<String> editionIdentifiers,
//       String? wordByWordEdition,
//       String? reciterIdentifier) async {
//     AppLogger.i(
//         "DB: Starting complex fetch for S$surahNumber. Editions: $editionIdentifiers, WbW: $wordByWordEdition, Reciter: $reciterIdentifier");
//
//     final arabic = await (select(ayahs)
//           ..where((a) => a.surahNumber.equals(surahNumber))
//           ..orderBy([(a) => OrderingTerm.asc(a.numberInSurah)]))
//         .get();
//     AppLogger.d("DB Fetch: Found ${arabic.length} Arabic Ayahs.");
//
//     final List<Translation> rawData = await (select(translations)
//           ..where((t) =>
//               t.surahNumber.equals(surahNumber) &
//               t.edition.isIn(editionIdentifiers)))
//         .get();
//     AppLogger.d(
//         "DB Fetch: Found ${rawData.length} translation/tafsir entries for active editions.");
//
//     final editions = await select(cachedEditions).get();
//     final editionTypeMap = {for (var e in editions) e.identifier: e.type};
//
//     const String translitEdition = 'transliteration';
//     final List<Translation> translitData = await (select(translations)
//           ..where((t) =>
//               t.surahNumber.equals(surahNumber) &
//               t.edition.equals(translitEdition)))
//         .get();
//     final translitMap = {
//       for (var t in translitData) t.numberInSurah: t.textContent
//     };
//     AppLogger.d(
//         "DB Fetch: Found ${translitData.length} transliteration entries.");
//
//     final List<WordTranslation> wordData;
//     if (wordByWordEdition != null) {
//       AppLogger.d(
//           "DB Fetch: Fetching WbW data for edition: $wordByWordEdition");
//       wordData = await (select(wordTranslations)
//             ..where((w) =>
//                 w.surahNumber.equals(surahNumber) &
//                 w.edition.equals(wordByWordEdition))
//             ..orderBy([
//               (w) => OrderingTerm.asc(w.numberInSurah),
//               (w) => OrderingTerm.asc(w.wordNumber)
//             ]))
//           .get();
//       AppLogger.d("DB Fetch: Found ${wordData.length} total word entries.");
//     } else {
//       wordData = [];
//       AppLogger.d("DB Fetch: WbW edition is null, skipping word data fetch.");
//     }
//
//     final groupedTranslations = <String, Map<int, String>>{};
//     final groupedTafsirs = <String, Map<int, String>>{};
//
//     for (final t in rawData) {
//       final type = editionTypeMap[t.edition] ?? 'translation';
//       if (type == 'tafsir') {
//         groupedTafsirs.putIfAbsent(t.edition, () => {});
//         groupedTafsirs[t.edition]![t.numberInSurah] = t.textContent;
//       } else {
//         groupedTranslations.putIfAbsent(t.edition, () => {});
//         groupedTranslations[t.edition]![t.numberInSurah] = t.textContent;
//       }
//     }
//
//     final groupedWords = <int, List<AyahWord>>{};
//     for (final w in wordData) {
//       groupedWords.putIfAbsent(w.numberInSurah, () => []);
//       groupedWords[w.numberInSurah]!.add(AyahWord.fromData(w));
//     }
//     AppLogger.d("DB Fetch: Grouped words into ${groupedWords.length} ayahs.");
//
//     // --- NEW AUDIO URL GENERATION ---
//     const String audioCdnBase = 'https://cdn.islamic.network/quran/audio/';
//
//     AppLogger.i("DB: Finished processing all data for Ayah list creation.");
//     return arabic.map((a) {
//       final ayahTranslations = <String, String>{};
//       final ayahTafsirs = <String, String>{};
//
//       for (final eid in editionIdentifiers) {
//         final txt = groupedTranslations[eid]?[a.numberInSurah];
//         if (txt != null) ayahTranslations[eid] = txt;
//         final taf = groupedTafsirs[eid]?[a.numberInSurah];
//         if (taf != null) ayahTafsirs[eid] = taf;
//       }
//
//       String? calculatedAudioUrl;
//       // Note: Reciter audio often uses the full verse ID (1-6236). We use the
//       // Ayahs.id (autoincrement) assuming it maps to the global verse ID.
//       if (reciterIdentifier != null) {
//         calculatedAudioUrl = '$audioCdnBase$reciterIdentifier/${a.id}.mp3';
//       }
//
//       return AyahWithTranslations(
//         numberInSurah: a.numberInSurah,
//         arabicText: a.textContent,
//         tajweedText: a.tajweedText,
//         translations: ayahTranslations,
//         tafsirs: ayahTafsirs,
//         words: groupedWords[a.numberInSurah] ?? [],
//         transliteration: translitMap[a.numberInSurah],
//         audioUrl: calculatedAudioUrl, // <--- ADDED remote URL
//       );
//     }).toList();
//   }
// }
//
// LazyDatabase _openConnection() => LazyDatabase(() async {
//       final dir = await getApplicationDocumentsDirectory();
//       final dbPath = p.join(dir.path, 'quran.sqlite');
//       AppLogger.i("DB: Initializing NativeDatabase at path: $dbPath");
//       return NativeDatabase(File(dbPath), logStatements: false);
//     });
// final databaseProvider = Provider<AppDatabase>((ref) {
//   AppLogger.d("Riverpod: Providing AppDatabase instance.");
//   return AppDatabase();
// });
// final sharedPreferencesProvider =
//     Provider<SharedPreferences>((ref) => throw UnimplementedError());
// final audioPlayerProvider = Provider<AudioPlayer>((ref) {
//   final p = AudioPlayer();
//   AppLogger.i("AudioPlayer initialized.");
//   ref.onDispose(() {
//     AppLogger.i("AudioPlayer disposed.");
//     p.dispose();
//   });
//   return p;
// });
// const String _kBaseDataDownloadedKey = 'is_base_data_v11_complete';
//
// // ──────────────────────────────────────────────────
// //  AUDIO CONTROL (Existing logic for Surah/Ayah play is good)
// // ──────────────────────────────────────────────────
// class AudioControlState {
//   final bool isPlaying;
//   final bool
//       isSurahMode; // True for continuous Surah play, false for single Ayah
//   final int? currentSurah;
//   final int? currentAyah;
//   final Duration? position;
//   final Duration? duration;
//
//   AudioControlState({
//     this.isPlaying = false,
//     this.isSurahMode = false,
//     this.currentSurah,
//     this.currentAyah,
//     this.position,
//     this.duration,
//   });
//
//   AudioControlState copyWith({
//     bool? isPlaying,
//     bool? isSurahMode,
//     int? currentSurah,
//     int? currentAyah,
//     Duration? position,
//     Duration? duration,
//   }) {
//     return AudioControlState(
//       isPlaying: isPlaying ?? this.isPlaying,
//       isSurahMode: isSurahMode ?? this.isSurahMode,
//       currentSurah: currentSurah ?? this.currentSurah,
//       currentAyah: currentAyah ?? this.currentAyah,
//       position: position ?? this.position,
//       duration: duration ?? this.duration,
//     );
//   }
// }
//
// class AudioControlNotifier extends Notifier<AudioControlState> {
//   late final AudioPlayer _player;
//   StreamSubscription? _playerStateSubscription;
//
//   @override
//   AudioControlState build() {
//     _player = ref.watch(audioPlayerProvider);
//     _playerStateSubscription = _player.playerStateStream.listen((state) {
//       // 1. Handle playback state update
//       final isPlaying = state.playing;
//       final isCompleted = state.processingState == ProcessingState.completed;
//
//       // Update basic playback state
//       this.state = this.state.copyWith(isPlaying: isPlaying);
//
//       // 2. Handle Surah completion and Ayah change
//       final audioSource = _player.audioSource;
//       if (audioSource is ConcatenatingAudioSource) {
//         final currentSequence = audioSource.sequence;
//         final currentIndex = _player.currentIndex;
//
//         if (currentIndex != null && currentIndex < currentSequence.length) {
//           // Note: The tag is already a Map<String, dynamic> from AudioSource.uri tag
//           final tag =
//               currentSequence[currentIndex].tag as Map<String, dynamic>?;
//           final currentAyahNum = tag?['numberInSurah'] as int?;
//           final currentSurahNum = tag?['surahNumber'] as int?;
//
//           if (currentAyahNum != this.state.currentAyah) {
//             this.state = this.state.copyWith(
//                   currentAyah: currentAyahNum,
//                   currentSurah:
//                       currentSurahNum, // Ensure surah is set correctly here too
//                 );
//           }
//         } else if (isCompleted) {
//           // Entire playlist finished
//           this.state = AudioControlState(); // Reset state
//         }
//       } else if (isCompleted) {
//         // Single Ayah finished
//         this.state = AudioControlState(); // Reset state
//       }
//     });
//
//     // 3. Listen to position and duration streams
//     _player.positionStream.listen((p) {
//       this.state = this.state.copyWith(position: p);
//     });
//     _player.durationStream.listen((d) {
//       this.state = this.state.copyWith(duration: d);
//     });
//
//     ref.onDispose(() {
//       _playerStateSubscription?.cancel();
//     });
//
//     return AudioControlState();
//   }
//
//   Future<void> setSurahPlaylistAndPlay(
//       int surahNumber, List<AyahWithTranslations> ayahs) async {
//     final playlist = ayahs
//         .where((a) => a.audioUrl != null)
//         .map((a) => AudioSource.uri(
//               Uri.parse(a.audioUrl!),
//               tag: {
//                 'surahNumber': surahNumber,
//                 'numberInSurah': a.numberInSurah
//               },
//             ))
//         .toList();
//
//     if (playlist.isEmpty) {
//       AppLogger.w("Audio: Playlist is empty for S$surahNumber.");
//       return;
//     }
//
//     // Stop any existing playback
//     await _player.stop();
//
//     AppLogger.i(
//         "Audio: Setting full Surah playlist (S$surahNumber) with ${playlist.length} items.");
//
//     await _player.setAudioSource(ConcatenatingAudioSource(children: playlist),
//         initialIndex: 0, initialPosition: Duration.zero);
//
//     await _player.play();
//     state = state.copyWith(
//       isPlaying: true,
//       isSurahMode: true,
//       currentSurah: surahNumber,
//       // Find the ayah number of the very first audio item
//       currentAyah:
//           (playlist.first.tag as Map<String, dynamic>?)?['numberInSurah'],
//     );
//   }
//
//   Future<void> playAyah(
//       int surahNumber, int ayahNumber, String audioUrl) async {
//     AppLogger.i("Audio: Playing single Ayah $surahNumber:$ayahNumber.");
//
//     // Check if the same ayah is already loaded and paused
//     if (state.currentSurah == surahNumber &&
//         state.currentAyah == ayahNumber &&
//         !_player.playing) {
//       AppLogger.i("Audio: Resuming same single Ayah $surahNumber:$ayahNumber.");
//       await _player.play();
//       state = state.copyWith(isPlaying: true);
//       return;
//     }
//
//     // Stop any existing playback and start the new one
//     await _player.stop();
//
//     await _player.setAudioSource(
//       AudioSource.uri(
//         Uri.parse(audioUrl),
//         tag: {'surahNumber': surahNumber, 'numberInSurah': ayahNumber},
//       ),
//     );
//     await _player.play();
//     state = state.copyWith(
//       isPlaying: true,
//       isSurahMode: false,
//       currentSurah: surahNumber,
//       currentAyah: ayahNumber,
//     );
//   }
//
//   void playPause() {
//     if (_player.playing) {
//       AppLogger.i("Audio: Paused playback.");
//       _player.pause();
//     } else {
//       AppLogger.i("Audio: Resumed playback.");
//       _player.play();
//     }
//   }
//
//   Future<void> stop() async {
//     AppLogger.i("Audio: Stopped playback.");
//     await _player.stop();
//     state = AudioControlState();
//   }
// }
//
// final audioControlProvider =
//     NotifierProvider<AudioControlNotifier, AudioControlState>(
//         AudioControlNotifier.new);
//
// // ──────────────────────────────────────────────────
// //  REPOSITORY
// // ──────────────────────────────────────────────────
// class QuranRepository {
//   final AppDatabase _db;
//   final SharedPreferences _prefs;
//   final http.Client _client;
//   static const String _baseUrl = 'https://api.quran.com/api/v4';
//
//   final _wbwMap = {for (var e in wbwOptionsList) e.id: e.langCode};
//
//   QuranRepository(this._db, this._prefs, this._client);
//
//   Future<bool> isBaseDataDownloaded() async {
//     final prefCheck = _prefs.getBool(_kBaseDataDownloadedKey) ?? false;
//     AppLogger.d("Repo Check: Prefs base data key status: $prefCheck");
//     // If preference is true, verify the database count (fast)
//     if (prefCheck) return await _db.isBaseDataDownloaded();
//
//     // If preference is false, assume not downloaded.
//     return false;
//   }
//
//   Future<void> _markBaseDataAsDownloaded() async {
//     AppLogger.i(
//         "Repo: Marking base data download complete in SharedPreferences.");
//     await _prefs.setBool(_kBaseDataDownloadedKey, true);
//   }
//
//   Future<http.Response> _getWithRetry(String url) async {
//     AppLogger.d("Net: Attempting GET with retry: $url");
//     for (int i = 0; i < 3; i++) {
//       try {
//         final r = await _client
//             .get(Uri.parse(url))
//             .timeout(const Duration(seconds: 30));
//         if (r.statusCode == 200) {
//           AppLogger.d("Net: Success (200) on attempt ${i + 1}");
//           return r;
//         }
//         AppLogger.w(
//             "Net: API Status ${r.statusCode} for $url. Retrying in ${i + 1}s.");
//       } catch (e) {
//         AppLogger.w("Net: API Retry ${i + 1} for $url: $e");
//       }
//       await Future.delayed(Duration(seconds: (i + 1) * 2));
//     }
//     AppLogger.e('Net: Failed API after 3 retries: $url');
//     throw Exception('Failed API after 3 retries: $url');
//   }
//
//   Future<bool> _isConnected() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     final isConnected = !connectivityResult.contains(ConnectivityResult.none);
//     AppLogger.d("Net Check: Internet connectivity status: $isConnected");
//     return isConnected;
//   }
//
//   Future<void> downloadAndStoreTranslation(
//       String id, ValueSetter<String> p) async {
//     AppLogger.i("Requesting download for Edition: $id");
//
//     if (_wbwMap.containsKey(id)) {
//       // If the requested ID is a WbW edition, use the dedicated WbW downloader.
//       AppLogger.i("Repo: Starting WbW download for $id.");
//       await _downloadWordByWordData(_wbwMap[id]!, id, p);
//       return; // Exit after WbW download
//     }
//
//     // Default logic for standard translations/tafsir
//     final cached = await _db.getAllCachedEditions();
//     final edition = cached.firstWhere((e) => e.identifier == id,
//         orElse: () => CachedEdition(
//             identifier: id,
//             language: 'en',
//             name: 'Unknown',
//             englishName: 'Unknown',
//             type: 'translation'));
//
//     if (edition.type == 'tafsir') {
//       AppLogger.i("Repo: Starting Tafsir download for $id.");
//       await _downloadFullQuranTafsir(id, p);
//     } else {
//       // The customId and apiId are the same for non-transliteration translations
//       await _downloadFullQuranTranslation(id, id, p);
//     }
//   }
//
//   Future<List<Edition>> getAllTranslationEditions() async {
//     final c = await _db.getAllCachedEditions();
//     if (c.isNotEmpty) {
//       AppLogger.d("Repo: Returned ${c.length} cached editions.");
//       return c.map(Edition.fromData).toList();
//     }
//     AppLogger.i("Repo: Fetching all editions/tafsirs from API.");
//     final r1 = await _getWithRetry('$_baseUrl/resources/translations');
//     final r2 = await _getWithRetry('$_baseUrl/resources/tafsirs');
//     final d1 = (json.decode(r1.body) as Map)['translations'] as List;
//     final d2 = (json.decode(r2.body) as Map)['tafsirs'] as List;
//     final e1 =
//         d1.map((e) => Edition.fromJson({...e, 'type': 'translation'})).toList();
//     final e2 =
//         d2.map((e) => Edition.fromJson({...e, 'type': 'tafsir'})).toList();
//     final all = [...e1, ...e2];
//     AppLogger.i("Repo: Found ${all.length} total editions. Caching them.");
//     await _db.addCachedEditions(all.map((e) => e.toCompanion()).toList());
//     return all;
//   }
//
//   Future<List<Reciter>> getAllReciters() async {
//     final c = await _db.getAllCachedReciters();
//     if (c.isNotEmpty) {
//       AppLogger.d("Repo: Returned ${c.length} cached reciters.");
//       return c.map(Reciter.fromData).toList();
//     }
//     AppLogger.i("Repo: Fetching reciters from API.");
//     final r = await _getWithRetry('$_baseUrl/resources/recitations');
//     final d = (json.decode(r.body) as Map)['recitations'] as List;
//     final l = d.map((j) => Reciter.fromJson(j)).toList();
//     AppLogger.i("Repo: Found ${l.length} reciters. Caching them.");
//     await _db.addCachedReciters(l.map((x) => x.toCompanion()).toList());
//     return l;
//   }
//
//   Future<void> downloadInitialData(
//       SetupOptions ops, ValueSetter<String> p) async {
//     AppLogger.i("Repo: Starting initial data download flow.");
//     if (!await _isConnected()) {
//       AppLogger.e("Repo: Internet check failed.");
//       throw Exception('No Internet');
//     }
//
//     if (!await isBaseDataDownloaded()) {
//       await _downloadBaseData(p);
//     } else {
//       AppLogger.i("Repo: Base data already exists. Skipping core download.");
//     }
//
//     // 1. Download/Install WbW Editions
//     final wm = {for (var e in wbwOptionsList) e.id: e.langCode};
//     for (final id in ops.wbwEditions) {
//       if (!await _db.isWbWEditionDownloaded(id)) {
//         AppLogger.i("Repo: Detected missing WbW edition: $id. Downloading.");
//         await _downloadWordByWordData(wm[id]!, id, p);
//       } else {
//         AppLogger.d(
//             "Repo: WbW edition $id already fully downloaded. Skipping.");
//       }
//     }
//
//     // 2. Download Full Editions (Translations/Tafsirs)
//     final allEditions = await getAllTranslationEditions();
//     for (final id in ops.fullEditions) {
//       if (!await _db.isEditionDownloaded(id)) {
//         AppLogger.i("Repo: Detected missing full edition: $id. Downloading.");
//         try {
//           final edition = allEditions.firstWhere((e) => e.identifier == id);
//           if (edition.type == 'tafsir') {
//             await _downloadFullQuranTafsir(edition.identifier, p);
//           } else {
//             // customId and apiId are the same for user-selected editions
//             await _downloadFullQuranTranslation(
//                 edition.identifier, edition.identifier, p);
//           }
//         } catch (e) {
//           AppLogger.w(
//               "Repo: Edition $id not found or failed to download. Skipping.");
//         }
//       } else {
//         AppLogger.d("Repo: Full edition $id already downloaded. Skipping.");
//       }
//     }
//
//     p('Complete');
//     AppLogger.i("Repo: Initial data download flow finished.");
//   }
//
//   Future<void> _downloadBaseData(ValueSetter<String> onProgress) async {
//     AppLogger.i("Repo: Starting core base data download.");
//     onProgress('Downloading structure...');
//     final r = await _getWithRetry('$_baseUrl/chapters?language=en');
//     final d = (json.decode(r.body) as Map)['chapters'] as List;
//     await _db.addSurahs(d
//         .map((s) => SurahsCompanion(
//             number: Value(s['id']),
//             name: Value(s['name_arabic']),
//             englishName: Value(s['name_simple']),
//             englishNameTranslation: Value(s['translated_name']['name']),
//             revelationType: Value(s['revelation_place']),
//             numberOfAyahs: Value(s['verses_count'])))
//         .toList());
//     AppLogger.i("Repo: Surah structure (114 chapters) downloaded and stored.");
//
//     onProgress('Downloading Arabic & Tajweed...');
//     await _downloadFullQuranArabic();
//
//     onProgress('Downloading transliteration...');
//     // Special case for transliteration: customId is 'transliteration', apiId is '131'
//     await _downloadFullQuranTranslation('transliteration', '131', (String m) {
//       // Empty or custom logging
//     });
//
//     onProgress('Downloading lists...');
//     await getAllTranslationEditions();
//     await getAllReciters();
//     await _markBaseDataAsDownloaded(); // Mark as complete ONLY here
//     AppLogger.i("Repo: Base data download complete.");
//   }
//
//   Future<void> _downloadFullQuranArabic() async {
//     if (await (_db.select(_db.ayahs)).get().then((v) => v.length) >= 6236) {
//       AppLogger.d("Repo: Arabic Ayahs already present. Skipping download.");
//       return;
//     }
//     // Fetch all Arabic verses in a single, large batch request (faster)
//     final r = await _getWithRetry(
//         '$_baseUrl/quran/verses/uthmani?fields=text_uthmani_tajweed,chapter_id,hizb_number,rub_el_hizb_number,page_number,juz_number&per_page=all');
//     final verses = (json.decode(r.body) as Map)['verses'] as List;
//     final batch = <AyahsCompanion>[];
//
//     for (var v in verses) {
//       final verseKey = v['verse_key'] as String;
//       final k = verseKey.split(':');
//       batch.add(AyahsCompanion(
//           surahNumber: Value(int.parse(k[0])),
//           numberInSurah: Value(int.parse(k[1])),
//           textContent: Value(v['text_uthmani']),
//           tajweedText: Value(v['text_uthmani_tajweed']),
//           juz: Value(v['juz_number'] ?? 0),
//           manzil: Value(0),
//           page: Value(v['page_number'] ?? 0),
//           ruku: Value(0),
//           hizbQuarter: Value(v['rub_el_hizb_number'] ?? 0)));
//     }
//     await _db.addAyahs(batch);
//     AppLogger.i(
//         "Repo: Arabic/Tajweed download complete and saved (${batch.length} entries).");
//   }
//
//   // FIX: Using single-batch call for translations
//   Future<void> _downloadFullQuranTranslation(
//       String customId, String apiId, ValueSetter<String> onProgress) async {
//     onProgress('Downloading Translation $customId...');
//     AppLogger.i(
//         "Repo: Starting **full single-batch** translation download for $customId (API ID: $apiId)");
//
//     // Using the single-batch endpoint for maximum efficiency
//     final url =
//         '$_baseUrl/quran/translations/$apiId?fields=sura_id,aya_number,text&per_page=all';
//     final resp = await _getWithRetry(url);
//     final data = json.decode(resp.body) as Map<String, dynamic>;
//     final translationsData = data['translations'] as List?;
//
//     if (translationsData == null || translationsData.isEmpty) {
//       AppLogger.e(
//           "Repo: Full translation download failed, no translation data found for $apiId.");
//       throw Exception("Failed to fetch full translation data.");
//     }
//
//     final batch = <TranslationsCompanion>[];
//
//     for (var t in translationsData) {
//       String txt = t['text'] ?? '';
//       // Remove HTML tags from the translation text
//       txt = txt.replaceAll(RegExp(r'<[^>]*>'), '').trim();
//
//       batch.add(TranslationsCompanion(
//           surahNumber: Value(t['sura_id'] as int),
//           numberInSurah: Value(t['aya_number'] as int),
//           edition:
//               Value(customId), // Use the customId ('transliteration' or API ID)
//           textContent: Value(txt)));
//     }
//
//     await _db.addTranslations(batch);
//     onProgress('Translation $customId: 100% Complete');
//     AppLogger.i(
//         "Repo: Translation $customId download complete. Inserted ${batch.length} entries.");
//   }
//
//   // FIX: Retaining Surah-by-Surah loop for Tafsir but consolidating insert.
//   Future<void> _downloadFullQuranTafsir(
//       String tafsirId, ValueSetter<String> onProgress) async {
//     onProgress('Downloading Tafsir $tafsirId...');
//     AppLogger.i("Repo: Starting Surah-by-Surah Tafsir download for $tafsirId");
//
//     for (int i = 1; i <= 114; i++) {
//       final url = '$_baseUrl/tafsirs/$tafsirId/by_chapter/$i';
//       final resp = await _getWithRetry(url);
//       final tafsirs = (json.decode(resp.body) as Map)['tafsirs'] as List;
//       final batch = <TranslationsCompanion>[];
//
//       for (var t in tafsirs) {
//         String text = t['text'] ?? '';
//         String? verseKey = t['verse_key'];
//         if (verseKey != null) {
//           final k = verseKey.split(':');
//           batch.add(TranslationsCompanion(
//             surahNumber: Value(int.parse(k[0])),
//             numberInSurah: Value(int.parse(k[1])),
//             edition: Value(tafsirId),
//             textContent: Value(text),
//           ));
//         }
//       }
//       await _db.addTranslations(batch);
//       AppLogger.d("Repo: Saved ${batch.length} tafsir entries for S$i.");
//       if (i % 10 == 0) onProgress('Tafsir $tafsirId (${i} / 114)...');
//     }
//     onProgress('Tafsir $tafsirId: 100% Complete');
//     AppLogger.i("Repo: Tafsir $tafsirId download complete.");
//   }
//
//   Future<void> _downloadWordByWordData(
//       String lang, String eid, ValueSetter<String> onProgress) async {
//     AppLogger.i("Repo: Starting WbW download for $eid (lang: $lang).");
//     final last = await (_db.select(_db.wordTranslations)
//           ..where((t) => t.edition.equals(eid))
//           ..orderBy([(t) => OrderingTerm.desc(t.surahNumber)])
//           ..limit(1))
//         .getSingleOrNull();
//
//     final start = (last?.surahNumber ?? 0) + 1;
//     if (start > 114) {
//       AppLogger.i("WbW Download for $eid already complete. Exiting.");
//       return;
//     }
//
//     AppLogger.i("Repo: Starting WbW Download ($lang) from Surah $start");
//
//     for (int i = start; i <= 114; i++) {
//       onProgress('WbW Surah $i...');
//       try {
//         final r = await _getWithRetry(
//             '$_baseUrl/verses/by_chapter/$i?language=$lang&words=true&word_translation_language=$lang&word_fields=text_uthmani,text_indopak,translation,transliteration&per_page=all');
//
//         final verses = (json.decode(r.body) as Map)['verses'] as List;
//         final batch = <WordTranslationsCompanion>[];
//         int wordCount = 0;
//         for (var v in verses) {
//           final k = (v['verse_key'].toString()).split(':');
//           final wList = v['words'] as List;
//           for (var w in wList) {
//             if (w['char_type_name'] == 'end') continue;
//             wordCount++;
//
//             batch.add(WordTranslationsCompanion(
//               surahNumber: Value(int.parse(k[0])),
//               numberInSurah: Value(int.parse(k[1])),
//               wordNumber: Value(w['position']),
//               edition: Value(eid),
//               arabicText: Value(w['text_uthmani'] ?? ''),
//               translation: Value(w['translation']['text'] ?? ''),
//               transliteration: Value(w['transliteration']['text'] ?? ''),
//               audioUrl: Value(w['audio_url']),
//               localAudioPath: Value(null),
//             ));
//           }
//         }
//         await _db.addWordTranslations(batch);
//         AppLogger.d("Repo: Saved $wordCount words for S$i.");
//       } catch (e) {
//         AppLogger.e("Failed WbW Surah $i", e);
//         throw Exception("WbW Download Failed at Surah $i: $e");
//       }
//     }
//     AppLogger.i("Repo: WbW download for $eid complete.");
//   }
//
//   Future<List<Surah>> getAllSurahs() async {
//     AppLogger.i("Repo: Fetching all Surah models.");
//     return (await _db.getAllSurahs()).map(Surah.fromData).toList();
//   }
//
//   Future<Surah?> getSurahByNumber(int n) async {
//     AppLogger.i("Repo: Fetching Surah model for number $n.");
//     final d = await _db.getSurahByNumber(n);
//     return d != null ? Surah.fromData(d) : null;
//   }
//
//   // UPDATED: Added reciterId argument
//   Future<List<AyahWithTranslations>> getAyahsForSurah(
//       int n, List<String> ids, String? wbw, String? reciterId) {
//     AppLogger.i("Repo: Requesting Ayah data from DB for Surah $n.");
//     return _db.getAyahsForSurah(
//         n, ids, wbw, reciterId); // <-- Passed new argument
//   }
//
//   Future<void> deleteAllLocalData() async {
//     AppLogger.w("Repo: !!! DANGEROUS OPERATION: Deleting ALL local data !!!");
//
//     // 1. Clear SharedPreferences flags and configs
//     await _prefs.clear();
//     AppLogger.i("Repo: SharedPreferences cleared.");
//
//     // 2. Clear all DB tables
//     await _db.customStatement('PRAGMA foreign_keys = OFF;');
//     try {
//       await _db.delete(_db.surahs).go();
//       await _db.delete(_db.ayahs).go();
//       await _db.delete(_db.translations).go();
//       await _db.delete(_db.wordTranslations).go();
//       await _db.delete(_db.downloadedAudios).go();
//       await _db.delete(_db.aiCache).go();
//       await _db.delete(_db.cachedEditions).go();
//       await _db.delete(_db.cachedReciters).go();
//       AppLogger.i("Repo: All database tables cleared.");
//     } finally {
//       await _db.customStatement('PRAGMA foreign_keys = ON;');
//     }
//
//     // 3. Delete the database file (for a cleaner slate)
//     final dir = await getApplicationDocumentsDirectory();
//     final dbFile = File(p.join(dir.path, 'quran.sqlite'));
//     if (await dbFile.exists()) {
//       await dbFile.delete();
//       AppLogger.i("Repo: Database file deleted.");
//     }
//
//     AppLogger.w(
//         "Repo: ALL data deletion complete. App is reset to initial state.");
//   }
// }
//
// final quranRepositoryProvider = Provider<QuranRepository>((ref) {
//   final db = ref.watch(databaseProvider);
//   final prefs = ref.read(sharedPreferencesProvider);
//   final client = http.Client();
//   AppLogger.d("Riverpod: Providing QuranRepository instance.");
//   ref.onDispose(client.close);
//   return QuranRepository(db, prefs, client);
// });
//
// final isWbWEditionDownloadedProvider =
//     FutureProvider.family<bool, String>((ref, id) {
//   AppLogger.d("Riverpod: Checking WbW edition download status for: $id.");
//   return ref.watch(databaseProvider).isWbWEditionDownloaded(id);
// });
//
// // ──────────────────────────────────────────────────
// //  GEMINI SERVICE
// // ──────────────────────────────────────────────────
// class GeminiService {
//   final http.Client _client;
//   final AppDatabase _db;
//   // NOTE: This API Key is public and should be replaced with a secure backend solution in production.
//   // The provided key is a placeholder and should be treated as such.
//   static const String _apiKey = 'AIzaSyBur8fAjVVulU5bnxNo0hSnyCuyusxYvDs';
//   static const String _model = 'gemini-2.5-flash';
//   GeminiService(this._client, this._db);
//
//   Stream<String> streamAyahInsight(
//       {required AyahWithTranslations ayah,
//       required int surahNumber,
//       required String userQuestion}) async* {
//     AppLogger.i(
//         "Gemini: Initiating stream for S$surahNumber:A${ayah.numberInSurah}.");
//
//     final cached = await _db.getCachedAiResponse(
//         surahNumber, ayah.numberInSurah, userQuestion);
//     if (cached != null && cached.isNotEmpty) {
//       AppLogger.i("Gemini: Cache hit. Returning cached response.");
//       yield cached;
//       return;
//     }
//     AppLogger.i("Gemini: Cache miss. Calling API.");
//
//     final prompt =
//         "Context: Surah $surahNumber:${ayah.numberInSurah}\nText: ${ayah.arabicText}\nQuestion: $userQuestion\nAnalyze linguistically & spiritually.";
//     final buffer = StringBuffer();
//     bool fail = false;
//     try {
//       final req = http.Request(
//           'POST',
//           Uri.parse(
//               'https://generativelanguage.googleapis.com/v1beta/models/$_model:streamGenerateContent?alt=sse&key=$_apiKey'));
//       req.headers['Content-Type'] = 'application/json';
//       req.body = jsonEncode({
//         'contents': [
//           {
//             'parts': [
//               {'text': prompt}
//             ]
//           }
//         ]
//       });
//       final res = await _client.send(req);
//       if (res.statusCode != 200)
//         throw Exception("Stream API Status: ${res.statusCode}");
//
//       AppLogger.d("Gemini: Successfully started streaming.");
//       await for (final line in res.stream
//           .transform(utf8.decoder)
//           .transform(const LineSplitter())) {
//         if (line.startsWith('data: ')) {
//           try {
//             final content =
//                 jsonDecode(line.substring(6))['candidates'][0]['content'];
//             final t = content?['parts']?[0]?['text'];
//             if (t != null) {
//               yield t;
//               buffer.write(t);
//             }
//           } catch (e) {
//             AppLogger.w("Gemini: Failed to parse stream chunk.", e);
//           }
//         }
//       }
//     } catch (e, stack) {
//       AppLogger.e(
//           "Gemini Stream Error. Falling back to standard API.", e, stack);
//       fail = true;
//     }
//
//     if (fail || buffer.isEmpty) {
//       AppLogger.i("Gemini: Invoking standard (non-streaming) API fallback.");
//       try {
//         yield "\n*(Standard Mode Fallback)*\n";
//         final res = await _client.post(
//             Uri.parse(
//                 'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               'contents': [
//                 {
//                   'parts': [
//                     {'text': prompt}
//                   ]
//                 }
//               ]
//             }));
//         final t = jsonDecode(res.body)['candidates'][0]['content']['parts'][0]
//             ['text'];
//         yield t;
//         buffer.write(t);
//         AppLogger.i("Gemini: Standard API call succeeded.");
//       } catch (e) {
//         AppLogger.e("Gemini Fallback Error: Service Unavailable.", e);
//         yield "Service Unavailable";
//         return;
//       }
//     }
//
//     if (buffer.isNotEmpty) {
//       AppLogger.i("Gemini: Caching final response (${buffer.length} chars).");
//       await _db.cacheAiResponse(
//           surahNumber, ayah.numberInSurah, userQuestion, buffer.toString());
//     }
//   }
// }
//
// final geminiServiceProvider = Provider<GeminiService>((ref) {
//   AppLogger.d("Riverpod: Providing GeminiService instance.");
//   return GeminiService(http.Client(), ref.watch(databaseProvider));
// });
// final aiHistoryForAyahProvider = FutureProvider.autoDispose
//     .family<List<AiCacheEntry>, ({int surahNum, int ayahNum})>((ref, ids) {
//   AppLogger.d(
//       "Riverpod: AI history provider triggered for S${ids.surahNum}:A${ids.ayahNum}.");
//   return ref
//       .watch(databaseProvider)
//       .getCachedResponsesForAyah(ids.surahNum, ids.ayahNum);
// });
//
// // ──────────────────────────────────────────────────
// //  VIEW MODELS
// // ──────────────────────────────────────────────────
// class AppConfig {
//   final double arabicFontSize;
//   final double translationFontSize;
//   final bool isDarkTheme;
//   final List<String> activeTranslationIdentifiers;
//   final String? selectedReciterIdentifier;
//   final String? selectedWordByWordEdition;
//   final bool showArabicText;
//   final bool isTajweedEnabled;
//   AppConfig(
//       {required this.arabicFontSize,
//       required this.translationFontSize,
//       required this.isDarkTheme,
//       required this.activeTranslationIdentifiers,
//       this.selectedReciterIdentifier,
//       this.selectedWordByWordEdition,
//       required this.showArabicText,
//       required this.isTajweedEnabled});
//   AppConfig copyWith(
//       {double? arabicFontSize,
//       double? translationFontSize,
//       bool? isDarkTheme,
//       List<String>? activeTranslationIdentifiers,
//       String? selectedReciterIdentifier,
//       bool clearReciter = false,
//       String? selectedWordByWordEdition,
//       bool clearWordByWord = false,
//       bool? showArabicText,
//       bool? isTajweedEnabled}) {
//     return AppConfig(
//         arabicFontSize: arabicFontSize ?? this.arabicFontSize,
//         translationFontSize: translationFontSize ?? this.translationFontSize,
//         isDarkTheme: isDarkTheme ?? this.isDarkTheme,
//         activeTranslationIdentifiers:
//             activeTranslationIdentifiers ?? this.activeTranslationIdentifiers,
//         selectedReciterIdentifier: clearReciter
//             ? null
//             : selectedReciterIdentifier ?? this.selectedReciterIdentifier,
//         selectedWordByWordEdition: clearWordByWord
//             ? null
//             : selectedWordByWordEdition ?? this.selectedWordByWordEdition,
//         showArabicText: showArabicText ?? this.showArabicText,
//         isTajweedEnabled: isTajweedEnabled ?? this.isTajweedEnabled);
//   }
// }
//
// class AppConfigViewModel extends Notifier<AppConfig> {
//   late SharedPreferences _prefs;
//   @override
//   AppConfig build() {
//     _prefs = ref.read(sharedPreferencesProvider);
//     AppLogger.i("ViewModel: Initializing AppConfig from SharedPreferences.");
//     return AppConfig(
//         arabicFontSize: _prefs.getDouble('fs_ar') ?? 28.0,
//         translationFontSize: _prefs.getDouble('fs_tr') ?? 16.0,
//         isDarkTheme: _prefs.getBool('dark') ?? false,
//         activeTranslationIdentifiers:
//             _prefs.getStringList('active_trans') ?? ['131'],
//         selectedReciterIdentifier: _prefs.getString('reciter'),
//         selectedWordByWordEdition: _prefs.getString('wbw'),
//         showArabicText: _prefs.getBool('show_ar') ?? true,
//         isTajweedEnabled: _prefs.getBool('tajweed') ?? true);
//   }
//
//   void setArabicFontSize(double s) {
//     AppLogger.i("ViewModel: Setting Arabic font size to $s.");
//     _prefs.setDouble('fs_ar', s);
//     state = state.copyWith(arabicFontSize: s);
//   }
//
//   void toggleTheme(bool d) {
//     AppLogger.i("ViewModel: Toggling theme to dark=$d.");
//     _prefs.setBool('dark', d);
//     state = state.copyWith(isDarkTheme: d);
//   }
//
//   void toggleTajweed(bool t) {
//     AppLogger.i("ViewModel: Toggling Tajweed to $t.");
//     _prefs.setBool('tajweed', t);
//     state = state.copyWith(isTajweedEnabled: t);
//   }
//
//   void addActiveTranslation(String i) {
//     AppLogger.i("ViewModel: Adding active translation: $i.");
//     // Use Set for unique identifiers, then convert back to List for state
//     final l = {...state.activeTranslationIdentifiers, i}.toList();
//     _prefs.setStringList('active_trans', l);
//     state = state.copyWith(activeTranslationIdentifiers: l);
//   }
//
//   void removeActiveTranslation(String i) {
//     AppLogger.i("ViewModel: Removing active translation: $i.");
//     final l = state.activeTranslationIdentifiers.where((x) => x != i).toList();
//     _prefs.setStringList('active_trans', l);
//     state = state.copyWith(activeTranslationIdentifiers: l);
//   }
//
//   void setSelectedReciter(String? i) {
//     AppLogger.i("ViewModel: Setting selected reciter: $i.");
//     if (i == null) {
//       _prefs.remove('reciter');
//       state = state.copyWith(clearReciter: true);
//     } else {
//       _prefs.setString('reciter', i);
//       state = state.copyWith(selectedReciterIdentifier: i);
//     }
//   }
//
//   void setSelectedWordByWordEdition(String? i) {
//     AppLogger.i("ViewModel: Setting selected WbW edition: $i.");
//     if (i == null) {
//       _prefs.remove('wbw');
//       state = state.copyWith(clearWordByWord: true);
//     } else {
//       _prefs.setString('wbw', i);
//       state = state.copyWith(selectedWordByWordEdition: i);
//     }
//   }
// }
//
// final appConfigViewModelProvider =
//     NotifierProvider<AppConfigViewModel, AppConfig>(AppConfigViewModel.new);
//
// class WbWOption {
//   final String id;
//   final String title;
//   final String langCode;
//   WbWOption(this.id, this.title, this.langCode);
// }
//
// final wbwOptionsList = [
//   WbWOption('en_wbw', 'English', 'en'),
//   WbWOption('ur_wbw', 'Urdu', 'ur'),
//   WbWOption('id_wbw', 'Indonesian', 'id'),
//   WbWOption('bn_wbw', 'Bengali', 'bn')
// ];
//
// class SetupOptions {
//   final Set<String> fullEditions;
//   final Set<String> wbwEditions;
//   SetupOptions({
//     required this.fullEditions,
//     required this.wbwEditions,
//   });
//
//   SetupOptions copyWith({
//     Set<String>? fullEditions,
//     Set<String>? wbwEditions,
//   }) {
//     return SetupOptions(
//       fullEditions: fullEditions ?? this.fullEditions,
//       wbwEditions: wbwEditions ?? this.wbwEditions,
//     );
//   }
// }
//
// class SetupOptionsNotifier extends Notifier<SetupOptions> {
//   @override
//   SetupOptions build() {
//     AppLogger.d("ViewModel: Initializing SetupOptions.");
//     // Default selected editions should include 'transliteration' (ID '131') if it's considered a must-have base data.
//     // Given 'transliteration' is part of _downloadBaseData, it's safer to let the base data handle it,
//     // and keep the user-selectable list clean.
//     return SetupOptions(
//       fullEditions: {},
//       wbwEditions: {},
//     );
//   }
//
//   void toggleFullEdition(String i) {
//     final s = {...state.fullEditions};
//     if (s.contains(i)) {
//       s.remove(i);
//       AppLogger.i("ViewModel: Removed setup edition: $i");
//     } else {
//       s.add(i);
//       AppLogger.i("ViewModel: Added setup edition: $i");
//     }
//     state = state.copyWith(fullEditions: s);
//   }
//
//   void toggleWbWEdition(String i) {
//     final s = {...state.wbwEditions};
//     if (s.contains(i)) {
//       s.remove(i);
//       AppLogger.i("ViewModel: Removed setup WbW edition: $i");
//     } else {
//       s.add(i);
//       AppLogger.i("ViewModel: Added setup WbW edition: $i");
//     }
//     state = state.copyWith(wbwEditions: s);
//   }
// }
//
// final setupOptionsProvider =
//     NotifierProvider<SetupOptionsNotifier, SetupOptions>(
//         SetupOptionsNotifier.new);
//
// class DataDownloadState {
//   final bool isLoading;
//   final String progressMessage;
//   final String? errorMessage;
//   DataDownloadState(
//       {this.isLoading = false, this.progressMessage = '', this.errorMessage});
// }
//
// class DataDownloadViewModel extends Notifier<DataDownloadState> {
//   @override
//   DataDownloadState build() => DataDownloadState();
//   Future<bool> startDownload() async {
//     AppLogger.i("ViewModel: Starting initial download sequence.");
//     state =
//         DataDownloadState(isLoading: true, progressMessage: 'Initializing...');
//     try {
//       final options = ref.read(setupOptionsProvider);
//       AppLogger.d(
//           "ViewModel: Download requested editions: Full=${options.fullEditions.length}, WbW=${options.wbwEditions.length}");
//
//       await ref.read(quranRepositoryProvider).downloadInitialData(options, (m) {
//         AppLogger.d("Download Progress Update: $m");
//         state = DataDownloadState(isLoading: true, progressMessage: m);
//       });
//
//       final ops = ref.read(setupOptionsProvider);
//       final cfg = ref.read(appConfigViewModelProvider.notifier);
//       // Automatically add newly downloaded editions to active translations list
//       for (var id in ops.fullEditions) {
//         cfg.addActiveTranslation(id);
//       }
//       // Set the first downloaded WbW edition as selected
//       if (ops.wbwEditions.isNotEmpty)
//         cfg.setSelectedWordByWordEdition(ops.wbwEditions.first);
//
//       AppLogger.i("ViewModel: Download and setup flow finished successfully.");
//       state = DataDownloadState(isLoading: false, progressMessage: 'Done');
//       return true;
//     } catch (e, s) {
//       AppLogger.e("ViewModel: Download Flow Failed catastrophically.", e, s);
//       state = DataDownloadState(errorMessage: e.toString());
//       return false;
//     }
//   }
// }
//
// final dataDownloadViewModelProvider =
//     NotifierProvider<DataDownloadViewModel, DataDownloadState>(
//         DataDownloadViewModel.new);
//
// final isAnythingDownloadedProvider = FutureProvider<bool>((ref) async {
//   AppLogger.d("Riverpod: Checking 'isAnythingDownloadedProvider'.");
//   // Check if base data is downloaded (Surah structure, Ayahs, Transliteration)
//   // This uses the dual-check (prefs + DB count) in the repository.
//   final isBaseData =
//       await ref.watch(quranRepositoryProvider).isBaseDataDownloaded();
//
//   // Also check if any other content has been downloaded
//   if (!isBaseData) return false;
//
//   final hasTranslations = await ref
//       .watch(databaseProvider)
//       .select(ref.watch(databaseProvider).translations)
//       .get()
//       .then((value) => value.length > 0);
//   final hasWbW = await ref
//       .watch(databaseProvider)
//       .select(ref.watch(databaseProvider).wordTranslations)
//       .get()
//       .then((value) => value.length > 0);
//
//   return isBaseData || hasTranslations || hasWbW;
// });
// final surahListProvider = FutureProvider<List<Surah>>((ref) {
//   AppLogger.d("Riverpod: Fetching 'surahListProvider'.");
//   return ref.watch(quranRepositoryProvider).getAllSurahs();
// });
//
// // UPDATED: Fetches selectedReciterIdentifier from config and passes it to repository
// final ayahReaderProvider =
//     FutureProvider.family<List<AyahWithTranslations>, int>(
//         (ref, surahNum) async {
//   AppLogger.d("Riverpod: Fetching 'ayahReaderProvider' for S$surahNum.");
//   final config = ref.watch(appConfigViewModelProvider);
//   final repo = ref.watch(quranRepositoryProvider);
//   final database = ref.watch(databaseProvider); // Added dependency
//
//   // Force a dependency on allEditionsProvider so this provider updates when a new edition is downloaded
//   ref.watch(allEditionsProvider);
//
//   final selectedReciter = config.selectedReciterIdentifier;
//
//   final ayahs = await repo.getAyahsForSurah(
//       surahNum,
//       config.activeTranslationIdentifiers,
//       config.selectedWordByWordEdition,
//       selectedReciter); // <-- Pass reciter ID
//
//   AppLogger.d(
//       "Provider: Initial Ayah list created, checking for downloaded audio.");
//
//   if (selectedReciter != null) {
//     final paths =
//         await database.getDownloadedAudioPaths(surahNum, selectedReciter);
//
//     if (paths.isNotEmpty) {
//       AppLogger.d("Provider: Mapping downloaded audio paths to Ayah models.");
//       // Map downloaded audio paths to overwrite the remote URL
//       return ayahs
//           .map((a) => AyahWithTranslations(
//               numberInSurah: a.numberInSurah,
//               arabicText: a.arabicText,
//               tajweedText: a.tajweedText,
//               translations: a.translations,
//               tafsirs: a.tafsirs,
//               // Prioritize local audio path if found
//               audioUrl: paths[a.numberInSurah] != null
//                   ? 'file://${paths[a.numberInSurah]}'
//                   : a.audioUrl,
//               words: a.words,
//               transliteration: a.transliteration))
//           .toList();
//     }
//   }
//   AppLogger.d("Provider: Returning Ayah list with remote/no audio paths.");
//   return ayahs;
// });
// final allEditionsProvider = FutureProvider<List<Edition>>((ref) {
//   AppLogger.d("Riverpod: Fetching 'allEditionsProvider'.");
//   return ref.watch(quranRepositoryProvider).getAllTranslationEditions();
// });
// final allRecitersProvider = FutureProvider<List<Reciter>>((ref) {
//   AppLogger.d("Riverpod: Fetching 'allRecitersProvider'.");
//   return ref.watch(quranRepositoryProvider).getAllReciters();
// });
//
// // Final translationManagerProvider removed as it was unused.
//
// class LastViewedState {
//   final int? surah;
//   final int? ayah;
//   LastViewedState({this.surah, this.ayah});
// }
//
// class LastViewedNotifier extends Notifier<LastViewedState> {
//   late SharedPreferences _prefs;
//   @override
//   LastViewedState build() {
//     _prefs = ref.read(sharedPreferencesProvider);
//     AppLogger.d("ViewModel: Initializing LastViewedState.");
//     return LastViewedState(
//         surah: _prefs.getInt('last_s'), ayah: _prefs.getInt('last_a'));
//   }
//
//   void setPosition(int s, int a) {
//     AppLogger.i("ViewModel: Setting last viewed position to S$s:A$a.");
//     _prefs.setInt('last_s', s);
//     _prefs.setInt('last_a', a);
//     state = LastViewedState(surah: s, ayah: a);
//   }
// }
//
// final lastViewedProvider =
//     NotifierProvider<LastViewedNotifier, LastViewedState>(
//         LastViewedNotifier.new);
//
// class CurrentPlayingAyah extends Notifier<String?> {
//   @override
//   String? build() => null;
//   void setAyah(String? id) {
//     AppLogger.i("ViewModel: Setting current playing ayah ID: $id.");
//     state = id;
//   }
// }
//
// final currentPlayingAyahProvider =
//     NotifierProvider<CurrentPlayingAyah, String?>(CurrentPlayingAyah.new);
//
// // ----------------------------------------------------
// // HELPER FOR COMPUTE (Must be top-level)
// // ----------------------------------------------------
// List<dynamic> _parseJsonList(String body) {
//   return jsonDecode(body) as List<dynamic>;
// }
