import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:alkitab_core/alkitab_core.dart';
import '../models/quran_models.dart';

part 'app_database.g.dart';

// -----------------------------------------------------------------------------
// CONSTANTS
// -----------------------------------------------------------------------------

const int _kTotalSurahs = 114;
const int _kTotalAyahsMin = 6236; // Minimum count to consider downloaded
const String _kTypeTranslation = 'translation';
const String _kTypeTafsir = 'tafsir';
const String _kTypeTransliteration = 'transliteration';
const String _kAudioCdnBase = 'https://cdn.islamic.network/quran/audio/';

// -----------------------------------------------------------------------------
// TABLES
// -----------------------------------------------------------------------------

@DataClassName('SurahsData')
class Surahs extends Table {
  IntColumn get number => integer()();
  TextColumn get name => text()();
  TextColumn get englishName => text()();
  TextColumn get englishNameTranslation => text()();
  TextColumn get revelationType => text()();
  IntColumn get numberOfAyahs => integer()();
}

class Ayahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get numberInSurah => integer()();
  TextColumn get textContent => text()();
  TextColumn get tajweedText => text().nullable()();
  IntColumn get juz => integer()();
  IntColumn get manzil => integer()();
  IntColumn get page => integer()();
  IntColumn get ruku => integer()();
  IntColumn get hizbQuarter => integer()();
}

@DataClassName('Translation')
class Translations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get numberInSurah => integer()();
  TextColumn get edition => text()();
  TextColumn get textContent => text()();
}

@DataClassName('WordTranslation')
class WordTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get numberInSurah => integer()();
  IntColumn get wordNumber => integer()();
  TextColumn get edition => text()();
  TextColumn get arabicText => text()();
  TextColumn get translation => text()();
  TextColumn get transliteration => text()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get localAudioPath => text().nullable()();
}

@DataClassName('DownloadedAudio')
class DownloadedAudios extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get numberInSurah => integer()();
  TextColumn get reciterIdentifier => text()();
  TextColumn get localPath => text()();
  @override
  List<String> get customConstraints =>
      ['UNIQUE(surah_number, number_in_surah, reciter_identifier)'];
}

@DataClassName('AiCacheEntry')
class AiCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get numberInSura => integer()();
  TextColumn get question => text()();
  TextColumn get response => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  @override
  List<String> get customConstraints =>
      ['UNIQUE(surah_number, number_in_sura, question)'];
}

@DataClassName('CachedEdition')
class CachedEditions extends Table {
  TextColumn get identifier => text()();
  TextColumn get language => text()();
  TextColumn get name => text()();
  TextColumn get englishName => text()();
  TextColumn get type => text()();
  @override
  Set<Column> get primaryKey => {identifier};
}

@DataClassName('CachedReciter')
class CachedReciters extends Table {
  TextColumn get identifier => text()();
  TextColumn get language => text()();
  TextColumn get name => text()();
  TextColumn get englishName => text()();
  @override
  Set<Column> get primaryKey => {identifier};
}

@DataClassName('LogEntry')
class Logs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get level => text()(); // INFO, WARN, ERROR
  TextColumn get message => text()();
  TextColumn get stackTrace => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

// -----------------------------------------------------------------------------
// DATABASE CLASS
// -----------------------------------------------------------------------------

