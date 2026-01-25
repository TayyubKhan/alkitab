import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/local/app_database.dart';

part 'storage_viewmodel.g.dart';

// -----------------------------------------------------------------------------
// MODELS
// -----------------------------------------------------------------------------

@immutable
class StorageStats {
  final int totalBytes;
  final int databaseBytes;
  final int cacheBytes;
  final List<ReciterStorage> reciters;

  const StorageStats({
    this.totalBytes = 0,
    this.databaseBytes = 0,
    this.cacheBytes = 0,
    this.reciters = const [],
  });

  String get formattedTotal => _formatBytes(totalBytes);
  String get formattedDatabase => _formatBytes(databaseBytes);
  String get formattedCache => _formatBytes(cacheBytes);

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    }
    return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
  }
}

@immutable
class ReciterStorage {
  final String id;
  final String name; // Ideally we fetch this, but ID is okay for now
  final int totalBytes;
  final List<SurahStorage> surahs;

  const ReciterStorage({
    required this.id,
    this.name = '',
    required this.totalBytes,
    required this.surahs,
  });

  String get formattedSize => StorageStats._formatBytes(totalBytes);
}

@immutable
class SurahStorage {
  final int number;
  final int totalBytes;

  const SurahStorage({required this.number, required this.totalBytes});

  String get formattedSize => StorageStats._formatBytes(totalBytes);
}

// -----------------------------------------------------------------------------
// VIEWMODEL
// -----------------------------------------------------------------------------

@riverpod
class StorageViewModel extends _$StorageViewModel {
  late AppDatabase _db;

  @override
  Future<StorageStats> build() async {
    _db = ref.watch(databaseProvider);
    return _calculateStorage();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _calculateStorage());
  }

  Future<StorageStats> _calculateStorage() async {
    int total = 0;

    // 1. Calculate Cache
    int cacheSize = 0;
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.listSync(recursive: true, followLinks: false).forEach((e) {
          if (e is File) cacheSize += e.lengthSync();
        });
      }
    } catch (_) {}
    total += cacheSize;

    // 2. Calculate Database
    int dbSize = 0;
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(docDir.path, 'quran.sqlite'));
      if (dbFile.existsSync()) {
        dbSize = dbFile.lengthSync();
      }
    } catch (_) {}
    total += dbSize;

    // 3. Calculate Audio (Grouped by Reciter > Surah)
    // We query the DB for all downloaded files
    final allFiles = await _db.select(_db.downloadedAudios).get();

    // Grouping
    final Map<String, Map<int, int>> reciterMap =
        {}; // ReciterId -> {SurahNum -> Bytes}

    for (final row in allFiles) {
      final file = File(row.localPath);
      if (file.existsSync()) {
        final size = file.lengthSync();
        total += size;

        reciterMap.putIfAbsent(row.reciterIdentifier, () => {});
        reciterMap[row.reciterIdentifier]!
            .putIfAbsent(row.surahNumber, () => 0);
        reciterMap[row.reciterIdentifier]![row.surahNumber] =
            reciterMap[row.reciterIdentifier]![row.surahNumber]! + size;
      }
    }

    // Convert to models
    final List<ReciterStorage> reciters = [];

    // We need reciter names. For now, we will use the ID or try to fetch from cache table if available.
    // Ideally we join with CachedReciters table.
    final cachedReciters = await _db.select(_db.cachedReciters).get();
    final reciterNameMap = {for (var r in cachedReciters) r.identifier: r.name};

    reciterMap.forEach((reciterId, surahMap) {
      int reciterTotal = 0;
      final List<SurahStorage> surahs = [];

      surahMap.forEach((surahNum, size) {
        reciterTotal += size;
        surahs.add(SurahStorage(number: surahNum, totalBytes: size));
      });

      surahs.sort((a, b) => a.number.compareTo(b.number));

      reciters.add(ReciterStorage(
        id: reciterId,
        name: reciterNameMap[reciterId] ?? reciterId,
        totalBytes: reciterTotal,
        surahs: surahs,
      ));
    });

    reciters
        .sort((a, b) => b.totalBytes.compareTo(a.totalBytes)); // Largest first

    return StorageStats(
      totalBytes: total,
      databaseBytes: dbSize,
      cacheBytes: cacheSize,
      reciters: reciters,
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------

  Future<void> clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
      ref.invalidateSelf();
    } catch (e) {
      debugPrint("Error clearing cache: $e");
    }
  }

  Future<void> deleteSurahAudio(String reciterId, int surahNumber) async {
    // 1. Get files from DB
    final files = await (_db.select(_db.downloadedAudios)
          ..where((a) =>
              a.reciterIdentifier.equals(reciterId) &
              a.surahNumber.equals(surahNumber)))
        .get();

    // 2. Delete Physical Files
    for (final row in files) {
      final f = File(row.localPath);
      if (f.existsSync()) {
        try {
          f.deleteSync();
        } catch (_) {}
      }
    }

    // 3. Delete DB Records
    await (_db.delete(_db.downloadedAudios)
          ..where((a) =>
              a.reciterIdentifier.equals(reciterId) &
              a.surahNumber.equals(surahNumber)))
        .go();

    // 4. Update UI
    ref.invalidateSelf();
  }

  Future<void> deleteReciter(String reciterId) async {
    // 1. Get files
    final files = await (_db.select(_db.downloadedAudios)
          ..where((a) => a.reciterIdentifier.equals(reciterId)))
        .get();

    // 2. Delete Physical Files
    for (final row in files) {
      final f = File(row.localPath);
      if (f.existsSync()) {
        try {
          f.deleteSync();
        } catch (_) {}
      }
    }

    // 3. Delete Reciter Directory (Cleanup empty folder)
    try {
      if (files.isNotEmpty) {
        final firstFile = File(files.first.localPath);
        final reciterDir = firstFile.parent;
        if (reciterDir.existsSync()) {
          reciterDir.deleteSync(recursive: true);
        }
      }
    } catch (_) {}

    // 4. Delete DB Records
    await (_db.delete(_db.downloadedAudios)
          ..where((a) => a.reciterIdentifier.equals(reciterId)))
        .go();

    ref.invalidateSelf();
  }
}
