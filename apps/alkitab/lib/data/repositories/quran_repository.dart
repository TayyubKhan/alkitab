import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alkitab_core/alkitab_core.dart';
import '../../viewmodels/audio_viewmodel.dart' as core;

import '../local/app_database.dart';
import '../models/quran_models.dart';

// -----------------------------------------------------------------------------
// ISOLATE PARSERS (Must be Top-Level)
// -----------------------------------------------------------------------------

Map<String, dynamic> _parseGeneralJson(String body) {
  return jsonDecode(body) as Map<String, dynamic>;
}

List<TranslationsCompanion> _parseContentBatch(Map<String, dynamic> args) {
  final body = args['body'] as String;
  final editionId = args['editionId'] as String;

  // V3 uses 'verses' array
  final jsonMap = jsonDecode(body) as Map<String, dynamic>;
  final list = jsonMap['verses'] as List<dynamic>;
  final batch = <TranslationsCompanion>[];

  for (final item in list) {
    // V3 Item: { "verse_key": "1:1", "translations": [ { "text": "..." } ] }
    final verseKey = item['verse_key'] as String;
    final parts = verseKey.split(':');
    final surahNum = int.parse(parts[0]);
    final ayahNum = int.parse(parts[1]);

    String text = '';
    var transList = item['translations'] as List<dynamic>?;
    if (transList == null || transList.isEmpty) {
      transList = item['tafsirs'] as List<dynamic>?;
    }

    if (transList != null && transList.isNotEmpty) {
      text = transList[0]['text'] ?? '';
    }

    // Optimization: Regex is compiled once here
    text = text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    text = text
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&');

    if (text.isNotEmpty) {
      batch.add(TranslationsCompanion(
        surahNumber: drift.Value(surahNum),
        numberInSurah: drift.Value(ayahNum),
        edition: drift.Value(editionId),
        textContent: drift.Value(text),
      ));
    }
  }
  return batch;
}

List<TranslationsCompanion> _parseV4Tafsir(Map<String, dynamic> args) {
  final body = args['body'] as String;
  final editionId = args['editionId'] as String;

  final jsonMap = jsonDecode(body) as Map<String, dynamic>;
  final list = jsonMap['tafsirs'] as List<dynamic>;
  final batch = <TranslationsCompanion>[];

  for (final item in list) {
    // V4 Item: { "verse_key": "1:1", "text": "...", "resource_id": 160 }
    final verseKey = item['verse_key'] as String;
    final parts = verseKey.split(':');
    final surahNum = int.parse(parts[0]);
    final ayahNum = int.parse(parts[1]);

    String text = item['text'] ?? '';

    // Clean HTML
    text = text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    text = text
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&');

    if (text.isNotEmpty) {
      batch.add(TranslationsCompanion(
        surahNumber: drift.Value(surahNum),
        numberInSurah: drift.Value(ayahNum),
        edition: drift.Value(editionId),
        textContent: drift.Value(text),
      ));
    }
  }
  return batch;
}

// -----------------------------------------------------------------------------
// REPOSITORY CLASS
// -----------------------------------------------------------------------------

class MobileQuranRepository implements core.QuranRepository {
  final AppDatabase _db;
  final SharedPreferences _prefs;

  // OPTIMIZATION 1: Persistent Client for Keep-Alive
  http.Client? _client;

  static const String _baseUrl = 'https://api.quran.com/api/v4';
  static const String _kBaseDataDownloadedKey = 'is_base_data_v11_complete';

  Map<String, int>? _slugToIdMap;
  final Map<String, String> _wbwMap = {for (var e in wbwOptionsList) e.id: e.langCode};

  MobileQuranRepository(this._db, this._prefs);
  
  // ---------------------------------------------------------------------------
  // CORE INTERFACE IMPLEMENTATION
  // ---------------------------------------------------------------------------
  
  @override
  Future<List<Surah>> getAllSurahs() async {
      final rows = await _db.select(_db.surahs).get();
      return rows.map((r) => Surah(
          number: r.number,
          name: r.name,
          englishName: r.englishName,
          englishNameTranslation: r.englishNameTranslation,
          revelationType: r.revelationType,
          numberOfAyahs: r.numberOfAyahs
      )).toList();
  }

