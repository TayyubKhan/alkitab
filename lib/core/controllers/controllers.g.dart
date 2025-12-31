// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the local state of the Setup Screen (Reciter selection)
/// and orchestrates the download sequence.

@ProviderFor(AutoSetupController)
const autoSetupControllerProvider = AutoSetupControllerProvider._();

/// Manages the local state of the Setup Screen (Reciter selection)
/// and orchestrates the download sequence.
final class AutoSetupControllerProvider
    extends $NotifierProvider<AutoSetupController, String?> {
  /// Manages the local state of the Setup Screen (Reciter selection)
  /// and orchestrates the download sequence.
  const AutoSetupControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'autoSetupControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$autoSetupControllerHash();

  @$internal
  @override
  AutoSetupController create() => AutoSetupController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$autoSetupControllerHash() =>
    r'2e885d9c6f174dc3dfe8184d9d2afbea04e85fdf';

/// Manages the local state of the Setup Screen (Reciter selection)
/// and orchestrates the download sequence.

abstract class _$AutoSetupController extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Computes the grouped and sorted translations for the Setup Screen.
/// Moves heavy list manipulation out of the UI.

@ProviderFor(sortedTranslations)
const sortedTranslationsProvider = SortedTranslationsProvider._();

/// Computes the grouped and sorted translations for the Setup Screen.
/// Moves heavy list manipulation out of the UI.

final class SortedTranslationsProvider extends $FunctionalProvider<
        List<MapEntry<String, List<Edition>>>,
        List<MapEntry<String, List<Edition>>>,
        List<MapEntry<String, List<Edition>>>>
    with $Provider<List<MapEntry<String, List<Edition>>>> {
  /// Computes the grouped and sorted translations for the Setup Screen.
  /// Moves heavy list manipulation out of the UI.
  const SortedTranslationsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sortedTranslationsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sortedTranslationsHash();

  @$internal
  @override
  $ProviderElement<List<MapEntry<String, List<Edition>>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<MapEntry<String, List<Edition>>> create(Ref ref) {
    return sortedTranslations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MapEntry<String, List<Edition>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<List<MapEntry<String, List<Edition>>>>(value),
    );
  }
}

String _$sortedTranslationsHash() =>
    r'c46e50373e0a5b15b00b62b3fb26cb5af6282865';

@ProviderFor(SurahListController)
const surahListControllerProvider = SurahListControllerProvider._();

final class SurahListControllerProvider
    extends $NotifierProvider<SurahListController, void> {
  const SurahListControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'surahListControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$surahListControllerHash();

  @$internal
  @override
  SurahListController create() => SurahListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$surahListControllerHash() =>
    r'87e66f4233d9dc7ba6a2f88d3cb6e96b6b41c788';

abstract class _$SurahListController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}
