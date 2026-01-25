import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:alkitab_core/alkitab_core.dart';
import 'package:alkitab_models/alkitab_models.dart';

class WebQuranRepository implements QuranRepository {
  static const String _baseUrl = 'https://api.quran.com/api/v4';

  @override
  Future<List<Surah>> getAllSurahs() async {
    final response = await http.get(Uri.parse('$_baseUrl/chapters?language=en'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> chapters = data['chapters'];
      return chapters.map<Surah>((json) {
        return Surah(
          number: json['id'],
          name: json['name_simple'] ?? json['name_complex'] ?? '',
          englishName: json['name_complex'] ?? '',
          englishNameTranslation: json['translated_name']?['name'] ?? '',
          revelationType: json['revelation_place'] ?? '',
          numberOfAyahs: json['verses_count'] ?? 0,
        );
      }).toList();
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  @override
  Future<List<AyahWithTranslations>> getAyahsForSurah(
      int surahNumber,
      List<String> editionIdentifiers,
      String? wordByWordEdition,
      String? reciterIdentifier,
      {int limit = 20,
      int offset = 0}) async {
      
    // Fetch Verses
    // api.quran.com/api/v4/verses/by_chapter/1?language=en&words=true&translations=131&per_page=20&page=1
    // Note: 'offset' in interface vs 'page' in API.
    // 'offset' usually implies item index. 'page' is offset / limit + 1.
    final page = (offset / limit).floor() + 1;
    
    // Identifiers: API uses IDs (integers). We assume identifiers are integers for now or map them.
    // Default to Saheeh International (131) if clear mismatch.
    // The mobile app might pass 'en.sahih' which needs mapping map.
    // For Web Demo, hardcode 131 (Saheeh).
    
    // URL with explicit fields
    final url = '$_baseUrl/verses/by_chapter/$surahNumber?language=en&words=true&translations=131&per_page=$limit&page=$page&fields=text_uthmani';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> verses = data['verses'];
        
        return verses.map((v) {
             // Defensive Translation Mapping
             final translations = <String, String>{};
             if (v['translations'] != null) {
                 for (var t in v['translations']) {
                     if (t == null) continue;
                     
                     final resourceId = t['resource_id']?.toString();
                     final text = t['text'];
                     
                     if (resourceId != null && text is String) {
                        translations[resourceId] = text;
                     } else {
                        debugPrint("WebRepo: Skipping invalid translation. ID: $resourceId, TextType: ${text.runtimeType}");
                     }
                 }
             }
             
             // Defensive Word Mapping
             final words = <AyahWord>[];
             if (v['words'] != null) {
                 int i = 0;
                 for (var w in v['words']) {
                     if (w == null) continue;
                     
                     // Helper for safe string
                     String safe(dynamic val) => val?.toString() ?? "";
                     
                     words.add(AyahWord(
                         wordNumber: i++,
                         // Prioritize text_uthmani for extracting word text
                         arabicText: safe(w['text_uthmani'] ?? w['text'] ?? w['char_type_name']),
                         translation: safe(w['translation']?['text']),
                         transliteration: safe(w['transliteration']?['text']),
                     ));
                 }
             }
             
             // Defensive Ayah Construction and Fallback
             final verseNum = v['verse_number'] as int? ?? 0;
             if (verseNum == 0) debugPrint("WebRepo: Warning Verse Number is 0 or null for ${v['id']}");

             // Fallback for Arabic Text if missing
             String arabicText = v['text_uthmani']?.toString() ?? "";
             if (arabicText.isEmpty && words.isNotEmpty) {
                 // Reconstruct from words (skip end marker if present, usually last word is marker)
                 arabicText = words.map((w) => w.arabicText).join(' ');
             }

             return AyahWithTranslations(
                 numberInSurah: verseNum,
                 arabicText: arabicText, 
                 translations: translations,
                 tafsirs: {},
                 words: words,
                 audioUrl: "", 
                 tajweedText: null,
                 transliteration: null,
             );
        }).toList();
    }
    
    return [];
  }

  @override
  Future<List<QuranSearchResult>> searchAyahs(String query) async {
    return [];
  }
  
  @override
  Future<List<Edition>> getAllTranslationEditions() async {
    // https://api.quran.com/api/v4/resources/translations
    try {
      final response = await http.get(Uri.parse('$_baseUrl/resources/translations?language=en'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> translations = data['translations'];
        
        return translations.map((t) => Edition(
          identifier: t['id'].toString(), // API uses int ID, we use String identifier usually. 
                                          // BE CAREFUL: Android app might expect specific string format like 'en.sahih'.
                                          // For now, using ID as identifier.
                                          // If Android app expects 'language.name', we might need to construct it.
          language: t['language_name'],
          name: t['name'],
          englishName: t['author_name'],
          type: 'translation',
        )).toList();
      }
    } catch (e) {
      debugPrint("Error fetching editions: $e");
    }
    
    // Fallback if API fails
    return [
       Edition(identifier: 'en.sahih', language: 'en', name: 'Saheeh International', englishName: 'Saheeh International', type: 'translation'),
    ];
  }
  
  @override
  Future<List<Reciter>> getAllReciters() async {
    // https://api.quran.com/api/v4/resources/recitations
    try {
      final response = await http.get(Uri.parse('$_baseUrl/resources/recitations?language=en'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> reciters = data['recitations'];
        
        return reciters.map<Reciter>((r) => Reciter(
          identifier: r['id'].toString(), 
          language: 'ar', 
          name: r['reciter_name'],
          englishName: r['reciter_name'], 
        )).toList();
      }
    } catch (e) {
      debugPrint("Error fetching reciters: $e");
    }

    // Fallback
    return [
        Reciter(identifier: 'ar.alafasy', language: 'ar', name: 'Mishary Rashid Alafasy', englishName: 'Mishary Rashid Alafasy'),
    ];
  }

  @override
  Future<void> deleteAllLocalData() async {
    // Web implementation: Clear LocalStorage?
  }

  @override
  Future<bool> isEditionDownloaded(String id) async {
    return false; // Web relies on live API for now
  }

  @override
  Future<bool> isBaseDataDownloaded() async {
    return true; // Web uses live API, base data is "always there"
  }

  @override
  Future<void> downloadAndStoreTranslation(String id, ValueSetter<String> progress) async {
    // Web: No-op or fetch and cache
  }

  @override
  Future<void> downloadInitialData(SetupOptions options, ValueSetter<String> progress) async {
    // Web: No initial download needed
  }
}