  @override
  Future<bool> isBaseDataDownloaded() async {
    return _prefs.getBool(_kBaseDataDownloadedKey) ?? false;
  }
  
  @override
  Future<List<AyahWithTranslations>> getAyahsForSurah(
      int surahNumber,
      List<String> editionIdentifiers,
      String? wordByWordEdition,
      String? reciterIdentifier,
      {int limit = 20,
      int offset = 0}) async {
      
      // 1. Fetch Ayahs (Drift)
      // We implement pagination using limit/offset
      final q = _db.select(_db.ayahs)
          ..where((t) => t.surahNumber.equals(surahNumber))
          ..limit(limit, offset: offset);
          
      final ayahs = await q.get();
      
      if (ayahs.isEmpty) return [];
      
      // 2. Fetch Translations (Data Loader Pattern)
      // Optimization: Fetch ALL translations for these ayah IDs in one query?
      // Or just fetch all translations for the SURAH (if not too big) and filter?
      // Better: fetch for specific Ayah Ranges.
      // But for simplicity in SQLite, just fetch all for Surah filtered by editions.
      // Actually, fetching all for surah might be 6000 verses if Baqarah? No, max 286.
      // Fetching 286 * 2 translations = ~600 rows. Fast enough.
      
      final transRows = await (_db.select(_db.translations)
          ..where((t) => t.surahNumber.equals(surahNumber) & t.edition.isIn(editionIdentifiers))
      ).get();
      
      // Map translations by AyahNumber
      final transMap = <int, Map<String, String>>{};
      for (var t in transRows) {
          transMap.putIfAbsent(t.numberInSurah, () => {})[t.edition] = t.textContent;
      }
      
      // 3. Fetch WbW
      final wbwMap = <int, List<AyahWord>>{};
      if (wordByWordEdition != null) {
          final wbwRows = await (_db.select(_db.wordTranslations)
              ..where((t) => t.surahNumber.equals(surahNumber) & t.edition.equals(wordByWordEdition))
          ).get();
          
          for (var w in wbwRows) {
              wbwMap.putIfAbsent(w.numberInSurah, () => []).add(AyahWord(
                  wordNumber: w.wordNumber,
                  arabicText: w.arabicText,
                  translation: w.translation,
                  transliteration: w.transliteration,
                  localAudioPath: w.audioUrl // Note: model expects local path or url? 
              ));
          }
      }

      // 4. Map to Domain
      return ayahs.map((a) {
          final t = transMap[a.numberInSurah] ?? {};
          final w = wbwMap[a.numberInSurah] ?? [];
          // Sort words
          w.sort((a,b) => a.wordNumber.compareTo(b.wordNumber));

          return AyahWithTranslations(
              numberInSurah: a.numberInSurah,
              arabicText: a.textContent,
              // Tajweed isn't in Ayah table column 'textContent' is 'text_indopak'.
              // We used 'textContent' for arabic text in downloadFullQuranArabic.
              // tajweedText was null.
              tajweedText: null, 
              translations: t,
              tafsirs: {}, // Separate query if needed, or included in translations table with type?
              // The repo stores tafsirs in 'translations' table? Let's check logic.
              // Yes, _downloadContentByChapter saves both to _db.addTranslations/translations table.
              // So 't' map contains both.
              words: w,
              audioUrl: null, // Audio VM handles playback via files, not URL here.
              transliteration: null, // No transliteration column in Ayah table?
          );
      }).toList();
  }

  @override
  Future<List<QuranSearchResult>> searchAyahs(String query) async {
       // Using 'LIKE' for now. FTS is better but requires FTS table.
       final rows = await (_db.select(_db.translations)
           ..where((t) => t.textContent.like('%$query%'))
           ..limit(50)
       ).get();
       
       return Future.wait(rows.map((r) async {
            final surah = await _db.getSurahByNumber(r.surahNumber);
            return QuranSearchResult(
                surahNumber: r.surahNumber,
                surahEnglishName: surah?.englishName ?? '',
                ayahNumber: r.numberInSurah,
                text: r.textContent,
                translationId: r.edition
            );
       }));
  }
  
