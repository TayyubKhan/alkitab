// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StorageViewModel)
const storageViewModelProvider = StorageViewModelProvider._();

final class StorageViewModelProvider
    extends $AsyncNotifierProvider<StorageViewModel, StorageStats> {
  const StorageViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storageViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storageViewModelHash();

  @$internal
  @override
  StorageViewModel create() => StorageViewModel();
}

String _$storageViewModelHash() => r'e1b4277bf42d874fd00d1ad29d86f17a9b20b5ce';

abstract class _$StorageViewModel extends $AsyncNotifier<StorageStats> {
  FutureOr<StorageStats> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<StorageStats>, StorageStats>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<StorageStats>, StorageStats>,
        AsyncValue<StorageStats>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