@DriftDatabase(tables: [
  Surahs,
  Ayahs,
  Translations,
  WordTranslations,
  DownloadedAudios,
  AiCache,
  CachedEditions,
  CachedReciters,
  Logs
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          AppLogger.i("DB: Creating all tables on first launch.");
          await m.createAll();
          // Create Indexes manually since they aren't in the Table definitions
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          AppLogger.i("DB: Migrating from schema $from to $to.");
          if (from < 2) await m.createTable(aiCache);
          if (from < 3) {
            await m.createTable(cachedEditions);
            await m.createTable(cachedReciters);
          }
          if (from < 4) {
            await m.addColumn(wordTranslations, wordTranslations.audioUrl);
            await m.addColumn(
                wordTranslations, wordTranslations.localAudioPath);
          }
          if (from < 5) {
            await m.addColumn(ayahs, ayahs.tajweedText);
          }
          if (from < 6) {
            await _createIndexes();
          }
          if (from < 7) {
            await m.createTable(logs);
          }
        },
      );

  Future<void> _createIndexes() async {
    AppLogger.i("DB: Creating Optimizations Indexes...");
    // 1. Ayahs: Filter by Surah (Used heavily in listing)
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_ayahs_surah ON ayahs(surah_number);');
    // 2. Translations: Filter by Surah + Edition
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_trans_surah_edition ON translations(surah_number, edition);');
    // 3. WbW: Filter by Surah + Edition (Largest table, critical for performance)
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_wbw_surah_edition ON word_translations(surah_number, edition);');
  }

  // --- BATCH INSERTS ---
  Future<void> addSurahs(List<SurahsCompanion> l) async {
    return batch(
        (b) => b.insertAll(surahs, l, mode: InsertMode.insertOrReplace));
  }

  Future<void> addAyahs(List<AyahsCompanion> l) async {
    return batch(
        (b) => b.insertAll(ayahs, l, mode: InsertMode.insertOrReplace));
  }

  Future<void> addTranslations(List<TranslationsCompanion> l) async {
    return batch(
        (b) => b.insertAll(translations, l, mode: InsertMode.insertOrReplace));
  }

  Future<void> addWordTranslations(List<WordTranslationsCompanion> l) async {
    return batch((b) =>
        b.insertAll(wordTranslations, l, mode: InsertMode.insertOrReplace));
  }

  Future<void> addDownloadedAudio(List<DownloadedAudiosCompanion> l) async {
    return batch((b) =>
        b.insertAll(downloadedAudios, l, mode: InsertMode.insertOrReplace));
  }

  Future<void> addCachedEditions(List<CachedEditionsCompanion> l) async {
    return batch((b) =>
        b.insertAll(cachedEditions, l, mode: InsertMode.insertOrReplace));
  }

  Future<void> addCachedReciters(List<CachedRecitersCompanion> l) async {
    return batch((b) =>
        b.insertAll(cachedReciters, l, mode: InsertMode.insertOrReplace));
  }

  // --- SIMPLE GETTERS ---
  Future<List<SurahsData>> getAllSurahs() => select(surahs).get();

  Future<SurahsData?> getSurahByNumber(int n) =>
      (select(surahs)..where((s) => s.number.equals(n))).getSingleOrNull();

  Future<List<CachedEdition>> getAllCachedEditions() =>
      select(cachedEditions).get();

  Future<List<CachedReciter>> getAllCachedReciters() =>
      select(cachedReciters).get();

  // --- CHECKS ---
  Future<bool> isBaseDataDownloaded() async {
    final s = await select(surahs).get().then((v) => v.length);
    final a = await select(ayahs).get().then((v) => v.length);
    return s == _kTotalSurahs && a >= _kTotalAyahsMin;
  }

  Future<bool> isEditionDownloaded(String id) async {
    // 6000 is an approximation of total verses (min threshold)
    final c = await (select(translations)..where((t) => t.edition.equals(id)))
        .get()
        .then((v) => v.length);
    return c > 6000;
  }

  Future<bool> isWbWEditionDownloaded(String id) async {
    // 77000 is an approximation of total words (min threshold)
    final c = await (select(wordTranslations)
          ..where((t) => t.edition.equals(id)))
        .get()
        .then((v) => v.length);
    return c >= 77000;
  }

  Future<Map<int, String>> getDownloadedAudioPaths(int s, String r) async {
    final f = await (select(downloadedAudios)
          ..where(
              (a) => a.surahNumber.equals(s) & a.reciterIdentifier.equals(r)))
        .get();
    return {for (var file in f) file.numberInSurah: file.localPath};
  }

  // --- AI CACHE ---
  Future<String?> getCachedAiResponse(int s, int a, String q) async {
    final e = await (select(aiCache)
          ..where((t) =>
              t.surahNumber.equals(s) &
              t.numberInSura.equals(a) &
              t.question.equals(q)))
        .getSingleOrNull();
    return e?.response;
  }

  Future<List<AiCacheEntry>> getCachedResponsesForAyah(int s, int a) async {
    return await (select(aiCache)
          ..where((t) => t.surahNumber.equals(s) & t.numberInSura.equals(a))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<void> cacheAiResponse(int s, int a, String q, String r) async {
    await into(aiCache).insert(
        AiCacheCompanion(
            surahNumber: Value(s),
            numberInSura: Value(a),
            question: Value(q),
            response: Value(r)),
        mode: InsertMode.insertOrReplace);
  }

  // --- LOGGING ---
  Future<void> insertLog(
      String level, String message, String? stackTrace) async {
    // SAFEGUARD: Prevent recursive logging during initialization
    // If the table doesn't exist yet (e.g. during onCreate), this will throw.
    // We catch it silently or forward to console to avoid crashing startup.
    try {
      await into(logs).insert(LogsCompanion(
        level: Value(level),
        message: Value(message),
        stackTrace: Value(stackTrace),
      ));
    } catch (e) {
      // Fallback to console if DB isn't ready
      // print('DB Log Failed (Init State): $message'); 
    }
  }

  Future<List<LogEntry>> getRecentLogs({int limit = 100}) {
    return (select(logs)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  // ---------------------------------------------------------------------------
  // [OPTIMIZED] PARALLEL PAGINATED FETCH
  // ---------------------------------------------------------------------------
  Future<List<AyahWithTranslations>> getAyahsForSurah(
      int surahNumber,
      List<String> editionIdentifiers,
      String? wordByWordEdition,
      String? reciterIdentifier,
      {int limit = 20,
      int offset = 0}) async {
    AppLogger.d(
        "DB: Fetching S$surahNumber (Limit: $limit, Offset: $offset) - Parallel");

    // Calculate range to optimize joins
    final startAyah = offset + 1;
    final endAyah = offset + limit;

    // 1. Prepare Futures (Do not await yet for concurrency)

    // Arabic: Fetch only the requested page
    final futureArabic = (select(ayahs)
          ..where((a) => a.surahNumber.equals(surahNumber))
          ..orderBy([(a) => OrderingTerm.asc(a.numberInSurah)])
          ..limit(limit, offset: offset))
        .get();

    // Translations: Filter by range to avoid fetching whole surah
    final futureRawData = (select(translations)
          ..where((t) =>
              t.surahNumber.equals(surahNumber) &
              t.edition.isIn(editionIdentifiers) &
              t.numberInSurah.isBetweenValues(startAyah, endAyah)))
        .get();

    // Edition Metadata
    final futureEditions = select(cachedEditions).get();

    // Transliteration (Specific case)
    final futureTranslit = (select(translations)
          ..where((t) =>
              t.surahNumber.equals(surahNumber) &
              t.edition.equals(_kTypeTransliteration) &
              t.numberInSurah.isBetweenValues(startAyah, endAyah)))
        .get();

    // Word by Word (Optional)
    Future<List<WordTranslation>> futureWords;
    if (wordByWordEdition != null) {
      futureWords = (select(wordTranslations)
            ..where((w) =>
                w.surahNumber.equals(surahNumber) &
                w.edition.equals(wordByWordEdition) &
                w.numberInSurah.isBetweenValues(startAyah, endAyah))
            ..orderBy([
              (w) => OrderingTerm.asc(w.numberInSurah),
              (w) => OrderingTerm.asc(w.wordNumber)
            ]))
          .get();
    } else {
      futureWords = Future.value([]);
    }

    // 2. Execute concurrently
    final results = await Future.wait([
      futureArabic, // 0
      futureRawData, // 1
      futureEditions, // 2
      futureTranslit, // 3
      futureWords, // 4
    ]);

    // 3. Unpack Results
    final arabic = results[0] as List<Ayah>;
    final rawData = results[1] as List<Translation>;
    final editions = results[2] as List<CachedEdition>;
    final translitData = results[3] as List<Translation>;
    final wordData = results[4] as List<WordTranslation>;

    // 4. Process Maps (In-Memory Processing)
    final editionTypeMap = {for (var e in editions) e.identifier: e.type};

    final translitMap = {
      for (var t in translitData) t.numberInSurah: t.textContent
    };

    final groupedTranslations = <String, Map<int, String>>{};
    final groupedTafsirs = <String, Map<int, String>>{};

    for (final t in rawData) {
      final type = editionTypeMap[t.edition] ?? _kTypeTranslation;
      if (type == _kTypeTafsir) {
        groupedTafsirs.putIfAbsent(t.edition, () => {});
        groupedTafsirs[t.edition]![t.numberInSurah] = t.textContent;
      } else {
        groupedTranslations.putIfAbsent(t.edition, () => {});
        groupedTranslations[t.edition]![t.numberInSurah] = t.textContent;
      }
    }

    final groupedWords = <int, List<AyahWord>>{};
    for (final w in wordData) {
      groupedWords.putIfAbsent(w.numberInSurah, () => []);
      groupedWords[w.numberInSurah]!.add(w.toDomain());
    }

    // 6. Fetch Downloaded Paths (Optimize: Single query map)
    Map<int, String> localAudioMap = {};
    if (reciterIdentifier != null) {
      final localRows = await (select(downloadedAudios)
            ..where((a) =>
                a.surahNumber.equals(surahNumber) &
                a.reciterIdentifier.equals(reciterIdentifier) &
                a.numberInSurah.isBetweenValues(startAyah, endAyah)))
          .get();
      localAudioMap = {for (var r in localRows) r.numberInSurah: r.localPath};

      // VERIFY EXISTENCE (Self-Healing)
      // If the file was deleted or not found, remove it so we fallback to CDN
      localAudioMap.removeWhere((_, path) => !File(path).existsSync());
    }

    // 5. Construct Result Objects
    return arabic.map((a) {
      final ayahTranslations = <String, String>{};
      final ayahTafsirs = <String, String>{};

      for (final eid in editionIdentifiers) {
        final txt = groupedTranslations[eid]?[a.numberInSurah];
        if (txt != null) ayahTranslations[eid] = txt;
        final taf = groupedTafsirs[eid]?[a.numberInSurah];
        if (taf != null) ayahTafsirs[eid] = taf;
      }

      String? calculatedAudioUrl;
      if (reciterIdentifier != null) {
        // PREFER LOCAL FILE
        if (localAudioMap.containsKey(a.numberInSurah)) {
          calculatedAudioUrl = localAudioMap[a.numberInSurah];
        } else {
          calculatedAudioUrl = '$_kAudioCdnBase$reciterIdentifier/${a.id}.mp3';
        }
      }

      return AyahWithTranslations(
        numberInSurah: a.numberInSurah,
        arabicText: a.textContent,
        tajweedText: a.tajweedText,
        translations: ayahTranslations,
        tafsirs: ayahTafsirs,
        words: groupedWords[a.numberInSurah] ?? [],
        transliteration: translitMap[a.numberInSurah],
        audioUrl: calculatedAudioUrl,
      );
    }).toList();
  }
  // ---------------------------------------------------------------------------
  // SEARCH LOGIC
  // ---------------------------------------------------------------------------

  Future<List<QuranSearchResult>> searchContent(String query,
      {int limit = 50}) async {
    // 1. Detect if the query is Arabic
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(query);
    final searchPattern = '%$query%';

    if (isArabic) {
      // --- SEARCH ARABIC TEXT (Ayahs Table) ---
      final rows = await customSelect(
        '''
        SELECT 
          a.surah_number, 
          a.number_in_surah, 
          a.text_content, 
          s.english_name
        FROM ayahs a
        JOIN surahs s ON s.number = a.surah_number
        WHERE a.text_content LIKE ? OR a.text_content LIKE ? 
        LIMIT ?
        ''',
        variables: [
          Variable(searchPattern),
          // Also search without diacritics if you had a normalized column,
          // but for now we duplicate the variable or just use one.
          Variable(searchPattern),
          Variable(limit)
        ],
        readsFrom: {ayahs, surahs},
      ).get();

      return rows.map((row) {
        return QuranSearchResult(
          surahNumber: row.read<int>('surah_number'),
          ayahNumber: row.read<int>('number_in_surah'),
          text: row.read<String>('text_content'),
          surahEnglishName: row.read<String>('english_name'),
        );
      }).toList();
    } else {
      // --- SEARCH TRANSLATIONS (Translations Table) ---
      // We join with Surahs to get the name immediately
      final rows = await customSelect(
        '''
        SELECT 
          t.surah_number, 
          t.number_in_surah, 
          t.text_content, 
          t.edition,
          s.english_name
        FROM translations t
        JOIN surahs s ON s.number = t.surah_number
        WHERE t.text_content LIKE ? 
        LIMIT ?
        ''',
        variables: [Variable(searchPattern), Variable(limit)],
        readsFrom: {translations, surahs},
      ).get();

      return rows.map((row) {
        return QuranSearchResult(
          surahNumber: row.read<int>('surah_number'),
          ayahNumber: row.read<int>('number_in_surah'),
          text: row.read<String>('text_content'),
          surahEnglishName: row.read<String>('english_name'),
          translationId: row.read<String>('edition'),
        );
      }).toList();
    }
  }
}

// -----------------------------------------------------------------------------
// CONNECTION
// -----------------------------------------------------------------------------

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dir.path, 'quran.sqlite');
      AppLogger.i("DB: Initializing NativeDatabase at path: $dbPath");
      return NativeDatabase(File(dbPath), logStatements: false);
    });

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