  @override
  Future<void> deleteAllLocalData() async {
      await _db.close();
      // Implementation depends on requirements (drop tables or delete files)
      // For now, assume this is handled by just invalidating logic or clearing tables.
      // _db.delete(_db.surahs).go();
      // etc.
  }

  // ---------------------------------------------------------------------------
  // CLIENT MANAGEMENT
  // ---------------------------------------------------------------------------

  http.Client _getClient() {
    _client ??= http.Client();
    return _client!;
  }

  void _resetClient() {
    try {
      _client?.close();
    } catch (_) {}
    _client = http.Client();
  }

  // ---------------------------------------------------------------------------
  // SMART BATCH PROCESSOR
  // ---------------------------------------------------------------------------
  Future<void> _processInBatches<T>(
    List<T> items,
    int batchSize,
    Future<void> Function(T item) processor, {
    Function(double progress)? onProgress,
  }) async {
    final total = items.length;
    int completed = 0;

    for (var i = 0; i < total; i += batchSize) {
      final end = (i + batchSize < total) ? i + batchSize : total;
      final batch = items.sublist(i, end);

      await Future.wait(batch.map((item) async {
        await processor(item);
        completed++;
      }));

      if (onProgress != null) {
        onProgress(completed / total);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // ROBUST NETWORK REQUEST
  // ---------------------------------------------------------------------------

  Future<http.Response> _getWithRetry(String url) async {
    final uri = Uri.parse(url);
    int retryDelay = 1;

    for (int i = 0; i < 3; i++) {
      try {
        // OPTIMIZATION 2: Reuse client and Keep-Alive connection
        // RELAXED TIMEOUT: Increased to 90s for slower connections
        final response = await _getClient().get(uri, headers: {
          'Accept': 'application/json',
          // removed 'Connection': 'close' to allow Keep-Alive
        }).timeout(const Duration(seconds: 90));

        if (response.statusCode == 200) {
          return response;
        }

        AppLogger.w("Net: API Status ${response.statusCode} for $url");
      } catch (e) {
        // OPTIMIZATION 3: Smart Reset on Broken Pipe/Socket
        if (e is SocketException || e is http.ClientException) {
          AppLogger.w("Net: Connection broken, resetting client ($e)");
          _resetClient();
        } else if (i < 2) {
          AppLogger.w("Net: Attempt ${i + 1} failed for $url: $e");
        }
      }

      await Future.delayed(Duration(seconds: retryDelay));
      retryDelay += 1;
    }

    throw Exception('Failed to connect to API after 3 attempts: $url');
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // ---------------------------------------------------------------------------
  // MAIN DOWNLOAD MANAGER
  // ---------------------------------------------------------------------------

  @override
  Future<void> downloadInitialData(
      SetupOptions ops, ValueSetter<String> p) async {
    if (!await _isConnected()) throw Exception('No Internet Connection');

    // Start fresh for major operation
    _resetClient();

    if (!await isBaseDataDownloaded()) {
      await _downloadBaseData(p);
    }

    // PARALLELIZATION: Run independent download tasks concurrently
    p("Downloading content...");

    await Future.wait([
      // 1. Process WbW Editions
      Future.forEach(ops.wbwEditions, (id) async {
        if (!await _db.isWbWEditionDownloaded(id)) {
          await _downloadWordByWordData(_wbwMap[id]!, id, p);
        }
      }),

      // 2. Process Translations
      _resolveTranslationId('init').then((_) async {
        final editionsToDownload = <String>[];
        for (final id in ops.fullEditions) {
          if (!await _db.isEditionDownloaded(id)) {
            editionsToDownload.add(id);
          }
        }
        // Run translation downloads in sequence to avoid flooding too much,
        // but this entire block runs parallel to WbW and Audio.
        for (final id in editionsToDownload) {
          try {
            await downloadAndStoreTranslation(id, p);
          } catch (e) {
            AppLogger.w("Repo: Edition $id download failed: $e");
          }
        }
      }),

      // 3. Process Audio (if any)
      if (ops.offlineReciterId != null)
        _downloadFullQuranAudio(ops.offlineReciterId!, p)
    ]);

    p('Complete');
    // Cleanup client after heavy operation
    _client?.close();
    _client = null;
  }

  // ---------------------------------------------------------------------------
  // AUDIO LOGIC
  // ---------------------------------------------------------------------------

  Future<void> _downloadFullQuranAudio(
      String reciterId, ValueSetter<String> onProgress) async {
    final dir = await getApplicationDocumentsDirectory();
    final reciterDir = Directory(p.join(dir.path, 'audio', reciterId));
    if (!await reciterDir.exists()) {
      await reciterDir.create(recursive: true);
    }

    final surahIds = List<int>.generate(114, (i) => i + 1);

    // Track granular progress
    // Map of Surah Number -> Progress (0.0 to 1.0)
    final progressMap = <int, double>{};
    for (var s in surahIds) {
      progressMap[s] = 0.0;
    }

    void reportCombinedProgress() {
      final totalSum = progressMap.values.fold(0.0, (a, b) => a + b);
      final overallPct = (totalSum / 114) * 100;
      // Report with 1 decimal place for smoothness
      onProgress("Downloading Audio: ${overallPct.toStringAsFixed(1)}%");
    }

    // OPTIMIZATION 4: Parallelize Surah processing
    // We use a batch size of 5 to allow accurate inner progress tracking without flooding
    await _processInBatches<int>(
      surahIds,
      5,
      (surahNum) async {
        // AppLogger.d("Repo: Starting Audio For Surah $surahNum...");
        await downloadSurahAudio(surahNum, reciterId, (surahPct) {
          progressMap[surahNum] = surahPct;
          reportCombinedProgress();
        });
        // Ensure it's marked 1.0 at end
        progressMap[surahNum] = 1.0;
        reportCombinedProgress();
      },
    );
  }

  Future<void> downloadSurahAudio(
      int surahNum, String reciterId, ValueSetter<double> onProgress) async {
    final urlMap = await _fetchAudioUrlsForReciter(surahNum, reciterId);
    if (urlMap.isEmpty) return;

    final dir = await getApplicationDocumentsDirectory();
    final reciterDir = Directory(p.join(dir.path, 'audio', reciterId));
    if (!await reciterDir.exists()) {
      await reciterDir.create(recursive: true);
    }

    final ayahs = await (_db.select(_db.ayahs)
          ..where((a) => a.surahNumber.equals(surahNum)))
        .get();

    final List<({Ayah ayah, String url})> downloadQueue = [];
    final List<DownloadedAudiosCompanion> dbBatch = [];

    // Pre-check files
    for (var a in ayahs) {
      final fileName = '${a.id}.mp3';
      final file = File(p.join(reciterDir.path, fileName));

      if (!file.existsSync() || file.lengthSync() == 0) {
        final verseKey = '${a.surahNumber}:${a.numberInSurah}';
        final url = urlMap[verseKey];
        if (url != null) {
          downloadQueue.add((ayah: a, url: url));
        }
      } else {
        // Queue for DB update if file exists (integrity check)
        dbBatch.add(DownloadedAudiosCompanion(
            surahNumber: drift.Value(surahNum),
            numberInSurah: drift.Value(a.numberInSurah),
            reciterIdentifier: drift.Value(reciterId),
            localPath: drift.Value(file.path)));
      }
    }

    // Insert existing file records in one go
    if (dbBatch.isNotEmpty) {
      await _db.batch((batch) {
        batch.insertAll(_db.downloadedAudios, dbBatch,
            mode: drift.InsertMode.insertOrReplace);
      });
      dbBatch.clear();
    }

    if (downloadQueue.isEmpty) {
      onProgress(1.0);
      return;
    }

    final totalToDownload = downloadQueue.length;
    int downloadedCount = 0;

    // OPTIMIZATION 5: Balanced batch size for files to prevent socket errors
    // REDUCED BATCH: 100 -> 12 (Client limits usually around 10-20)
    await _processInBatches<({Ayah ayah, String url})>(downloadQueue, 12,
        (item) async {
      final fileName = '${item.ayah.id}.mp3';
      final file = File(p.join(reciterDir.path, fileName));

      bool success = false;
      String? lastError;

      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          final res = await _getClient().get(Uri.parse(item.url));
          if (res.statusCode == 200) {
            await file.writeAsBytes(res.bodyBytes);
            // OPTIMIZATION 6: Queue DB insert, don't await it individually
            dbBatch.add(DownloadedAudiosCompanion(
                surahNumber: drift.Value(surahNum),
                numberInSurah: drift.Value(item.ayah.numberInSurah),
                reciterIdentifier: drift.Value(reciterId),
                localPath: drift.Value(file.path)));
            success = true;
            break;
          } else {
            final bodySnippet =
                res.body.length > 200 ? res.body.substring(0, 200) : res.body;
            lastError =
                "Status ${res.statusCode} | URL: ${item.url} | Body: $bodySnippet";
          }
        } catch (e) {
          lastError = "$e | URL: ${item.url}";
          if (e is SocketException) _resetClient();
          await Future.delayed(Duration(milliseconds: 300 * (attempt + 1)));
        }
      }

      if (!success) {
        AppLogger.w(
            "Audio: Failed to download $fileName after 3 attempts. $lastError");
      } else {
        // Verbose log for each file (User request: "each and everything")
        AppLogger.d("Audio: Downloaded $fileName");
      }
      downloadedCount++;
    }, onProgress: (batchProgress) {
      onProgress(downloadedCount / totalToDownload);
    });

    // OPTIMIZATION 7: Flush all new DB records in one transaction
    if (dbBatch.isNotEmpty) {
      await _db.batch((batch) {
        batch.insertAll(_db.downloadedAudios, dbBatch,
            mode: drift.InsertMode.insertOrReplace);
      });
    }
  }

  // ---------------------------------------------------------------------------
  // LIST FETCHING
  // ---------------------------------------------------------------------------

  @override
  Future<List<Edition>> getAllTranslationEditions() async {
    final c = await _db.getAllCachedEditions();
    if (c.isNotEmpty) return c.map((e) => e.toDomain()).toList();

    AppLogger.i("Repo: Fetching Translations list...");

    // Parallel fetch
    final results = await Future.wait([
      _getWithRetry('$_baseUrl/resources/translations?language=en'),
      _getWithRetry('$_baseUrl/resources/tafsirs?language=en'),
    ]);

    final d1 = (json.decode(results[0].body) as Map)['translations'] as List;
    final d2 = (json.decode(results[1].body) as Map)['tafsirs'] as List;

    final all = [
      ...d1.map((e) => Edition.fromJson({...e, 'type': 'translation'})),
      ...d2.map((e) => Edition.fromJson({...e, 'type': 'tafsir'}))
    ];

    await _db.addCachedEditions(all
        .map((e) => CachedEditionsCompanion(
            identifier: drift.Value(e.identifier),
            language: drift.Value(e.language),
            name: drift.Value(e.name),
            englishName: drift.Value(e.englishName),
            type: drift.Value(e.type)))
        .toList());

    return all;
  }

  @override
  Future<List<Reciter>> getAllReciters() async {
    final c = await _db.getAllCachedReciters();
    if (c.isNotEmpty) return c.map((e) => e.toDomain()).toList();

    AppLogger.i("Repo: Fetching Reciters list...");

    final r =
        await _getWithRetry('$_baseUrl/resources/recitations?language=en');
    final d = (json.decode(r.body) as Map)['recitations'] as List;
    // The Reciter.fromJson we added handles the map.
    final l = d.map((j) => Reciter.fromJson(j)).toList();

    await _db.addCachedReciters(l
        .map((x) => CachedRecitersCompanion(
            identifier: drift.Value(x.identifier),
            language: drift.Value(x.language),
            name: drift.Value(x.name),
            englishName: drift.Value(x.englishName)))
        .toList());

    return l;
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  Future<void> _downloadBaseData(ValueSetter<String> onProgress) async {
    onProgress('Downloading structure...');
    final r = await _getWithRetry('$_baseUrl/chapters?language=en');
    final d = (json.decode(r.body) as Map)['chapters'] as List;
    await _db.addSurahs(d
        .map((s) => SurahsCompanion(
            number: drift.Value(s['id']),
            name: drift.Value(s['name_arabic']),
            englishName: drift.Value(s['name_simple']),
            englishNameTranslation: drift.Value(s['translated_name']['name']),
            revelationType: drift.Value(s['revelation_place']),
            numberOfAyahs: drift.Value(s['verses_count'])))
        .toList());

    onProgress('Downloading Arabic Text...');
    await _downloadFullQuranArabic();

    onProgress('Downloading Meta Lists...');
    // Parallel fetch
    await Future.wait([
      getAllTranslationEditions(),
      getAllReciters(),
    ]);

    await _markBaseDataAsDownloaded();
  }

  Future<void> _downloadFullQuranArabic() async {
    // Check if we already have data
    if (await (_db.select(_db.ayahs)).get().then((v) => v.length) >= 6236) {
      return;
    }

    // --- CHANGE: Use 'indopak' endpoint for full stop signs ---
    final r =
        await _getWithRetry('$_baseUrl/quran/verses/indopak?per_page=all');

    final data = await compute(_parseGeneralJson, r.body);
    final verses = data['verses'] as List;
    final batch = <AyahsCompanion>[];

    for (var v in verses) {
      final k = (v['verse_key'] as String).split(':');
      batch.add(AyahsCompanion(
          surahNumber: drift.Value(int.parse(k[0])),
          numberInSurah: drift.Value(int.parse(k[1])),
          // --- CHANGE: Map 'text_indopak' ---
          textContent: drift.Value(v['text_indopak']),
          // IndoPak endpoint doesn't usually provide Tajweed
          tajweedText: const drift.Value(null),
          juz: drift.Value(v['juz_number'] ?? 0),
          manzil: drift.Value(0),
          page: drift.Value(v['page_number'] ?? 0),
          ruku: drift.Value(0),
          hizbQuarter: drift.Value(v['rub_el_hizb_number'] ?? 0)));
    }
    await _db.addAyahs(batch);
  }

  @override
  Future<void> downloadAndStoreTranslation(
      String id, ValueSetter<String> p) async {
    if (await isEditionDownloaded(id)) return;

    if (_wbwMap.containsKey(id)) {
      await _downloadWordByWordData(_wbwMap[id]!, id, p);
      return;
    }

    // Determine type (translation or tafsir)
    String type = 'translations'; // default
    String apiId = await _resolveTranslationId(id);

    // Check if it's a tafsir from cached editions
    final cached = await _db.getAllCachedEditions();
    final edition = cached
        .where((e) => e.identifier == id)
        .firstOrNull; // Use firstOrNull or check length

    if (edition != null && edition.type == 'tafsir') {
      type = 'tafsirs';
      // Tafsir ID might need resolution too, but usually it's passed directly if numeric
      // If we have a slug map for translations, tafsirs usually rely on ID.
      // Assuming apiId is correct or we use the identifier if numeric.
    }

    // Safety: If apiId is "131" (saheeh) but user selected a Tafsir,
    // we need to make sure we use the ID from the edition metadata if possible,
    // or rely on _resolve to return the numeric ID.

    await _downloadContentByChapter(id, apiId, type, p);
  }

  Future<void> _downloadContentByChapter(String customId, String apiId,
      String type, ValueSetter<String> onProgress) async {
    final surahIds = List<int>.generate(114, (i) => i + 1);

    // V3 works better for Translations (verses endpoint),
    // but V4 is required for Tafsirs.

    // REDUCED BATCH: 2 for Tafsirs to be safe
    await _processInBatches<int>(
      surahIds,
      (type == 'tafsirs') ? 2 : 6,
      (surahNum) async {
        if (type == 'tafsirs') {
          // --- V4 TAFSIR LOGIC ---
          // CORRECT ENDPOINT: /tafsirs/{id}/by_chapter/{chapter_number}
          // Note: The base URL usually ends with /api/v4, so we construct carefully.
          // _baseUrl is 'https://api.quran.com/api/v4'

          final url = '$_baseUrl/tafsirs/$apiId/by_chapter/$surahNum';
          AppLogger.d(
              "Repo: Downloading V4 Tafsir $apiId for Surah $surahNum...");

          try {
            final resp = await _getWithRetry(url);
            final List<TranslationsCompanion> batch = await compute(
                _parseV4Tafsir, {'body': resp.body, 'editionId': customId});

            if (batch.isNotEmpty) {
              await _db.addTranslations(batch);
              AppLogger.d(
                  "Repo: Saved ${batch.length} tafsir verses for Surah $surahNum");
            } else {
              AppLogger.w(
                  "Repo: Empty V4 tafsir batch for Surah $surahNum - $url");
            }
          } catch (e) {
            AppLogger.e(
                "Repo: Failed Surah $surahNum for Tafsir $apiId (V4) - $e");
          }
        } else {
          // --- V3 TRANSLATION LOGIC (Existing) ---
          final url =
              'https://api.quran.com/api/v3/chapters/$surahNum/verses?translations=$apiId&language=en&recitation=1&limit=300';

          AppLogger.d(
              "Repo: Downloading V3 Translation $apiId for Surah $surahNum...");

          try {
            final resp = await _getWithRetry(url);
            final List<TranslationsCompanion> batch = await compute(
                _parseContentBatch, {'body': resp.body, 'editionId': customId});

            if (batch.isNotEmpty) {
              await _db.addTranslations(batch);
              AppLogger.d(
                  "Repo: Saved ${batch.length} translation verses for Surah $surahNum");
            } else {
              AppLogger.w(
                  "Repo: Empty V3 translation batch for Surah $surahNum - $url");
            }
          } catch (e) {
            AppLogger.e(
                "Repo: Failed Surah $surahNum for Translation $customId (V3) - $e");
          }
        }
      },
      onProgress: (pct) {
        final p = (pct * 100).toInt();
        AppLogger.i("Repo: Download Progress $type: $p%");
        onProgress('Downloading $type: $p%');
      },
    );
  }

  Future<void> _downloadWordByWordData(
      String lang, String eid, ValueSetter<String> onProgress) async {
    final last = await (_db.select(_db.wordTranslations)
          ..where((t) => t.edition.equals(eid))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.surahNumber)])
          ..limit(1))
        .getSingleOrNull();

    final start = (last?.surahNumber ?? 0) + 1;
    if (start > 114) {
      onProgress("WbW $eid Complete");
      return;
    }

    final surahIds = List<int>.generate(114 - start + 1, (i) => start + i);

    // OPTIMIZATION 9: Increased batch size for WbW (Stable)
    // REDUCED BATCH: 30 -> 4 to prevent Timeouts on slow connections
    await _processInBatches<int>(
      surahIds,
      4,
      (surahNum) async {
        // --- CHANGE: Request 'text_indopak' in word_fields ---
        final r = await _getWithRetry(
            '$_baseUrl/verses/by_chapter/$surahNum?language=$lang&words=true&word_translation_language=$lang&word_fields=text_indopak,text_uthmani,translation,transliteration&per_page=all');

        final verses = (json.decode(r.body) as Map)['verses'] as List;
        final batch = <WordTranslationsCompanion>[];

        for (var v in verses) {
          final k = (v['verse_key'].toString()).split(':');
          final wList = v['words'] as List;
          for (var w in wList) {
            if (w['char_type_name'] == 'end') continue;

            // --- CHANGE: Use text_indopak if available, else fallback ---
            final arabicText = w['text_indopak'] ?? w['text_uthmani'] ?? '';

            batch.add(WordTranslationsCompanion(
              surahNumber: drift.Value(int.parse(k[0])),
              numberInSurah: drift.Value(int.parse(k[1])),
              wordNumber: drift.Value(w['position']),
              edition: drift.Value(eid),
              arabicText: drift.Value(arabicText),
              translation: drift.Value(w['translation']['text'] ?? ''),
              transliteration: drift.Value(w['transliteration']['text'] ?? ''),
              audioUrl: drift.Value(w['audio_url']),
            ));
          }
        }
        await _db.addWordTranslations(batch);
      },
      onProgress: (pct) =>
          onProgress('Downloading WbW: ${(pct * 100).toInt()}%'),
    );
  }

