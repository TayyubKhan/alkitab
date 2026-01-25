import 'package:flutter/foundation.dart';

@immutable
class SetupOptions {
  final Set<String> fullEditions;
  final Set<String> wbwEditions;
  final String? offlineReciterId;
  final bool shouldDownloadReciter;

  const SetupOptions({
    required this.fullEditions,
    required this.wbwEditions,
    this.offlineReciterId,
    this.shouldDownloadReciter = true,
  });

  SetupOptions copyWith({
    Set<String>? fullEditions,
    Set<String>? wbwEditions,
    String? offlineReciterId,
    bool? shouldDownloadReciter,
    bool clearReciter = false,
  }) {
    return SetupOptions(
      fullEditions: fullEditions ?? this.fullEditions,
      wbwEditions: wbwEditions ?? this.wbwEditions,
      offlineReciterId:
          clearReciter ? null : (offlineReciterId ?? this.offlineReciterId),
      shouldDownloadReciter:
          shouldDownloadReciter ?? this.shouldDownloadReciter,
    );
  }
}
