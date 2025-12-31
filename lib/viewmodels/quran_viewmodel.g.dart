// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SurahLimitNotifier)
const surahLimitProvider = SurahLimitNotifierFamily._();

final class SurahLimitNotifierProvider
    extends $NotifierProvider<SurahLimitNotifier, int> {
  const SurahLimitNotifierProvider._(
      {required SurahLimitNotifierFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'surahLimitProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$surahLimitNotifierHash();

  @override
  String toString() {
    return r'surahLimitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SurahLimitNotifier create() => SurahLimitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SurahLimitNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$surahLimitNotifierHash() =>
    r'a6b760058a388da8ad0e4fdc48afa8a25a1cd4e2';

final class SurahLimitNotifierFamily extends $Family
    with $ClassFamilyOverride<SurahLimitNotifier, int, int, int, int> {
  const SurahLimitNotifierFamily._()
      : super(
          retry: null,
          name: r'surahLimitProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SurahLimitNotifierProvider call(
    int surahNumber,
  ) =>
      SurahLimitNotifierProvider._(argument: surahNumber, from: this);

  @override
  String toString() => r'surahLimitProvider';
}

abstract class _$SurahLimitNotifier extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get surahNumber => _$args;

  int build(
    int surahNumber,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(surahList)
const surahListProvider = SurahListProvider._();

final class SurahListProvider extends $FunctionalProvider<
        AsyncValue<List<Surah>>, List<Surah>, FutureOr<List<Surah>>>
    with $FutureModifier<List<Surah>>, $FutureProvider<List<Surah>> {
  const SurahListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'surahListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$surahListHash();

  @$internal
  @override
  $FutureProviderElement<List<Surah>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Surah>> create(Ref ref) {
    return surahList(ref);
  }
}

String _$surahListHash() => r'8f4b1aaad902c1135f24db76f092de4059882b6f';

@ProviderFor(allEditions)
const allEditionsProvider = AllEditionsProvider._();

final class AllEditionsProvider extends $FunctionalProvider<
        AsyncValue<List<Edition>>, List<Edition>, FutureOr<List<Edition>>>
    with $FutureModifier<List<Edition>>, $FutureProvider<List<Edition>> {
  const AllEditionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'allEditionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allEditionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Edition>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Edition>> create(Ref ref) {
    return allEditions(ref);
  }
}

String _$allEditionsHash() => r'03d90484cfd0d28423057e763e467d3a1b31258a';

@ProviderFor(allReciters)
const allRecitersProvider = AllRecitersProvider._();

final class AllRecitersProvider extends $FunctionalProvider<
        AsyncValue<List<Reciter>>, List<Reciter>, FutureOr<List<Reciter>>>
    with $FutureModifier<List<Reciter>>, $FutureProvider<List<Reciter>> {
  const AllRecitersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'allRecitersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allRecitersHash();

  @$internal
  @override
  $FutureProviderElement<List<Reciter>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Reciter>> create(Ref ref) {
    return allReciters(ref);
  }
}

String _$allRecitersHash() => r'c85665cb4ee62707b1a51f1dc7e63497aa70bbd2';

@ProviderFor(isSurahAudioDownloaded)
const isSurahAudioDownloadedProvider = IsSurahAudioDownloadedFamily._();

final class IsSurahAudioDownloadedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsSurahAudioDownloadedProvider._(
      {required IsSurahAudioDownloadedFamily super.from,
      required ({
        String reciter,
        int surah,
      })
          super.argument})
      : super(
          retry: null,
          name: r'isSurahAudioDownloadedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isSurahAudioDownloadedHash();

  @override
  String toString() {
    return r'isSurahAudioDownloadedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({
      String reciter,
      int surah,
    });
    return isSurahAudioDownloaded(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsSurahAudioDownloadedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isSurahAudioDownloadedHash() =>
    r'ff446cc1e498faec55a6f92ed41e71c59624f093';

final class IsSurahAudioDownloadedFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<bool>,
            ({
              String reciter,
              int surah,
            })> {
  const IsSurahAudioDownloadedFamily._()
      : super(
          retry: null,
          name: r'isSurahAudioDownloadedProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  IsSurahAudioDownloadedProvider call(
    ({
      String reciter,
      int surah,
    }) args,
  ) =>
      IsSurahAudioDownloadedProvider._(argument: args, from: this);

  @override
  String toString() => r'isSurahAudioDownloadedProvider';
}

@ProviderFor(isWbWEditionDownloaded)
const isWbWEditionDownloadedProvider = IsWbWEditionDownloadedFamily._();

final class IsWbWEditionDownloadedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsWbWEditionDownloadedProvider._(
      {required IsWbWEditionDownloadedFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'isWbWEditionDownloadedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isWbWEditionDownloadedHash();

  @override
  String toString() {
    return r'isWbWEditionDownloadedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isWbWEditionDownloaded(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsWbWEditionDownloadedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isWbWEditionDownloadedHash() =>
    r'cc61decddcbb190c7f0f95654f1a0130d288bd50';

final class IsWbWEditionDownloadedFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const IsWbWEditionDownloadedFamily._()
      : super(
          retry: null,
          name: r'isWbWEditionDownloadedProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  IsWbWEditionDownloadedProvider call(
    String id,
  ) =>
      IsWbWEditionDownloadedProvider._(argument: id, from: this);

  @override
  String toString() => r'isWbWEditionDownloadedProvider';
}

@ProviderFor(ayahReader)
const ayahReaderProvider = AyahReaderFamily._();

final class AyahReaderProvider extends $FunctionalProvider<
        AsyncValue<List<AyahWithTranslations>>,
        List<AyahWithTranslations>,
        FutureOr<List<AyahWithTranslations>>>
    with
        $FutureModifier<List<AyahWithTranslations>>,
        $FutureProvider<List<AyahWithTranslations>> {
  const AyahReaderProvider._(
      {required AyahReaderFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'ayahReaderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ayahReaderHash();

  @override
  String toString() {
    return r'ayahReaderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AyahWithTranslations>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AyahWithTranslations>> create(Ref ref) {
    final argument = this.argument as int;
    return ayahReader(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AyahReaderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ayahReaderHash() => r'3d7747dc0ea8ee26ce7238275e662e8838e39bb5';

final class AyahReaderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AyahWithTranslations>>, int> {
  const AyahReaderFamily._()
      : super(
          retry: null,
          name: r'ayahReaderProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AyahReaderProvider call(
    int surahNum,
  ) =>
      AyahReaderProvider._(argument: surahNum, from: this);

  @override
  String toString() => r'ayahReaderProvider';
}
