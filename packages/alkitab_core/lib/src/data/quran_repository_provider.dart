import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../abstractions/quran_repository.dart';

// Global Provider - To be overridden in main() of apps
final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  throw UnimplementedError('quranRepositoryProvider must be overridden');
});