  Future<Map<String, String>> _fetchAudioUrlsForReciter(
      int surahNum, String reciterId) async {
    final url =
        '$_baseUrl/recitations/$reciterId/by_chapter/$surahNum?per_page=all';
    try {
      final response = await _getWithRetry(url);
      final data = json.decode(response.body);
      final audioFiles = data['audio_files'] as List;

      final Map<String, String> urlMap = {};
      for (var item in audioFiles) {
        final key = item['verse_key'];
        String audioUrl = item['url'];
        if (audioUrl.startsWith('//')) {
          audioUrl = 'https:$audioUrl';
        } else if (!audioUrl.startsWith('http')) {
          audioUrl = 'https://verses.quran.com/$audioUrl';
        }
        urlMap[key] = audioUrl;
      }
      return urlMap;
    } catch (e) {
      AppLogger.e("Repo: Failed to fetch audio URL list for S$surahNum", e);
      return {};
    }
  }

  Future<String> _resolveTranslationId(String identifier) async {
    if (identifier == 'transliteration' || identifier == '131') return '131';

    if (_slugToIdMap == null) {
      try {
        final r =
            await _getWithRetry('$_baseUrl/resources/translations?language=en');
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        final list = data['translations'] as List<dynamic>;

        _slugToIdMap = {};
        for (var item in list) {
          final id = item['id'] as int?;
          final slug = item['slug'] as String?;
          if (id != null && slug != null) {
            _slugToIdMap![slug] = id;
          }
        }
      } catch (e) {
        return identifier;
      }
    }
    if (_slugToIdMap!.containsKey(identifier)) {
      return _slugToIdMap![identifier].toString();
    }
    return identifier;
  }

