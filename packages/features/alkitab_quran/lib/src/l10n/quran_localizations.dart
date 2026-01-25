import 'package:flutter/widgets.dart';

abstract class QuranLocalizations {
  static QuranLocalizations? of(BuildContext context) {
    return Localizations.of<QuranLocalizations>(context, QuranLocalizations);
  }

  String get surahs;
  String get juz;
  String get searchSurah;
  String get search;
  String get ayahs;
  String get ayah; // Singular
  String get verses;
  String get meccan;
  String get medinan;
  
  // Settings
  String get searchSettings;
  String get settingsTitle;
  String get version;
  
  // Research
  String get grammar;
  String get history;
  String get reflect;
}
