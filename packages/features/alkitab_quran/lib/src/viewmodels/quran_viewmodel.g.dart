// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(surahList)
const surahListProvider = SurahListProvider._();

final class SurahListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Surah>>,
          List<Surah>,
          FutureOr<List<Surah>>
        >
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Surah>> create(Ref ref) {
    return surahList(ref);
  }
}

String _$surahListHash() => r'8581e82ee56a96ab88a99f05031d11c15fb91d19';

@ProviderFor(SurahLimit)
const surahLimitProvider = SurahLimitFamily._();

final class SurahLimitProvider extends $NotifierProvider<SurahLimit, int> {
  const SurahLimitProvider._({
    required SurahLimitFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'surahLimitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$surahLimitHash();

  @override
  String toString() {
    return r'surahLimitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SurahLimit create() => SurahLimit();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SurahLimitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$surahLimitHash() => r'f34109bc5667412fa0ec96354b1aa61e575da167';

final class SurahLimitFamily extends $Family
    with $ClassFamilyOverride<SurahLimit, int, int, int, int> {
  const SurahLimitFamily._()
    : super(
        retry: null,
        name: r'surahLimitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SurahLimitProvider call(int surahNumber) =>
      SurahLimitProvider._(argument: surahNumber, from: this);

  @override
  String toString() => r'surahLimitProvider';
}

abstract class _$SurahLimit extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get surahNumber => _$args;

  int build(int surahNumber);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ayahReader)
const ayahReaderProvider = AyahReaderFamily._();

final class AyahReaderProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AyahWithTranslations>>,
          List<AyahWithTranslations>,
          FutureOr<List<AyahWithTranslations>>
        >
    with
        $FutureModifier<List<AyahWithTranslations>>,
        $FutureProvider<List<AyahWithTranslations>> {
  const AyahReaderProvider._({
    required AyahReaderFamily super.from,
    required int super.argument,
  }) : super(
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AyahWithTranslations>> create(Ref ref) {
    final argument = this.argument as int;
    return ayahReader(ref, argument);
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

String _$ayahReaderHash() => r'ae7700dfae315312dc8ff128dbcb4321ba1db3e7';

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

  AyahReaderProvider call(int surahNumber) =>
      AyahReaderProvider._(argument: surahNumber, from: this);

  @override
  String toString() => r'ayahReaderProvider';
}

@ProviderFor(allEditions)
const allEditionsProvider = AllEditionsProvider._();

final class AllEditionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Edition>>,
          List<Edition>,
          FutureOr<List<Edition>>
        >
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Edition>> create(Ref ref) {
    return allEditions(ref);
  }
}

String _$allEditionsHash() => r'671227fb985b415b99d8df2f081cd32432abfa65';

@ProviderFor(allReciters)
const allRecitersProvider = AllRecitersProvider._();

final class AllRecitersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Reciter>>,
          List<Reciter>,
          FutureOr<List<Reciter>>
        >
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Reciter>> create(Ref ref) {
    return allReciters(ref);
  }
}

String _$allRecitersHash() => r'2c37b2621a04ecca92ec3f9943bf64fa81063a80';

@ProviderFor(isSurahAudioDownloaded)
const isSurahAudioDownloadedProvider = IsSurahAudioDownloadedFamily._();

final class IsSurahAudioDownloadedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsSurahAudioDownloadedProvider._({
    required IsSurahAudioDownloadedFamily super.from,
    required ({String reciter, int surah}) super.argument,
  }) : super(
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
    final argument = this.argument as ({String reciter, int surah});
    return isSurahAudioDownloaded(ref, argument);
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
    r'3e7eb08fe7abd428d18d3d6ca39e99bbbfeef3e3';

final class IsSurahAudioDownloadedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String reciter, int surah})
        > {
  const IsSurahAudioDownloadedFamily._()
    : super(
        retry: null,
        name: r'isSurahAudioDownloadedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsSurahAudioDownloadedProvider call(({String reciter, int surah}) arg) =>
      IsSurahAudioDownloadedProvider._(argument: arg, from: this);

  @override
  String toString() => r'isSurahAudioDownloadedProvider';
}
