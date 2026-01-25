import 'package:flutter/widgets.dart';
import 'package:alkitab_web/l10n/gen/app_localizations.dart';
import 'package:alkitab_quran/alkitab_quran.dart';

/// Adapter that makes AppLocalizations match QuranLocalizations interface
class AppQuranLocalizations extends QuranLocalizations {
  final AppLocalizations _appLocalizations;

  AppQuranLocalizations(this._appLocalizations);

  @override
  String get surahs => _appLocalizations.surahs;
  @override
  String get juz => _appLocalizations.juz;
  @override
  String get searchSurah => _appLocalizations.searchSurah;
  @override
  String get search => _appLocalizations.search;
  @override
  String get ayahs => _appLocalizations.ayahs;
  @override
  String get ayah => _appLocalizations.ayah;
  @override
  String get verses => _appLocalizations.verses;
  @override
  String get meccan => _appLocalizations.meccan;
  @override
  String get medinan => _appLocalizations.medinan;
  
  @override
  String get searchSettings => _appLocalizations.searchSettings;
  @override
  String get settingsTitle => _appLocalizations.settingsTitle;
  @override
  String get version => _appLocalizations.version;
  
  @override
  String get grammar => _appLocalizations.grammar;
  @override
  String get history => _appLocalizations.history;
  @override
  String get reflect => _appLocalizations.reflect;
}

class AppQuranLocalizationsDelegate extends LocalizationsDelegate<QuranLocalizations> {
  const AppQuranLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.delegate.isSupported(locale);

  @override
  Future<QuranLocalizations> load(Locale locale) async {
    final appLocalizations = await AppLocalizations.delegate.load(locale);
    return AppQuranLocalizations(appLocalizations);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<QuranLocalizations> old) => false;
}
