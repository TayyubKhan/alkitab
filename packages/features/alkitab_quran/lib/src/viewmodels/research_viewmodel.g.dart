// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResearchNotifier)
const researchProvider = ResearchNotifierFamily._();

final class ResearchNotifierProvider
    extends $NotifierProvider<ResearchNotifier, List<ResearchMessage>> {
  const ResearchNotifierProvider._({
    required ResearchNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'researchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$researchNotifierHash();

  @override
  String toString() {
    return r'researchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ResearchNotifier create() => ResearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ResearchMessage> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ResearchMessage>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ResearchNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$researchNotifierHash() => r'891fb1dded4430786797ec0acfa771dd2240f6ab';

final class ResearchNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ResearchNotifier,
          List<ResearchMessage>,
          List<ResearchMessage>,
          List<ResearchMessage>,
          String
        > {
  const ResearchNotifierFamily._()
    : super(
        retry: null,
        name: r'researchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ResearchNotifierProvider call(String key) =>
      ResearchNotifierProvider._(argument: key, from: this);

  @override
  String toString() => r'researchProvider';
}

abstract class _$ResearchNotifier extends $Notifier<List<ResearchMessage>> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  List<ResearchMessage> build(String key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<List<ResearchMessage>, List<ResearchMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ResearchMessage>, List<ResearchMessage>>,
              List<ResearchMessage>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
