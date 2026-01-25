// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_search_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsSearchQuery)
const settingsSearchQueryProvider = SettingsSearchQueryProvider._();

final class SettingsSearchQueryProvider
    extends $NotifierProvider<SettingsSearchQuery, String> {
  const SettingsSearchQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsSearchQueryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsSearchQueryHash();

  @$internal
  @override
  SettingsSearchQuery create() => SettingsSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$settingsSearchQueryHash() =>
    r'51fef8b15c69895dddc98cd7fb7ba6cabd39bb67';

abstract class _$SettingsSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