  Future<bool> isBaseDataDownloaded() async {
    final prefCheck = _prefs.getBool(_kBaseDataDownloadedKey) ?? false;
    if (prefCheck) return await _db.isBaseDataDownloaded();
    return false;
  }

  Future<void> _markBaseDataAsDownloaded() async {
    await _prefs.setBool(_kBaseDataDownloadedKey, true);
  }

  Future<bool> isEditionDownloaded(String id) async {
    return await _db.isEditionDownloaded(id);
  }

  Future<bool> isSurahAudioDownloaded(int surahNum, String reciterId) async {
    final surah = await _db.getSurahByNumber(surahNum);
    if (surah == null) return false;

    final count = await (_db.select(_db.downloadedAudios)
          ..where((a) =>
              a.surahNumber.equals(surahNum) &
              a.reciterIdentifier.equals(reciterId)))
        .get()
        .then((v) => v.length);

    return count >= (surah.numberOfAyahs - 1);
  }

  Future<Set<String>> getDownloadedEditionIds() async {
    final query = _db.selectOnly(_db.translations, distinct: true)
      ..addColumns([_db.translations.edition]);
    final results =
        await query.map((row) => row.read(_db.translations.edition)).get();

    final wbwQuery = _db.selectOnly(_db.wordTranslations, distinct: true)
      ..addColumns([_db.wordTranslations.edition]);
    final wbwResults = await wbwQuery
        .map((row) => row.read(_db.wordTranslations.edition))
        .get();

    return {...results.whereType<String>(), ...wbwResults.whereType<String>()};
  }
}

// -----------------------------------------------------------------------------
// UPDATED PROVIDER
// -----------------------------------------------------------------------------
final mobileQuranRepositoryProvider = Provider<MobileQuranRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return MobileQuranRepository(db, prefs);
});
