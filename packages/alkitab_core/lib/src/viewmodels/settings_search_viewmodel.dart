import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'settings_search_viewmodel.g.dart';

@riverpod
class SettingsSearchQuery extends _$SettingsSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}
