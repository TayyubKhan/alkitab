// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, SurahsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _englishNameMeta =
      const VerificationMeta('englishName');
  @override
  late final GeneratedColumn<String> englishName = GeneratedColumn<String>(
      'english_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _englishNameTranslationMeta =
      const VerificationMeta('englishNameTranslation');
  @override
  late final GeneratedColumn<String> englishNameTranslation =
      GeneratedColumn<String>('english_name_translation', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revelationTypeMeta =
      const VerificationMeta('revelationType');
  @override
  late final GeneratedColumn<String> revelationType = GeneratedColumn<String>(
      'revelation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberOfAyahsMeta =
      const VerificationMeta('numberOfAyahs');
  @override
  late final GeneratedColumn<int> numberOfAyahs = GeneratedColumn<int>(
      'number_of_ayahs', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        number,
        name,
        englishName,
        englishNameTranslation,
        revelationType,
        numberOfAyahs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(Insertable<SurahsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('english_name')) {
      context.handle(
          _englishNameMeta,
          englishName.isAcceptableOrUnknown(
              data['english_name']!, _englishNameMeta));
    } else if (isInserting) {
      context.missing(_englishNameMeta);
    }
    if (data.containsKey('english_name_translation')) {
      context.handle(
          _englishNameTranslationMeta,
          englishNameTranslation.isAcceptableOrUnknown(
              data['english_name_translation']!, _englishNameTranslationMeta));
    } else if (isInserting) {
      context.missing(_englishNameTranslationMeta);
    }
    if (data.containsKey('revelation_type')) {
      context.handle(
          _revelationTypeMeta,
          revelationType.isAcceptableOrUnknown(
              data['revelation_type']!, _revelationTypeMeta));
    } else if (isInserting) {
      context.missing(_revelationTypeMeta);
    }
    if (data.containsKey('number_of_ayahs')) {
      context.handle(
          _numberOfAyahsMeta,
          numberOfAyahs.isAcceptableOrUnknown(
              data['number_of_ayahs']!, _numberOfAyahsMeta));
    } else if (isInserting) {
      context.missing(_numberOfAyahsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SurahsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahsData(
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      englishName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}english_name'])!,
      englishNameTranslation: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}english_name_translation'])!,
      revelationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}revelation_type'])!,
      numberOfAyahs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_of_ayahs'])!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class SurahsData extends DataClass implements Insertable<SurahsData> {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  const SurahsData(
      {required this.number,
      required this.name,
      required this.englishName,
      required this.englishNameTranslation,
      required this.revelationType,
      required this.numberOfAyahs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['number'] = Variable<int>(number);
    map['name'] = Variable<String>(name);
    map['english_name'] = Variable<String>(englishName);
    map['english_name_translation'] = Variable<String>(englishNameTranslation);
    map['revelation_type'] = Variable<String>(revelationType);
    map['number_of_ayahs'] = Variable<int>(numberOfAyahs);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      number: Value(number),
      name: Value(name),
      englishName: Value(englishName),
      englishNameTranslation: Value(englishNameTranslation),
      revelationType: Value(revelationType),
      numberOfAyahs: Value(numberOfAyahs),
    );
  }

  factory SurahsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurahsData(
      number: serializer.fromJson<int>(json['number']),
      name: serializer.fromJson<String>(json['name']),
      englishName: serializer.fromJson<String>(json['englishName']),
      englishNameTranslation:
          serializer.fromJson<String>(json['englishNameTranslation']),
      revelationType: serializer.fromJson<String>(json['revelationType']),
      numberOfAyahs: serializer.fromJson<int>(json['numberOfAyahs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<int>(number),
      'name': serializer.toJson<String>(name),
      'englishName': serializer.toJson<String>(englishName),
      'englishNameTranslation':
          serializer.toJson<String>(englishNameTranslation),
      'revelationType': serializer.toJson<String>(revelationType),
      'numberOfAyahs': serializer.toJson<int>(numberOfAyahs),
    };
  }

  SurahsData copyWith(
          {int? number,
          String? name,
          String? englishName,
          String? englishNameTranslation,
          String? revelationType,
          int? numberOfAyahs}) =>
      SurahsData(
        number: number ?? this.number,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
        englishNameTranslation:
            englishNameTranslation ?? this.englishNameTranslation,
        revelationType: revelationType ?? this.revelationType,
        numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
      );
  SurahsData copyWithCompanion(SurahsCompanion data) {
    return SurahsData(
      number: data.number.present ? data.number.value : this.number,
      name: data.name.present ? data.name.value : this.name,
      englishName:
          data.englishName.present ? data.englishName.value : this.englishName,
      englishNameTranslation: data.englishNameTranslation.present
          ? data.englishNameTranslation.value
          : this.englishNameTranslation,
      revelationType: data.revelationType.present
          ? data.revelationType.value
          : this.revelationType,
      numberOfAyahs: data.numberOfAyahs.present
          ? data.numberOfAyahs.value
          : this.numberOfAyahs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahsData(')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('englishName: $englishName, ')
          ..write('englishNameTranslation: $englishNameTranslation, ')
          ..write('revelationType: $revelationType, ')
          ..write('numberOfAyahs: $numberOfAyahs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(number, name, englishName,
      englishNameTranslation, revelationType, numberOfAyahs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahsData &&
          other.number == this.number &&
          other.name == this.name &&
          other.englishName == this.englishName &&
          other.englishNameTranslation == this.englishNameTranslation &&
          other.revelationType == this.revelationType &&
          other.numberOfAyahs == this.numberOfAyahs);
}

class SurahsCompanion extends UpdateCompanion<SurahsData> {
  final Value<int> number;
  final Value<String> name;
  final Value<String> englishName;
  final Value<String> englishNameTranslation;
  final Value<String> revelationType;
  final Value<int> numberOfAyahs;
  final Value<int> rowid;
  const SurahsCompanion({
    this.number = const Value.absent(),
    this.name = const Value.absent(),
    this.englishName = const Value.absent(),
    this.englishNameTranslation = const Value.absent(),
    this.revelationType = const Value.absent(),
    this.numberOfAyahs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SurahsCompanion.insert({
    required int number,
    required String name,
    required String englishName,
    required String englishNameTranslation,
    required String revelationType,
    required int numberOfAyahs,
    this.rowid = const Value.absent(),
  })  : number = Value(number),
        name = Value(name),
        englishName = Value(englishName),
        englishNameTranslation = Value(englishNameTranslation),
        revelationType = Value(revelationType),
        numberOfAyahs = Value(numberOfAyahs);
  static Insertable<SurahsData> custom({
    Expression<int>? number,
    Expression<String>? name,
    Expression<String>? englishName,
    Expression<String>? englishNameTranslation,
    Expression<String>? revelationType,
    Expression<int>? numberOfAyahs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (name != null) 'name': name,
      if (englishName != null) 'english_name': englishName,
      if (englishNameTranslation != null)
        'english_name_translation': englishNameTranslation,
      if (revelationType != null) 'revelation_type': revelationType,
      if (numberOfAyahs != null) 'number_of_ayahs': numberOfAyahs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SurahsCompanion copyWith(
      {Value<int>? number,
      Value<String>? name,
      Value<String>? englishName,
      Value<String>? englishNameTranslation,
      Value<String>? revelationType,
      Value<int>? numberOfAyahs,
      Value<int>? rowid}) {
    return SurahsCompanion(
      number: number ?? this.number,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      englishNameTranslation:
          englishNameTranslation ?? this.englishNameTranslation,
      revelationType: revelationType ?? this.revelationType,
      numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (englishName.present) {
      map['english_name'] = Variable<String>(englishName.value);
    }
    if (englishNameTranslation.present) {
      map['english_name_translation'] =
          Variable<String>(englishNameTranslation.value);
    }
    if (revelationType.present) {
      map['revelation_type'] = Variable<String>(revelationType.value);
    }
    if (numberOfAyahs.present) {
      map['number_of_ayahs'] = Variable<int>(numberOfAyahs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('number: $number, ')
          ..write('name: $name, ')
          ..write('englishName: $englishName, ')
          ..write('englishNameTranslation: $englishNameTranslation, ')
          ..write('revelationType: $revelationType, ')
          ..write('numberOfAyahs: $numberOfAyahs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, Ayah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberInSurahMeta =
      const VerificationMeta('numberInSurah');
  @override
  late final GeneratedColumn<int> numberInSurah = GeneratedColumn<int>(
      'number_in_surah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tajweedTextMeta =
      const VerificationMeta('tajweedText');
  @override
  late final GeneratedColumn<String> tajweedText = GeneratedColumn<String>(
      'tajweed_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _juzMeta = const VerificationMeta('juz');
  @override
  late final GeneratedColumn<int> juz = GeneratedColumn<int>(
      'juz', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _manzilMeta = const VerificationMeta('manzil');
  @override
  late final GeneratedColumn<int> manzil = GeneratedColumn<int>(
      'manzil', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rukuMeta = const VerificationMeta('ruku');
  @override
  late final GeneratedColumn<int> ruku = GeneratedColumn<int>(
      'ruku', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hizbQuarterMeta =
      const VerificationMeta('hizbQuarter');
  @override
  late final GeneratedColumn<int> hizbQuarter = GeneratedColumn<int>(
      'hizb_quarter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        surahNumber,
        numberInSurah,
        textContent,
        tajweedText,
        juz,
        manzil,
        page,
        ruku,
        hizbQuarter
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(Insertable<Ayah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('number_in_surah')) {
      context.handle(
          _numberInSurahMeta,
          numberInSurah.isAcceptableOrUnknown(
              data['number_in_surah']!, _numberInSurahMeta));
    } else if (isInserting) {
      context.missing(_numberInSurahMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['text_content']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('tajweed_text')) {
      context.handle(
          _tajweedTextMeta,
          tajweedText.isAcceptableOrUnknown(
              data['tajweed_text']!, _tajweedTextMeta));
    }
    if (data.containsKey('juz')) {
      context.handle(
          _juzMeta, juz.isAcceptableOrUnknown(data['juz']!, _juzMeta));
    } else if (isInserting) {
      context.missing(_juzMeta);
    }
    if (data.containsKey('manzil')) {
      context.handle(_manzilMeta,
          manzil.isAcceptableOrUnknown(data['manzil']!, _manzilMeta));
    } else if (isInserting) {
      context.missing(_manzilMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('ruku')) {
      context.handle(
          _rukuMeta, ruku.isAcceptableOrUnknown(data['ruku']!, _rukuMeta));
    } else if (isInserting) {
      context.missing(_rukuMeta);
    }
    if (data.containsKey('hizb_quarter')) {
      context.handle(
          _hizbQuarterMeta,
          hizbQuarter.isAcceptableOrUnknown(
              data['hizb_quarter']!, _hizbQuarterMeta));
    } else if (isInserting) {
      context.missing(_hizbQuarterMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ayah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ayah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      numberInSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_in_surah'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_content'])!,
      tajweedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tajweed_text']),
      juz: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}juz'])!,
      manzil: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}manzil'])!,
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page'])!,
      ruku: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ruku'])!,
      hizbQuarter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hizb_quarter'])!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class Ayah extends DataClass implements Insertable<Ayah> {
  final int id;
  final int surahNumber;
  final int numberInSurah;
  final String textContent;
  final String? tajweedText;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  const Ayah(
      {required this.id,
      required this.surahNumber,
      required this.numberInSurah,
      required this.textContent,
      this.tajweedText,
      required this.juz,
      required this.manzil,
      required this.page,
      required this.ruku,
      required this.hizbQuarter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['number_in_surah'] = Variable<int>(numberInSurah);
    map['text_content'] = Variable<String>(textContent);
    if (!nullToAbsent || tajweedText != null) {
      map['tajweed_text'] = Variable<String>(tajweedText);
    }
    map['juz'] = Variable<int>(juz);
    map['manzil'] = Variable<int>(manzil);
    map['page'] = Variable<int>(page);
    map['ruku'] = Variable<int>(ruku);
    map['hizb_quarter'] = Variable<int>(hizbQuarter);
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      numberInSurah: Value(numberInSurah),
      textContent: Value(textContent),
      tajweedText: tajweedText == null && nullToAbsent
          ? const Value.absent()
          : Value(tajweedText),
      juz: Value(juz),
      manzil: Value(manzil),
      page: Value(page),
      ruku: Value(ruku),
      hizbQuarter: Value(hizbQuarter),
    );
  }

  factory Ayah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ayah(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      numberInSurah: serializer.fromJson<int>(json['numberInSurah']),
      textContent: serializer.fromJson<String>(json['textContent']),
      tajweedText: serializer.fromJson<String?>(json['tajweedText']),
      juz: serializer.fromJson<int>(json['juz']),
      manzil: serializer.fromJson<int>(json['manzil']),
      page: serializer.fromJson<int>(json['page']),
      ruku: serializer.fromJson<int>(json['ruku']),
      hizbQuarter: serializer.fromJson<int>(json['hizbQuarter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'numberInSurah': serializer.toJson<int>(numberInSurah),
      'textContent': serializer.toJson<String>(textContent),
      'tajweedText': serializer.toJson<String?>(tajweedText),
      'juz': serializer.toJson<int>(juz),
      'manzil': serializer.toJson<int>(manzil),
      'page': serializer.toJson<int>(page),
      'ruku': serializer.toJson<int>(ruku),
      'hizbQuarter': serializer.toJson<int>(hizbQuarter),
    };
  }

  Ayah copyWith(
          {int? id,
          int? surahNumber,
          int? numberInSurah,
          String? textContent,
          Value<String?> tajweedText = const Value.absent(),
          int? juz,
          int? manzil,
          int? page,
          int? ruku,
          int? hizbQuarter}) =>
      Ayah(
        id: id ?? this.id,
        surahNumber: surahNumber ?? this.surahNumber,
        numberInSurah: numberInSurah ?? this.numberInSurah,
        textContent: textContent ?? this.textContent,
        tajweedText: tajweedText.present ? tajweedText.value : this.tajweedText,
        juz: juz ?? this.juz,
        manzil: manzil ?? this.manzil,
        page: page ?? this.page,
        ruku: ruku ?? this.ruku,
        hizbQuarter: hizbQuarter ?? this.hizbQuarter,
      );
  Ayah copyWithCompanion(AyahsCompanion data) {
    return Ayah(
      id: data.id.present ? data.id.value : this.id,
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      numberInSurah: data.numberInSurah.present
          ? data.numberInSurah.value
          : this.numberInSurah,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      tajweedText:
          data.tajweedText.present ? data.tajweedText.value : this.tajweedText,
      juz: data.juz.present ? data.juz.value : this.juz,
      manzil: data.manzil.present ? data.manzil.value : this.manzil,
      page: data.page.present ? data.page.value : this.page,
      ruku: data.ruku.present ? data.ruku.value : this.ruku,
      hizbQuarter:
          data.hizbQuarter.present ? data.hizbQuarter.value : this.hizbQuarter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ayah(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('textContent: $textContent, ')
          ..write('tajweedText: $tajweedText, ')
          ..write('juz: $juz, ')
          ..write('manzil: $manzil, ')
          ..write('page: $page, ')
          ..write('ruku: $ruku, ')
          ..write('hizbQuarter: $hizbQuarter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNumber, numberInSurah, textContent,
      tajweedText, juz, manzil, page, ruku, hizbQuarter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ayah &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.numberInSurah == this.numberInSurah &&
          other.textContent == this.textContent &&
          other.tajweedText == this.tajweedText &&
          other.juz == this.juz &&
          other.manzil == this.manzil &&
          other.page == this.page &&
          other.ruku == this.ruku &&
          other.hizbQuarter == this.hizbQuarter);
}

class AyahsCompanion extends UpdateCompanion<Ayah> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> numberInSurah;
  final Value<String> textContent;
  final Value<String?> tajweedText;
  final Value<int> juz;
  final Value<int> manzil;
  final Value<int> page;
  final Value<int> ruku;
  final Value<int> hizbQuarter;
  const AyahsCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.numberInSurah = const Value.absent(),
    this.textContent = const Value.absent(),
    this.tajweedText = const Value.absent(),
    this.juz = const Value.absent(),
    this.manzil = const Value.absent(),
    this.page = const Value.absent(),
    this.ruku = const Value.absent(),
    this.hizbQuarter = const Value.absent(),
  });
  AyahsCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int numberInSurah,
    required String textContent,
    this.tajweedText = const Value.absent(),
    required int juz,
    required int manzil,
    required int page,
    required int ruku,
    required int hizbQuarter,
  })  : surahNumber = Value(surahNumber),
        numberInSurah = Value(numberInSurah),
        textContent = Value(textContent),
        juz = Value(juz),
        manzil = Value(manzil),
        page = Value(page),
        ruku = Value(ruku),
        hizbQuarter = Value(hizbQuarter);
  static Insertable<Ayah> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? numberInSurah,
    Expression<String>? textContent,
    Expression<String>? tajweedText,
    Expression<int>? juz,
    Expression<int>? manzil,
    Expression<int>? page,
    Expression<int>? ruku,
    Expression<int>? hizbQuarter,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (numberInSurah != null) 'number_in_surah': numberInSurah,
      if (textContent != null) 'text_content': textContent,
      if (tajweedText != null) 'tajweed_text': tajweedText,
      if (juz != null) 'juz': juz,
      if (manzil != null) 'manzil': manzil,
      if (page != null) 'page': page,
      if (ruku != null) 'ruku': ruku,
      if (hizbQuarter != null) 'hizb_quarter': hizbQuarter,
    });
  }

  AyahsCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNumber,
      Value<int>? numberInSurah,
      Value<String>? textContent,
      Value<String?>? tajweedText,
      Value<int>? juz,
      Value<int>? manzil,
      Value<int>? page,
      Value<int>? ruku,
      Value<int>? hizbQuarter}) {
    return AyahsCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      numberInSurah: numberInSurah ?? this.numberInSurah,
      textContent: textContent ?? this.textContent,
      tajweedText: tajweedText ?? this.tajweedText,
      juz: juz ?? this.juz,
      manzil: manzil ?? this.manzil,
      page: page ?? this.page,
      ruku: ruku ?? this.ruku,
      hizbQuarter: hizbQuarter ?? this.hizbQuarter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (numberInSurah.present) {
      map['number_in_surah'] = Variable<int>(numberInSurah.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (tajweedText.present) {
      map['tajweed_text'] = Variable<String>(tajweedText.value);
    }
    if (juz.present) {
      map['juz'] = Variable<int>(juz.value);
    }
    if (manzil.present) {
      map['manzil'] = Variable<int>(manzil.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (ruku.present) {
      map['ruku'] = Variable<int>(ruku.value);
    }
    if (hizbQuarter.present) {
      map['hizb_quarter'] = Variable<int>(hizbQuarter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('textContent: $textContent, ')
          ..write('tajweedText: $tajweedText, ')
          ..write('juz: $juz, ')
          ..write('manzil: $manzil, ')
          ..write('page: $page, ')
          ..write('ruku: $ruku, ')
          ..write('hizbQuarter: $hizbQuarter')
          ..write(')'))
        .toString();
  }
}

class $TranslationsTable extends Translations
    with TableInfo<$TranslationsTable, Translation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberInSurahMeta =
      const VerificationMeta('numberInSurah');
  @override
  late final GeneratedColumn<int> numberInSurah = GeneratedColumn<int>(
      'number_in_surah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _editionMeta =
      const VerificationMeta('edition');
  @override
  late final GeneratedColumn<String> edition = GeneratedColumn<String>(
      'edition', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, surahNumber, numberInSurah, edition, textContent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations';
  @override
  VerificationContext validateIntegrity(Insertable<Translation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('number_in_surah')) {
      context.handle(
          _numberInSurahMeta,
          numberInSurah.isAcceptableOrUnknown(
              data['number_in_surah']!, _numberInSurahMeta));
    } else if (isInserting) {
      context.missing(_numberInSurahMeta);
    }
    if (data.containsKey('edition')) {
      context.handle(_editionMeta,
          edition.isAcceptableOrUnknown(data['edition']!, _editionMeta));
    } else if (isInserting) {
      context.missing(_editionMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['text_content']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Translation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Translation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      numberInSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_in_surah'])!,
      edition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}edition'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_content'])!,
    );
  }

  @override
  $TranslationsTable createAlias(String alias) {
    return $TranslationsTable(attachedDatabase, alias);
  }
}

class Translation extends DataClass implements Insertable<Translation> {
  final int id;
  final int surahNumber;
  final int numberInSurah;
  final String edition;
  final String textContent;
  const Translation(
      {required this.id,
      required this.surahNumber,
      required this.numberInSurah,
      required this.edition,
      required this.textContent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['number_in_surah'] = Variable<int>(numberInSurah);
    map['edition'] = Variable<String>(edition);
    map['text_content'] = Variable<String>(textContent);
    return map;
  }

  TranslationsCompanion toCompanion(bool nullToAbsent) {
    return TranslationsCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      numberInSurah: Value(numberInSurah),
      edition: Value(edition),
      textContent: Value(textContent),
    );
  }

  factory Translation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translation(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      numberInSurah: serializer.fromJson<int>(json['numberInSurah']),
      edition: serializer.fromJson<String>(json['edition']),
      textContent: serializer.fromJson<String>(json['textContent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'numberInSurah': serializer.toJson<int>(numberInSurah),
      'edition': serializer.toJson<String>(edition),
      'textContent': serializer.toJson<String>(textContent),
    };
  }

  Translation copyWith(
          {int? id,
          int? surahNumber,
          int? numberInSurah,
          String? edition,
          String? textContent}) =>
      Translation(
        id: id ?? this.id,
        surahNumber: surahNumber ?? this.surahNumber,
        numberInSurah: numberInSurah ?? this.numberInSurah,
        edition: edition ?? this.edition,
        textContent: textContent ?? this.textContent,
      );
  Translation copyWithCompanion(TranslationsCompanion data) {
    return Translation(
      id: data.id.present ? data.id.value : this.id,
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      numberInSurah: data.numberInSurah.present
          ? data.numberInSurah.value
          : this.numberInSurah,
      edition: data.edition.present ? data.edition.value : this.edition,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Translation(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('edition: $edition, ')
          ..write('textContent: $textContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahNumber, numberInSurah, edition, textContent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translation &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.numberInSurah == this.numberInSurah &&
          other.edition == this.edition &&
          other.textContent == this.textContent);
}

class TranslationsCompanion extends UpdateCompanion<Translation> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> numberInSurah;
  final Value<String> edition;
  final Value<String> textContent;
  const TranslationsCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.numberInSurah = const Value.absent(),
    this.edition = const Value.absent(),
    this.textContent = const Value.absent(),
  });
  TranslationsCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int numberInSurah,
    required String edition,
    required String textContent,
  })  : surahNumber = Value(surahNumber),
        numberInSurah = Value(numberInSurah),
        edition = Value(edition),
        textContent = Value(textContent);
  static Insertable<Translation> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? numberInSurah,
    Expression<String>? edition,
    Expression<String>? textContent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (numberInSurah != null) 'number_in_surah': numberInSurah,
      if (edition != null) 'edition': edition,
      if (textContent != null) 'text_content': textContent,
    });
  }

  TranslationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNumber,
      Value<int>? numberInSurah,
      Value<String>? edition,
      Value<String>? textContent}) {
    return TranslationsCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      numberInSurah: numberInSurah ?? this.numberInSurah,
      edition: edition ?? this.edition,
      textContent: textContent ?? this.textContent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (numberInSurah.present) {
      map['number_in_surah'] = Variable<int>(numberInSurah.value);
    }
    if (edition.present) {
      map['edition'] = Variable<String>(edition.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('edition: $edition, ')
          ..write('textContent: $textContent')
          ..write(')'))
        .toString();
  }
}

class $WordTranslationsTable extends WordTranslations
    with TableInfo<$WordTranslationsTable, WordTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberInSurahMeta =
      const VerificationMeta('numberInSurah');
  @override
  late final GeneratedColumn<int> numberInSurah = GeneratedColumn<int>(
      'number_in_surah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wordNumberMeta =
      const VerificationMeta('wordNumber');
  @override
  late final GeneratedColumn<int> wordNumber = GeneratedColumn<int>(
      'word_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _editionMeta =
      const VerificationMeta('edition');
  @override
  late final GeneratedColumn<String> edition = GeneratedColumn<String>(
      'edition', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _arabicTextMeta =
      const VerificationMeta('arabicText');
  @override
  late final GeneratedColumn<String> arabicText = GeneratedColumn<String>(
      'arabic_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translationMeta =
      const VerificationMeta('translation');
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
      'translation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transliterationMeta =
      const VerificationMeta('transliteration');
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
      'transliteration', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localAudioPathMeta =
      const VerificationMeta('localAudioPath');
  @override
  late final GeneratedColumn<String> localAudioPath = GeneratedColumn<String>(
      'local_audio_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        surahNumber,
        numberInSurah,
        wordNumber,
        edition,
        arabicText,
        translation,
        transliteration,
        audioUrl,
        localAudioPath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_translations';
  @override
  VerificationContext validateIntegrity(Insertable<WordTranslation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('number_in_surah')) {
      context.handle(
          _numberInSurahMeta,
          numberInSurah.isAcceptableOrUnknown(
              data['number_in_surah']!, _numberInSurahMeta));
    } else if (isInserting) {
      context.missing(_numberInSurahMeta);
    }
    if (data.containsKey('word_number')) {
      context.handle(
          _wordNumberMeta,
          wordNumber.isAcceptableOrUnknown(
              data['word_number']!, _wordNumberMeta));
    } else if (isInserting) {
      context.missing(_wordNumberMeta);
    }
    if (data.containsKey('edition')) {
      context.handle(_editionMeta,
          edition.isAcceptableOrUnknown(data['edition']!, _editionMeta));
    } else if (isInserting) {
      context.missing(_editionMeta);
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
          _arabicTextMeta,
          arabicText.isAcceptableOrUnknown(
              data['arabic_text']!, _arabicTextMeta));
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
          _translationMeta,
          translation.isAcceptableOrUnknown(
              data['translation']!, _translationMeta));
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('transliteration')) {
      context.handle(
          _transliterationMeta,
          transliteration.isAcceptableOrUnknown(
              data['transliteration']!, _transliterationMeta));
    } else if (isInserting) {
      context.missing(_transliterationMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    }
    if (data.containsKey('local_audio_path')) {
      context.handle(
          _localAudioPathMeta,
          localAudioPath.isAcceptableOrUnknown(
              data['local_audio_path']!, _localAudioPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordTranslation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      numberInSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_in_surah'])!,
      wordNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}word_number'])!,
      edition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}edition'])!,
      arabicText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arabic_text'])!,
      translation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation'])!,
      transliteration: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transliteration'])!,
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url']),
      localAudioPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_audio_path']),
    );
  }

  @override
  $WordTranslationsTable createAlias(String alias) {
    return $WordTranslationsTable(attachedDatabase, alias);
  }
}

class WordTranslation extends DataClass implements Insertable<WordTranslation> {
  final int id;
  final int surahNumber;
  final int numberInSurah;
  final int wordNumber;
  final String edition;
  final String arabicText;
  final String translation;
  final String transliteration;
  final String? audioUrl;
  final String? localAudioPath;
  const WordTranslation(
      {required this.id,
      required this.surahNumber,
      required this.numberInSurah,
      required this.wordNumber,
      required this.edition,
      required this.arabicText,
      required this.translation,
      required this.transliteration,
      this.audioUrl,
      this.localAudioPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['number_in_surah'] = Variable<int>(numberInSurah);
    map['word_number'] = Variable<int>(wordNumber);
    map['edition'] = Variable<String>(edition);
    map['arabic_text'] = Variable<String>(arabicText);
    map['translation'] = Variable<String>(translation);
    map['transliteration'] = Variable<String>(transliteration);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || localAudioPath != null) {
      map['local_audio_path'] = Variable<String>(localAudioPath);
    }
    return map;
  }

  WordTranslationsCompanion toCompanion(bool nullToAbsent) {
    return WordTranslationsCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      numberInSurah: Value(numberInSurah),
      wordNumber: Value(wordNumber),
      edition: Value(edition),
      arabicText: Value(arabicText),
      translation: Value(translation),
      transliteration: Value(transliteration),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      localAudioPath: localAudioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localAudioPath),
    );
  }

  factory WordTranslation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordTranslation(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      numberInSurah: serializer.fromJson<int>(json['numberInSurah']),
      wordNumber: serializer.fromJson<int>(json['wordNumber']),
      edition: serializer.fromJson<String>(json['edition']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      translation: serializer.fromJson<String>(json['translation']),
      transliteration: serializer.fromJson<String>(json['transliteration']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      localAudioPath: serializer.fromJson<String?>(json['localAudioPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'numberInSurah': serializer.toJson<int>(numberInSurah),
      'wordNumber': serializer.toJson<int>(wordNumber),
      'edition': serializer.toJson<String>(edition),
      'arabicText': serializer.toJson<String>(arabicText),
      'translation': serializer.toJson<String>(translation),
      'transliteration': serializer.toJson<String>(transliteration),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'localAudioPath': serializer.toJson<String?>(localAudioPath),
    };
  }

  WordTranslation copyWith(
          {int? id,
          int? surahNumber,
          int? numberInSurah,
          int? wordNumber,
          String? edition,
          String? arabicText,
          String? translation,
          String? transliteration,
          Value<String?> audioUrl = const Value.absent(),
          Value<String?> localAudioPath = const Value.absent()}) =>
      WordTranslation(
        id: id ?? this.id,
        surahNumber: surahNumber ?? this.surahNumber,
        numberInSurah: numberInSurah ?? this.numberInSurah,
        wordNumber: wordNumber ?? this.wordNumber,
        edition: edition ?? this.edition,
        arabicText: arabicText ?? this.arabicText,
        translation: translation ?? this.translation,
        transliteration: transliteration ?? this.transliteration,
        audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
        localAudioPath:
            localAudioPath.present ? localAudioPath.value : this.localAudioPath,
      );
  WordTranslation copyWithCompanion(WordTranslationsCompanion data) {
    return WordTranslation(
      id: data.id.present ? data.id.value : this.id,
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      numberInSurah: data.numberInSurah.present
          ? data.numberInSurah.value
          : this.numberInSurah,
      wordNumber:
          data.wordNumber.present ? data.wordNumber.value : this.wordNumber,
      edition: data.edition.present ? data.edition.value : this.edition,
      arabicText:
          data.arabicText.present ? data.arabicText.value : this.arabicText,
      translation:
          data.translation.present ? data.translation.value : this.translation,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      localAudioPath: data.localAudioPath.present
          ? data.localAudioPath.value
          : this.localAudioPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordTranslation(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('wordNumber: $wordNumber, ')
          ..write('edition: $edition, ')
          ..write('arabicText: $arabicText, ')
          ..write('translation: $translation, ')
          ..write('transliteration: $transliteration, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('localAudioPath: $localAudioPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      surahNumber,
      numberInSurah,
      wordNumber,
      edition,
      arabicText,
      translation,
      transliteration,
      audioUrl,
      localAudioPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordTranslation &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.numberInSurah == this.numberInSurah &&
          other.wordNumber == this.wordNumber &&
          other.edition == this.edition &&
          other.arabicText == this.arabicText &&
          other.translation == this.translation &&
          other.transliteration == this.transliteration &&
          other.audioUrl == this.audioUrl &&
          other.localAudioPath == this.localAudioPath);
}

class WordTranslationsCompanion extends UpdateCompanion<WordTranslation> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> numberInSurah;
  final Value<int> wordNumber;
  final Value<String> edition;
  final Value<String> arabicText;
  final Value<String> translation;
  final Value<String> transliteration;
  final Value<String?> audioUrl;
  final Value<String?> localAudioPath;
  const WordTranslationsCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.numberInSurah = const Value.absent(),
    this.wordNumber = const Value.absent(),
    this.edition = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.translation = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.localAudioPath = const Value.absent(),
  });
  WordTranslationsCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int numberInSurah,
    required int wordNumber,
    required String edition,
    required String arabicText,
    required String translation,
    required String transliteration,
    this.audioUrl = const Value.absent(),
    this.localAudioPath = const Value.absent(),
  })  : surahNumber = Value(surahNumber),
        numberInSurah = Value(numberInSurah),
        wordNumber = Value(wordNumber),
        edition = Value(edition),
        arabicText = Value(arabicText),
        translation = Value(translation),
        transliteration = Value(transliteration);
  static Insertable<WordTranslation> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? numberInSurah,
    Expression<int>? wordNumber,
    Expression<String>? edition,
    Expression<String>? arabicText,
    Expression<String>? translation,
    Expression<String>? transliteration,
    Expression<String>? audioUrl,
    Expression<String>? localAudioPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (numberInSurah != null) 'number_in_surah': numberInSurah,
      if (wordNumber != null) 'word_number': wordNumber,
      if (edition != null) 'edition': edition,
      if (arabicText != null) 'arabic_text': arabicText,
      if (translation != null) 'translation': translation,
      if (transliteration != null) 'transliteration': transliteration,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (localAudioPath != null) 'local_audio_path': localAudioPath,
    });
  }

  WordTranslationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNumber,
      Value<int>? numberInSurah,
      Value<int>? wordNumber,
      Value<String>? edition,
      Value<String>? arabicText,
      Value<String>? translation,
      Value<String>? transliteration,
      Value<String?>? audioUrl,
      Value<String?>? localAudioPath}) {
    return WordTranslationsCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      numberInSurah: numberInSurah ?? this.numberInSurah,
      wordNumber: wordNumber ?? this.wordNumber,
      edition: edition ?? this.edition,
      arabicText: arabicText ?? this.arabicText,
      translation: translation ?? this.translation,
      transliteration: transliteration ?? this.transliteration,
      audioUrl: audioUrl ?? this.audioUrl,
      localAudioPath: localAudioPath ?? this.localAudioPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (numberInSurah.present) {
      map['number_in_surah'] = Variable<int>(numberInSurah.value);
    }
    if (wordNumber.present) {
      map['word_number'] = Variable<int>(wordNumber.value);
    }
    if (edition.present) {
      map['edition'] = Variable<String>(edition.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (localAudioPath.present) {
      map['local_audio_path'] = Variable<String>(localAudioPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('wordNumber: $wordNumber, ')
          ..write('edition: $edition, ')
          ..write('arabicText: $arabicText, ')
          ..write('translation: $translation, ')
          ..write('transliteration: $transliteration, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('localAudioPath: $localAudioPath')
          ..write(')'))
        .toString();
  }
}

class $DownloadedAudiosTable extends DownloadedAudios
    with TableInfo<$DownloadedAudiosTable, DownloadedAudio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedAudiosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberInSurahMeta =
      const VerificationMeta('numberInSurah');
  @override
  late final GeneratedColumn<int> numberInSurah = GeneratedColumn<int>(
      'number_in_surah', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reciterIdentifierMeta =
      const VerificationMeta('reciterIdentifier');
  @override
  late final GeneratedColumn<String> reciterIdentifier =
      GeneratedColumn<String>('reciter_identifier', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, surahNumber, numberInSurah, reciterIdentifier, localPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_audios';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadedAudio> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('number_in_surah')) {
      context.handle(
          _numberInSurahMeta,
          numberInSurah.isAcceptableOrUnknown(
              data['number_in_surah']!, _numberInSurahMeta));
    } else if (isInserting) {
      context.missing(_numberInSurahMeta);
    }
    if (data.containsKey('reciter_identifier')) {
      context.handle(
          _reciterIdentifierMeta,
          reciterIdentifier.isAcceptableOrUnknown(
              data['reciter_identifier']!, _reciterIdentifierMeta));
    } else if (isInserting) {
      context.missing(_reciterIdentifierMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadedAudio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedAudio(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      numberInSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_in_surah'])!,
      reciterIdentifier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reciter_identifier'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
    );
  }

  @override
  $DownloadedAudiosTable createAlias(String alias) {
    return $DownloadedAudiosTable(attachedDatabase, alias);
  }
}

class DownloadedAudio extends DataClass implements Insertable<DownloadedAudio> {
  final int id;
  final int surahNumber;
  final int numberInSurah;
  final String reciterIdentifier;
  final String localPath;
  const DownloadedAudio(
      {required this.id,
      required this.surahNumber,
      required this.numberInSurah,
      required this.reciterIdentifier,
      required this.localPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['number_in_surah'] = Variable<int>(numberInSurah);
    map['reciter_identifier'] = Variable<String>(reciterIdentifier);
    map['local_path'] = Variable<String>(localPath);
    return map;
  }

  DownloadedAudiosCompanion toCompanion(bool nullToAbsent) {
    return DownloadedAudiosCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      numberInSurah: Value(numberInSurah),
      reciterIdentifier: Value(reciterIdentifier),
      localPath: Value(localPath),
    );
  }

  factory DownloadedAudio.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedAudio(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      numberInSurah: serializer.fromJson<int>(json['numberInSurah']),
      reciterIdentifier: serializer.fromJson<String>(json['reciterIdentifier']),
      localPath: serializer.fromJson<String>(json['localPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'numberInSurah': serializer.toJson<int>(numberInSurah),
      'reciterIdentifier': serializer.toJson<String>(reciterIdentifier),
      'localPath': serializer.toJson<String>(localPath),
    };
  }

  DownloadedAudio copyWith(
          {int? id,
          int? surahNumber,
          int? numberInSurah,
          String? reciterIdentifier,
          String? localPath}) =>
      DownloadedAudio(
        id: id ?? this.id,
        surahNumber: surahNumber ?? this.surahNumber,
        numberInSurah: numberInSurah ?? this.numberInSurah,
        reciterIdentifier: reciterIdentifier ?? this.reciterIdentifier,
        localPath: localPath ?? this.localPath,
      );
  DownloadedAudio copyWithCompanion(DownloadedAudiosCompanion data) {
    return DownloadedAudio(
      id: data.id.present ? data.id.value : this.id,
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      numberInSurah: data.numberInSurah.present
          ? data.numberInSurah.value
          : this.numberInSurah,
      reciterIdentifier: data.reciterIdentifier.present
          ? data.reciterIdentifier.value
          : this.reciterIdentifier,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedAudio(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('reciterIdentifier: $reciterIdentifier, ')
          ..write('localPath: $localPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahNumber, numberInSurah, reciterIdentifier, localPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedAudio &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.numberInSurah == this.numberInSurah &&
          other.reciterIdentifier == this.reciterIdentifier &&
          other.localPath == this.localPath);
}

class DownloadedAudiosCompanion extends UpdateCompanion<DownloadedAudio> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> numberInSurah;
  final Value<String> reciterIdentifier;
  final Value<String> localPath;
  const DownloadedAudiosCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.numberInSurah = const Value.absent(),
    this.reciterIdentifier = const Value.absent(),
    this.localPath = const Value.absent(),
  });
  DownloadedAudiosCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int numberInSurah,
    required String reciterIdentifier,
    required String localPath,
  })  : surahNumber = Value(surahNumber),
        numberInSurah = Value(numberInSurah),
        reciterIdentifier = Value(reciterIdentifier),
        localPath = Value(localPath);
  static Insertable<DownloadedAudio> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? numberInSurah,
    Expression<String>? reciterIdentifier,
    Expression<String>? localPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (numberInSurah != null) 'number_in_surah': numberInSurah,
      if (reciterIdentifier != null) 'reciter_identifier': reciterIdentifier,
      if (localPath != null) 'local_path': localPath,
    });
  }

  DownloadedAudiosCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNumber,
      Value<int>? numberInSurah,
      Value<String>? reciterIdentifier,
      Value<String>? localPath}) {
    return DownloadedAudiosCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      numberInSurah: numberInSurah ?? this.numberInSurah,
      reciterIdentifier: reciterIdentifier ?? this.reciterIdentifier,
      localPath: localPath ?? this.localPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (numberInSurah.present) {
      map['number_in_surah'] = Variable<int>(numberInSurah.value);
    }
    if (reciterIdentifier.present) {
      map['reciter_identifier'] = Variable<String>(reciterIdentifier.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedAudiosCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSurah: $numberInSurah, ')
          ..write('reciterIdentifier: $reciterIdentifier, ')
          ..write('localPath: $localPath')
          ..write(')'))
        .toString();
  }
}

class $AiCacheTable extends AiCache
    with TableInfo<$AiCacheTable, AiCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberInSuraMeta =
      const VerificationMeta('numberInSura');
  @override
  late final GeneratedColumn<int> numberInSura = GeneratedColumn<int>(
      'number_in_sura', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _responseMeta =
      const VerificationMeta('response');
  @override
  late final GeneratedColumn<String> response = GeneratedColumn<String>(
      'response', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, surahNumber, numberInSura, question, response, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_cache';
  @override
  VerificationContext validateIntegrity(Insertable<AiCacheEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('number_in_sura')) {
      context.handle(
          _numberInSuraMeta,
          numberInSura.isAcceptableOrUnknown(
              data['number_in_sura']!, _numberInSuraMeta));
    } else if (isInserting) {
      context.missing(_numberInSuraMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('response')) {
      context.handle(_responseMeta,
          response.isAcceptableOrUnknown(data['response']!, _responseMeta));
    } else if (isInserting) {
      context.missing(_responseMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiCacheEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      numberInSura: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_in_sura'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      response: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $AiCacheTable createAlias(String alias) {
    return $AiCacheTable(attachedDatabase, alias);
  }
}

class AiCacheEntry extends DataClass implements Insertable<AiCacheEntry> {
  final int id;
  final int surahNumber;
  final int numberInSura;
  final String question;
  final String response;
  final DateTime timestamp;
  const AiCacheEntry(
      {required this.id,
      required this.surahNumber,
      required this.numberInSura,
      required this.question,
      required this.response,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['number_in_sura'] = Variable<int>(numberInSura);
    map['question'] = Variable<String>(question);
    map['response'] = Variable<String>(response);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  AiCacheCompanion toCompanion(bool nullToAbsent) {
    return AiCacheCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      numberInSura: Value(numberInSura),
      question: Value(question),
      response: Value(response),
      timestamp: Value(timestamp),
    );
  }

  factory AiCacheEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiCacheEntry(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      numberInSura: serializer.fromJson<int>(json['numberInSura']),
      question: serializer.fromJson<String>(json['question']),
      response: serializer.fromJson<String>(json['response']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'numberInSura': serializer.toJson<int>(numberInSura),
      'question': serializer.toJson<String>(question),
      'response': serializer.toJson<String>(response),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  AiCacheEntry copyWith(
          {int? id,
          int? surahNumber,
          int? numberInSura,
          String? question,
          String? response,
          DateTime? timestamp}) =>
      AiCacheEntry(
        id: id ?? this.id,
        surahNumber: surahNumber ?? this.surahNumber,
        numberInSura: numberInSura ?? this.numberInSura,
        question: question ?? this.question,
        response: response ?? this.response,
        timestamp: timestamp ?? this.timestamp,
      );
  AiCacheEntry copyWithCompanion(AiCacheCompanion data) {
    return AiCacheEntry(
      id: data.id.present ? data.id.value : this.id,
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      numberInSura: data.numberInSura.present
          ? data.numberInSura.value
          : this.numberInSura,
      question: data.question.present ? data.question.value : this.question,
      response: data.response.present ? data.response.value : this.response,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiCacheEntry(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSura: $numberInSura, ')
          ..write('question: $question, ')
          ..write('response: $response, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahNumber, numberInSura, question, response, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiCacheEntry &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.numberInSura == this.numberInSura &&
          other.question == this.question &&
          other.response == this.response &&
          other.timestamp == this.timestamp);
}

class AiCacheCompanion extends UpdateCompanion<AiCacheEntry> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> numberInSura;
  final Value<String> question;
  final Value<String> response;
  final Value<DateTime> timestamp;
  const AiCacheCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.numberInSura = const Value.absent(),
    this.question = const Value.absent(),
    this.response = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  AiCacheCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int numberInSura,
    required String question,
    required String response,
    this.timestamp = const Value.absent(),
  })  : surahNumber = Value(surahNumber),
        numberInSura = Value(numberInSura),
        question = Value(question),
        response = Value(response);
  static Insertable<AiCacheEntry> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? numberInSura,
    Expression<String>? question,
    Expression<String>? response,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (numberInSura != null) 'number_in_sura': numberInSura,
      if (question != null) 'question': question,
      if (response != null) 'response': response,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  AiCacheCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNumber,
      Value<int>? numberInSura,
      Value<String>? question,
      Value<String>? response,
      Value<DateTime>? timestamp}) {
    return AiCacheCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      numberInSura: numberInSura ?? this.numberInSura,
      question: question ?? this.question,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (numberInSura.present) {
      map['number_in_sura'] = Variable<int>(numberInSura.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (response.present) {
      map['response'] = Variable<String>(response.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiCacheCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('numberInSura: $numberInSura, ')
          ..write('question: $question, ')
          ..write('response: $response, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $CachedEditionsTable extends CachedEditions
    with TableInfo<$CachedEditionsTable, CachedEdition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedEditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _identifierMeta =
      const VerificationMeta('identifier');
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
      'identifier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _englishNameMeta =
      const VerificationMeta('englishName');
  @override
  late final GeneratedColumn<String> englishName = GeneratedColumn<String>(
      'english_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [identifier, language, name, englishName, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_editions';
  @override
  VerificationContext validateIntegrity(Insertable<CachedEdition> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('identifier')) {
      context.handle(
          _identifierMeta,
          identifier.isAcceptableOrUnknown(
              data['identifier']!, _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('english_name')) {
      context.handle(
          _englishNameMeta,
          englishName.isAcceptableOrUnknown(
              data['english_name']!, _englishNameMeta));
    } else if (isInserting) {
      context.missing(_englishNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {identifier};
  @override
  CachedEdition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedEdition(
      identifier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}identifier'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      englishName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}english_name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
    );
  }

  @override
  $CachedEditionsTable createAlias(String alias) {
    return $CachedEditionsTable(attachedDatabase, alias);
  }
}

class CachedEdition extends DataClass implements Insertable<CachedEdition> {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String type;
  const CachedEdition(
      {required this.identifier,
      required this.language,
      required this.name,
      required this.englishName,
      required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['identifier'] = Variable<String>(identifier);
    map['language'] = Variable<String>(language);
    map['name'] = Variable<String>(name);
    map['english_name'] = Variable<String>(englishName);
    map['type'] = Variable<String>(type);
    return map;
  }

  CachedEditionsCompanion toCompanion(bool nullToAbsent) {
    return CachedEditionsCompanion(
      identifier: Value(identifier),
      language: Value(language),
      name: Value(name),
      englishName: Value(englishName),
      type: Value(type),
    );
  }

  factory CachedEdition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedEdition(
      identifier: serializer.fromJson<String>(json['identifier']),
      language: serializer.fromJson<String>(json['language']),
      name: serializer.fromJson<String>(json['name']),
      englishName: serializer.fromJson<String>(json['englishName']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'identifier': serializer.toJson<String>(identifier),
      'language': serializer.toJson<String>(language),
      'name': serializer.toJson<String>(name),
      'englishName': serializer.toJson<String>(englishName),
      'type': serializer.toJson<String>(type),
    };
  }

  CachedEdition copyWith(
          {String? identifier,
          String? language,
          String? name,
          String? englishName,
          String? type}) =>
      CachedEdition(
        identifier: identifier ?? this.identifier,
        language: language ?? this.language,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
        type: type ?? this.type,
      );
  CachedEdition copyWithCompanion(CachedEditionsCompanion data) {
    return CachedEdition(
      identifier:
          data.identifier.present ? data.identifier.value : this.identifier,
      language: data.language.present ? data.language.value : this.language,
      name: data.name.present ? data.name.value : this.name,
      englishName:
          data.englishName.present ? data.englishName.value : this.englishName,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedEdition(')
          ..write('identifier: $identifier, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('englishName: $englishName, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(identifier, language, name, englishName, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedEdition &&
          other.identifier == this.identifier &&
          other.language == this.language &&
          other.name == this.name &&
          other.englishName == this.englishName &&
          other.type == this.type);
}

class CachedEditionsCompanion extends UpdateCompanion<CachedEdition> {
  final Value<String> identifier;
  final Value<String> language;
  final Value<String> name;
  final Value<String> englishName;
  final Value<String> type;
  final Value<int> rowid;
  const CachedEditionsCompanion({
    this.identifier = const Value.absent(),
    this.language = const Value.absent(),
    this.name = const Value.absent(),
    this.englishName = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedEditionsCompanion.insert({
    required String identifier,
    required String language,
    required String name,
    required String englishName,
    required String type,
    this.rowid = const Value.absent(),
  })  : identifier = Value(identifier),
        language = Value(language),
        name = Value(name),
        englishName = Value(englishName),
        type = Value(type);
  static Insertable<CachedEdition> custom({
    Expression<String>? identifier,
    Expression<String>? language,
    Expression<String>? name,
    Expression<String>? englishName,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (identifier != null) 'identifier': identifier,
      if (language != null) 'language': language,
      if (name != null) 'name': name,
      if (englishName != null) 'english_name': englishName,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedEditionsCompanion copyWith(
      {Value<String>? identifier,
      Value<String>? language,
      Value<String>? name,
      Value<String>? englishName,
      Value<String>? type,
      Value<int>? rowid}) {
    return CachedEditionsCompanion(
      identifier: identifier ?? this.identifier,
      language: language ?? this.language,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (englishName.present) {
      map['english_name'] = Variable<String>(englishName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedEditionsCompanion(')
          ..write('identifier: $identifier, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('englishName: $englishName, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedRecitersTable extends CachedReciters
    with TableInfo<$CachedRecitersTable, CachedReciter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedRecitersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _identifierMeta =
      const VerificationMeta('identifier');
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
      'identifier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _englishNameMeta =
      const VerificationMeta('englishName');
  @override
  late final GeneratedColumn<String> englishName = GeneratedColumn<String>(
      'english_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [identifier, language, name, englishName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_reciters';
  @override
  VerificationContext validateIntegrity(Insertable<CachedReciter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('identifier')) {
      context.handle(
          _identifierMeta,
          identifier.isAcceptableOrUnknown(
              data['identifier']!, _identifierMeta));
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('english_name')) {
      context.handle(
          _englishNameMeta,
          englishName.isAcceptableOrUnknown(
              data['english_name']!, _englishNameMeta));
    } else if (isInserting) {
      context.missing(_englishNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {identifier};
  @override
  CachedReciter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedReciter(
      identifier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}identifier'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      englishName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}english_name'])!,
    );
  }

  @override
  $CachedRecitersTable createAlias(String alias) {
    return $CachedRecitersTable(attachedDatabase, alias);
  }
}

class CachedReciter extends DataClass implements Insertable<CachedReciter> {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  const CachedReciter(
      {required this.identifier,
      required this.language,
      required this.name,
      required this.englishName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['identifier'] = Variable<String>(identifier);
    map['language'] = Variable<String>(language);
    map['name'] = Variable<String>(name);
    map['english_name'] = Variable<String>(englishName);
    return map;
  }

  CachedRecitersCompanion toCompanion(bool nullToAbsent) {
    return CachedRecitersCompanion(
      identifier: Value(identifier),
      language: Value(language),
      name: Value(name),
      englishName: Value(englishName),
    );
  }

  factory CachedReciter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedReciter(
      identifier: serializer.fromJson<String>(json['identifier']),
      language: serializer.fromJson<String>(json['language']),
      name: serializer.fromJson<String>(json['name']),
      englishName: serializer.fromJson<String>(json['englishName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'identifier': serializer.toJson<String>(identifier),
      'language': serializer.toJson<String>(language),
      'name': serializer.toJson<String>(name),
      'englishName': serializer.toJson<String>(englishName),
    };
  }

  CachedReciter copyWith(
          {String? identifier,
          String? language,
          String? name,
          String? englishName}) =>
      CachedReciter(
        identifier: identifier ?? this.identifier,
        language: language ?? this.language,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
      );
  CachedReciter copyWithCompanion(CachedRecitersCompanion data) {
    return CachedReciter(
      identifier:
          data.identifier.present ? data.identifier.value : this.identifier,
      language: data.language.present ? data.language.value : this.language,
      name: data.name.present ? data.name.value : this.name,
      englishName:
          data.englishName.present ? data.englishName.value : this.englishName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedReciter(')
          ..write('identifier: $identifier, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('englishName: $englishName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(identifier, language, name, englishName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedReciter &&
          other.identifier == this.identifier &&
          other.language == this.language &&
          other.name == this.name &&
          other.englishName == this.englishName);
}

class CachedRecitersCompanion extends UpdateCompanion<CachedReciter> {
  final Value<String> identifier;
  final Value<String> language;
  final Value<String> name;
  final Value<String> englishName;
  final Value<int> rowid;
  const CachedRecitersCompanion({
    this.identifier = const Value.absent(),
    this.language = const Value.absent(),
    this.name = const Value.absent(),
    this.englishName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedRecitersCompanion.insert({
    required String identifier,
    required String language,
    required String name,
    required String englishName,
    this.rowid = const Value.absent(),
  })  : identifier = Value(identifier),
        language = Value(language),
        name = Value(name),
        englishName = Value(englishName);
  static Insertable<CachedReciter> custom({
    Expression<String>? identifier,
    Expression<String>? language,
    Expression<String>? name,
    Expression<String>? englishName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (identifier != null) 'identifier': identifier,
      if (language != null) 'language': language,
      if (name != null) 'name': name,
      if (englishName != null) 'english_name': englishName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedRecitersCompanion copyWith(
      {Value<String>? identifier,
      Value<String>? language,
      Value<String>? name,
      Value<String>? englishName,
      Value<int>? rowid}) {
    return CachedRecitersCompanion(
      identifier: identifier ?? this.identifier,
      language: language ?? this.language,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (englishName.present) {
      map['english_name'] = Variable<String>(englishName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedRecitersCompanion(')
          ..write('identifier: $identifier, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('englishName: $englishName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LogsTable extends Logs with TableInfo<$LogsTable, LogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stackTraceMeta =
      const VerificationMeta('stackTrace');
  @override
  late final GeneratedColumn<String> stackTrace = GeneratedColumn<String>(
      'stack_trace', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, level, message, stackTrace, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logs';
  @override
  VerificationContext validateIntegrity(Insertable<LogEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('stack_trace')) {
      context.handle(
          _stackTraceMeta,
          stackTrace.isAcceptableOrUnknown(
              data['stack_trace']!, _stackTraceMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      stackTrace: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stack_trace']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $LogsTable createAlias(String alias) {
    return $LogsTable(attachedDatabase, alias);
  }
}

class LogEntry extends DataClass implements Insertable<LogEntry> {
  final int id;
  final String level;
  final String message;
  final String? stackTrace;
  final DateTime timestamp;
  const LogEntry(
      {required this.id,
      required this.level,
      required this.message,
      this.stackTrace,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || stackTrace != null) {
      map['stack_trace'] = Variable<String>(stackTrace);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  LogsCompanion toCompanion(bool nullToAbsent) {
    return LogsCompanion(
      id: Value(id),
      level: Value(level),
      message: Value(message),
      stackTrace: stackTrace == null && nullToAbsent
          ? const Value.absent()
          : Value(stackTrace),
      timestamp: Value(timestamp),
    );
  }

  factory LogEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogEntry(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      message: serializer.fromJson<String>(json['message']),
      stackTrace: serializer.fromJson<String?>(json['stackTrace']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'message': serializer.toJson<String>(message),
      'stackTrace': serializer.toJson<String?>(stackTrace),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  LogEntry copyWith(
          {int? id,
          String? level,
          String? message,
          Value<String?> stackTrace = const Value.absent(),
          DateTime? timestamp}) =>
      LogEntry(
        id: id ?? this.id,
        level: level ?? this.level,
        message: message ?? this.message,
        stackTrace: stackTrace.present ? stackTrace.value : this.stackTrace,
        timestamp: timestamp ?? this.timestamp,
      );
  LogEntry copyWithCompanion(LogsCompanion data) {
    return LogEntry(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      message: data.message.present ? data.message.value : this.message,
      stackTrace:
          data.stackTrace.present ? data.stackTrace.value : this.stackTrace,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogEntry(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, message, stackTrace, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogEntry &&
          other.id == this.id &&
          other.level == this.level &&
          other.message == this.message &&
          other.stackTrace == this.stackTrace &&
          other.timestamp == this.timestamp);
}

class LogsCompanion extends UpdateCompanion<LogEntry> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> message;
  final Value<String?> stackTrace;
  final Value<DateTime> timestamp;
  const LogsCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.stackTrace = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  LogsCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    required String message,
    this.stackTrace = const Value.absent(),
    this.timestamp = const Value.absent(),
  })  : level = Value(level),
        message = Value(message);
  static Insertable<LogEntry> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? message,
    Expression<String>? stackTrace,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (stackTrace != null) 'stack_trace': stackTrace,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  LogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? level,
      Value<String>? message,
      Value<String?>? stackTrace,
      Value<DateTime>? timestamp}) {
    return LogsCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      message: message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (stackTrace.present) {
      map['stack_trace'] = Variable<String>(stackTrace.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogsCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $TranslationsTable translations = $TranslationsTable(this);
  late final $WordTranslationsTable wordTranslations =
      $WordTranslationsTable(this);
  late final $DownloadedAudiosTable downloadedAudios =
      $DownloadedAudiosTable(this);
  late final $AiCacheTable aiCache = $AiCacheTable(this);
  late final $CachedEditionsTable cachedEditions = $CachedEditionsTable(this);
  late final $CachedRecitersTable cachedReciters = $CachedRecitersTable(this);
  late final $LogsTable logs = $LogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        surahs,
        ayahs,
        translations,
        wordTranslations,
        downloadedAudios,
        aiCache,
        cachedEditions,
        cachedReciters,
        logs
      ];
}

typedef $$SurahsTableCreateCompanionBuilder = SurahsCompanion Function({
  required int number,
  required String name,
  required String englishName,
  required String englishNameTranslation,
  required String revelationType,
  required int numberOfAyahs,
  Value<int> rowid,
});
typedef $$SurahsTableUpdateCompanionBuilder = SurahsCompanion Function({
  Value<int> number,
  Value<String> name,
  Value<String> englishName,
  Value<String> englishNameTranslation,
  Value<String> revelationType,
  Value<int> numberOfAyahs,
  Value<int> rowid,
});

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get englishNameTranslation => $composableBuilder(
      column: $table.englishNameTranslation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get revelationType => $composableBuilder(
      column: $table.revelationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberOfAyahs => $composableBuilder(
      column: $table.numberOfAyahs, builder: (column) => ColumnFilters(column));
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get englishNameTranslation => $composableBuilder(
      column: $table.englishNameTranslation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get revelationType => $composableBuilder(
      column: $table.revelationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberOfAyahs => $composableBuilder(
      column: $table.numberOfAyahs,
      builder: (column) => ColumnOrderings(column));
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => column);

  GeneratedColumn<String> get englishNameTranslation => $composableBuilder(
      column: $table.englishNameTranslation, builder: (column) => column);

  GeneratedColumn<String> get revelationType => $composableBuilder(
      column: $table.revelationType, builder: (column) => column);

  GeneratedColumn<int> get numberOfAyahs => $composableBuilder(
      column: $table.numberOfAyahs, builder: (column) => column);
}

class $$SurahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SurahsTable,
    SurahsData,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (SurahsData, BaseReferences<_$AppDatabase, $SurahsTable, SurahsData>),
    SurahsData,
    PrefetchHooks Function()> {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> number = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> englishName = const Value.absent(),
            Value<String> englishNameTranslation = const Value.absent(),
            Value<String> revelationType = const Value.absent(),
            Value<int> numberOfAyahs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SurahsCompanion(
            number: number,
            name: name,
            englishName: englishName,
            englishNameTranslation: englishNameTranslation,
            revelationType: revelationType,
            numberOfAyahs: numberOfAyahs,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int number,
            required String name,
            required String englishName,
            required String englishNameTranslation,
            required String revelationType,
            required int numberOfAyahs,
            Value<int> rowid = const Value.absent(),
          }) =>
              SurahsCompanion.insert(
            number: number,
            name: name,
            englishName: englishName,
            englishNameTranslation: englishNameTranslation,
            revelationType: revelationType,
            numberOfAyahs: numberOfAyahs,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SurahsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SurahsTable,
    SurahsData,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (SurahsData, BaseReferences<_$AppDatabase, $SurahsTable, SurahsData>),
    SurahsData,
    PrefetchHooks Function()>;
typedef $$AyahsTableCreateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  required int surahNumber,
  required int numberInSurah,
  required String textContent,
  Value<String?> tajweedText,
  required int juz,
  required int manzil,
  required int page,
  required int ruku,
  required int hizbQuarter,
});
typedef $$AyahsTableUpdateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  Value<int> surahNumber,
  Value<int> numberInSurah,
  Value<String> textContent,
  Value<String?> tajweedText,
  Value<int> juz,
  Value<int> manzil,
  Value<int> page,
  Value<int> ruku,
  Value<int> hizbQuarter,
});

class $$AyahsTableFilterComposer extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tajweedText => $composableBuilder(
      column: $table.tajweedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get juz => $composableBuilder(
      column: $table.juz, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get manzil => $composableBuilder(
      column: $table.manzil, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ruku => $composableBuilder(
      column: $table.ruku, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hizbQuarter => $composableBuilder(
      column: $table.hizbQuarter, builder: (column) => ColumnFilters(column));
}

class $$AyahsTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tajweedText => $composableBuilder(
      column: $table.tajweedText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get juz => $composableBuilder(
      column: $table.juz, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get manzil => $composableBuilder(
      column: $table.manzil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ruku => $composableBuilder(
      column: $table.ruku, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hizbQuarter => $composableBuilder(
      column: $table.hizbQuarter, builder: (column) => ColumnOrderings(column));
}

class $$AyahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => column);

  GeneratedColumn<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<String> get tajweedText => $composableBuilder(
      column: $table.tajweedText, builder: (column) => column);

  GeneratedColumn<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => column);

  GeneratedColumn<int> get manzil =>
      $composableBuilder(column: $table.manzil, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<int> get ruku =>
      $composableBuilder(column: $table.ruku, builder: (column) => column);

  GeneratedColumn<int> get hizbQuarter => $composableBuilder(
      column: $table.hizbQuarter, builder: (column) => column);
}

class $$AyahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AyahsTable,
    Ayah,
    $$AyahsTableFilterComposer,
    $$AyahsTableOrderingComposer,
    $$AyahsTableAnnotationComposer,
    $$AyahsTableCreateCompanionBuilder,
    $$AyahsTableUpdateCompanionBuilder,
    (Ayah, BaseReferences<_$AppDatabase, $AyahsTable, Ayah>),
    Ayah,
    PrefetchHooks Function()> {
  $$AyahsTableTableManager(_$AppDatabase db, $AyahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNumber = const Value.absent(),
            Value<int> numberInSurah = const Value.absent(),
            Value<String> textContent = const Value.absent(),
            Value<String?> tajweedText = const Value.absent(),
            Value<int> juz = const Value.absent(),
            Value<int> manzil = const Value.absent(),
            Value<int> page = const Value.absent(),
            Value<int> ruku = const Value.absent(),
            Value<int> hizbQuarter = const Value.absent(),
          }) =>
              AyahsCompanion(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            textContent: textContent,
            tajweedText: tajweedText,
            juz: juz,
            manzil: manzil,
            page: page,
            ruku: ruku,
            hizbQuarter: hizbQuarter,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNumber,
            required int numberInSurah,
            required String textContent,
            Value<String?> tajweedText = const Value.absent(),
            required int juz,
            required int manzil,
            required int page,
            required int ruku,
            required int hizbQuarter,
          }) =>
              AyahsCompanion.insert(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            textContent: textContent,
            tajweedText: tajweedText,
            juz: juz,
            manzil: manzil,
            page: page,
            ruku: ruku,
            hizbQuarter: hizbQuarter,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AyahsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AyahsTable,
    Ayah,
    $$AyahsTableFilterComposer,
    $$AyahsTableOrderingComposer,
    $$AyahsTableAnnotationComposer,
    $$AyahsTableCreateCompanionBuilder,
    $$AyahsTableUpdateCompanionBuilder,
    (Ayah, BaseReferences<_$AppDatabase, $AyahsTable, Ayah>),
    Ayah,
    PrefetchHooks Function()>;
typedef $$TranslationsTableCreateCompanionBuilder = TranslationsCompanion
    Function({
  Value<int> id,
  required int surahNumber,
  required int numberInSurah,
  required String edition,
  required String textContent,
});
typedef $$TranslationsTableUpdateCompanionBuilder = TranslationsCompanion
    Function({
  Value<int> id,
  Value<int> surahNumber,
  Value<int> numberInSurah,
  Value<String> edition,
  Value<String> textContent,
});

class $$TranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get edition => $composableBuilder(
      column: $table.edition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));
}

class $$TranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get edition => $composableBuilder(
      column: $table.edition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));
}

class $$TranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => column);

  GeneratedColumn<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => column);

  GeneratedColumn<String> get edition =>
      $composableBuilder(column: $table.edition, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);
}

class $$TranslationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranslationsTable,
    Translation,
    $$TranslationsTableFilterComposer,
    $$TranslationsTableOrderingComposer,
    $$TranslationsTableAnnotationComposer,
    $$TranslationsTableCreateCompanionBuilder,
    $$TranslationsTableUpdateCompanionBuilder,
    (
      Translation,
      BaseReferences<_$AppDatabase, $TranslationsTable, Translation>
    ),
    Translation,
    PrefetchHooks Function()> {
  $$TranslationsTableTableManager(_$AppDatabase db, $TranslationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNumber = const Value.absent(),
            Value<int> numberInSurah = const Value.absent(),
            Value<String> edition = const Value.absent(),
            Value<String> textContent = const Value.absent(),
          }) =>
              TranslationsCompanion(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            edition: edition,
            textContent: textContent,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNumber,
            required int numberInSurah,
            required String edition,
            required String textContent,
          }) =>
              TranslationsCompanion.insert(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            edition: edition,
            textContent: textContent,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranslationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranslationsTable,
    Translation,
    $$TranslationsTableFilterComposer,
    $$TranslationsTableOrderingComposer,
    $$TranslationsTableAnnotationComposer,
    $$TranslationsTableCreateCompanionBuilder,
    $$TranslationsTableUpdateCompanionBuilder,
    (
      Translation,
      BaseReferences<_$AppDatabase, $TranslationsTable, Translation>
    ),
    Translation,
    PrefetchHooks Function()>;
typedef $$WordTranslationsTableCreateCompanionBuilder
    = WordTranslationsCompanion Function({
  Value<int> id,
  required int surahNumber,
  required int numberInSurah,
  required int wordNumber,
  required String edition,
  required String arabicText,
  required String translation,
  required String transliteration,
  Value<String?> audioUrl,
  Value<String?> localAudioPath,
});
typedef $$WordTranslationsTableUpdateCompanionBuilder
    = WordTranslationsCompanion Function({
  Value<int> id,
  Value<int> surahNumber,
  Value<int> numberInSurah,
  Value<int> wordNumber,
  Value<String> edition,
  Value<String> arabicText,
  Value<String> translation,
  Value<String> transliteration,
  Value<String?> audioUrl,
  Value<String?> localAudioPath,
});

class $$WordTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $WordTranslationsTable> {
  $$WordTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordNumber => $composableBuilder(
      column: $table.wordNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get edition => $composableBuilder(
      column: $table.edition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arabicText => $composableBuilder(
      column: $table.arabicText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translation => $composableBuilder(
      column: $table.translation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transliteration => $composableBuilder(
      column: $table.transliteration,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localAudioPath => $composableBuilder(
      column: $table.localAudioPath,
      builder: (column) => ColumnFilters(column));
}

class $$WordTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordTranslationsTable> {
  $$WordTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordNumber => $composableBuilder(
      column: $table.wordNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get edition => $composableBuilder(
      column: $table.edition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arabicText => $composableBuilder(
      column: $table.arabicText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translation => $composableBuilder(
      column: $table.translation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transliteration => $composableBuilder(
      column: $table.transliteration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localAudioPath => $composableBuilder(
      column: $table.localAudioPath,
      builder: (column) => ColumnOrderings(column));
}

class $$WordTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordTranslationsTable> {
  $$WordTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => column);

  GeneratedColumn<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => column);

  GeneratedColumn<int> get wordNumber => $composableBuilder(
      column: $table.wordNumber, builder: (column) => column);

  GeneratedColumn<String> get edition =>
      $composableBuilder(column: $table.edition, builder: (column) => column);

  GeneratedColumn<String> get arabicText => $composableBuilder(
      column: $table.arabicText, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
      column: $table.translation, builder: (column) => column);

  GeneratedColumn<String> get transliteration => $composableBuilder(
      column: $table.transliteration, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get localAudioPath => $composableBuilder(
      column: $table.localAudioPath, builder: (column) => column);
}

class $$WordTranslationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WordTranslationsTable,
    WordTranslation,
    $$WordTranslationsTableFilterComposer,
    $$WordTranslationsTableOrderingComposer,
    $$WordTranslationsTableAnnotationComposer,
    $$WordTranslationsTableCreateCompanionBuilder,
    $$WordTranslationsTableUpdateCompanionBuilder,
    (
      WordTranslation,
      BaseReferences<_$AppDatabase, $WordTranslationsTable, WordTranslation>
    ),
    WordTranslation,
    PrefetchHooks Function()> {
  $$WordTranslationsTableTableManager(
      _$AppDatabase db, $WordTranslationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordTranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNumber = const Value.absent(),
            Value<int> numberInSurah = const Value.absent(),
            Value<int> wordNumber = const Value.absent(),
            Value<String> edition = const Value.absent(),
            Value<String> arabicText = const Value.absent(),
            Value<String> translation = const Value.absent(),
            Value<String> transliteration = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<String?> localAudioPath = const Value.absent(),
          }) =>
              WordTranslationsCompanion(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            wordNumber: wordNumber,
            edition: edition,
            arabicText: arabicText,
            translation: translation,
            transliteration: transliteration,
            audioUrl: audioUrl,
            localAudioPath: localAudioPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNumber,
            required int numberInSurah,
            required int wordNumber,
            required String edition,
            required String arabicText,
            required String translation,
            required String transliteration,
            Value<String?> audioUrl = const Value.absent(),
            Value<String?> localAudioPath = const Value.absent(),
          }) =>
              WordTranslationsCompanion.insert(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            wordNumber: wordNumber,
            edition: edition,
            arabicText: arabicText,
            translation: translation,
            transliteration: transliteration,
            audioUrl: audioUrl,
            localAudioPath: localAudioPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WordTranslationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WordTranslationsTable,
    WordTranslation,
    $$WordTranslationsTableFilterComposer,
    $$WordTranslationsTableOrderingComposer,
    $$WordTranslationsTableAnnotationComposer,
    $$WordTranslationsTableCreateCompanionBuilder,
    $$WordTranslationsTableUpdateCompanionBuilder,
    (
      WordTranslation,
      BaseReferences<_$AppDatabase, $WordTranslationsTable, WordTranslation>
    ),
    WordTranslation,
    PrefetchHooks Function()>;
typedef $$DownloadedAudiosTableCreateCompanionBuilder
    = DownloadedAudiosCompanion Function({
  Value<int> id,
  required int surahNumber,
  required int numberInSurah,
  required String reciterIdentifier,
  required String localPath,
});
typedef $$DownloadedAudiosTableUpdateCompanionBuilder
    = DownloadedAudiosCompanion Function({
  Value<int> id,
  Value<int> surahNumber,
  Value<int> numberInSurah,
  Value<String> reciterIdentifier,
  Value<String> localPath,
});

class $$DownloadedAudiosTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedAudiosTable> {
  $$DownloadedAudiosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reciterIdentifier => $composableBuilder(
      column: $table.reciterIdentifier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));
}

class $$DownloadedAudiosTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedAudiosTable> {
  $$DownloadedAudiosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reciterIdentifier => $composableBuilder(
      column: $table.reciterIdentifier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));
}

class $$DownloadedAudiosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedAudiosTable> {
  $$DownloadedAudiosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => column);

  GeneratedColumn<int> get numberInSurah => $composableBuilder(
      column: $table.numberInSurah, builder: (column) => column);

  GeneratedColumn<String> get reciterIdentifier => $composableBuilder(
      column: $table.reciterIdentifier, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);
}

class $$DownloadedAudiosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadedAudiosTable,
    DownloadedAudio,
    $$DownloadedAudiosTableFilterComposer,
    $$DownloadedAudiosTableOrderingComposer,
    $$DownloadedAudiosTableAnnotationComposer,
    $$DownloadedAudiosTableCreateCompanionBuilder,
    $$DownloadedAudiosTableUpdateCompanionBuilder,
    (
      DownloadedAudio,
      BaseReferences<_$AppDatabase, $DownloadedAudiosTable, DownloadedAudio>
    ),
    DownloadedAudio,
    PrefetchHooks Function()> {
  $$DownloadedAudiosTableTableManager(
      _$AppDatabase db, $DownloadedAudiosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedAudiosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedAudiosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedAudiosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNumber = const Value.absent(),
            Value<int> numberInSurah = const Value.absent(),
            Value<String> reciterIdentifier = const Value.absent(),
            Value<String> localPath = const Value.absent(),
          }) =>
              DownloadedAudiosCompanion(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            reciterIdentifier: reciterIdentifier,
            localPath: localPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNumber,
            required int numberInSurah,
            required String reciterIdentifier,
            required String localPath,
          }) =>
              DownloadedAudiosCompanion.insert(
            id: id,
            surahNumber: surahNumber,
            numberInSurah: numberInSurah,
            reciterIdentifier: reciterIdentifier,
            localPath: localPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadedAudiosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadedAudiosTable,
    DownloadedAudio,
    $$DownloadedAudiosTableFilterComposer,
    $$DownloadedAudiosTableOrderingComposer,
    $$DownloadedAudiosTableAnnotationComposer,
    $$DownloadedAudiosTableCreateCompanionBuilder,
    $$DownloadedAudiosTableUpdateCompanionBuilder,
    (
      DownloadedAudio,
      BaseReferences<_$AppDatabase, $DownloadedAudiosTable, DownloadedAudio>
    ),
    DownloadedAudio,
    PrefetchHooks Function()>;
typedef $$AiCacheTableCreateCompanionBuilder = AiCacheCompanion Function({
  Value<int> id,
  required int surahNumber,
  required int numberInSura,
  required String question,
  required String response,
  Value<DateTime> timestamp,
});
typedef $$AiCacheTableUpdateCompanionBuilder = AiCacheCompanion Function({
  Value<int> id,
  Value<int> surahNumber,
  Value<int> numberInSura,
  Value<String> question,
  Value<String> response,
  Value<DateTime> timestamp,
});

class $$AiCacheTableFilterComposer
    extends Composer<_$AppDatabase, $AiCacheTable> {
  $$AiCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberInSura => $composableBuilder(
      column: $table.numberInSura, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get response => $composableBuilder(
      column: $table.response, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$AiCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $AiCacheTable> {
  $$AiCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberInSura => $composableBuilder(
      column: $table.numberInSura,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get response => $composableBuilder(
      column: $table.response, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$AiCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiCacheTable> {
  $$AiCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
      column: $table.surahNumber, builder: (column) => column);

  GeneratedColumn<int> get numberInSura => $composableBuilder(
      column: $table.numberInSura, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get response =>
      $composableBuilder(column: $table.response, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$AiCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiCacheTable,
    AiCacheEntry,
    $$AiCacheTableFilterComposer,
    $$AiCacheTableOrderingComposer,
    $$AiCacheTableAnnotationComposer,
    $$AiCacheTableCreateCompanionBuilder,
    $$AiCacheTableUpdateCompanionBuilder,
    (AiCacheEntry, BaseReferences<_$AppDatabase, $AiCacheTable, AiCacheEntry>),
    AiCacheEntry,
    PrefetchHooks Function()> {
  $$AiCacheTableTableManager(_$AppDatabase db, $AiCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNumber = const Value.absent(),
            Value<int> numberInSura = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> response = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              AiCacheCompanion(
            id: id,
            surahNumber: surahNumber,
            numberInSura: numberInSura,
            question: question,
            response: response,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNumber,
            required int numberInSura,
            required String question,
            required String response,
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              AiCacheCompanion.insert(
            id: id,
            surahNumber: surahNumber,
            numberInSura: numberInSura,
            question: question,
            response: response,
            timestamp: timestamp,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AiCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AiCacheTable,
    AiCacheEntry,
    $$AiCacheTableFilterComposer,
    $$AiCacheTableOrderingComposer,
    $$AiCacheTableAnnotationComposer,
    $$AiCacheTableCreateCompanionBuilder,
    $$AiCacheTableUpdateCompanionBuilder,
    (AiCacheEntry, BaseReferences<_$AppDatabase, $AiCacheTable, AiCacheEntry>),
    AiCacheEntry,
    PrefetchHooks Function()>;
typedef $$CachedEditionsTableCreateCompanionBuilder = CachedEditionsCompanion
    Function({
  required String identifier,
  required String language,
  required String name,
  required String englishName,
  required String type,
  Value<int> rowid,
});
typedef $$CachedEditionsTableUpdateCompanionBuilder = CachedEditionsCompanion
    Function({
  Value<String> identifier,
  Value<String> language,
  Value<String> name,
  Value<String> englishName,
  Value<String> type,
  Value<int> rowid,
});

class $$CachedEditionsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedEditionsTable> {
  $$CachedEditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get identifier => $composableBuilder(
      column: $table.identifier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));
}

class $$CachedEditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedEditionsTable> {
  $$CachedEditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get identifier => $composableBuilder(
      column: $table.identifier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));
}

class $$CachedEditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedEditionsTable> {
  $$CachedEditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get identifier => $composableBuilder(
      column: $table.identifier, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$CachedEditionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedEditionsTable,
    CachedEdition,
    $$CachedEditionsTableFilterComposer,
    $$CachedEditionsTableOrderingComposer,
    $$CachedEditionsTableAnnotationComposer,
    $$CachedEditionsTableCreateCompanionBuilder,
    $$CachedEditionsTableUpdateCompanionBuilder,
    (
      CachedEdition,
      BaseReferences<_$AppDatabase, $CachedEditionsTable, CachedEdition>
    ),
    CachedEdition,
    PrefetchHooks Function()> {
  $$CachedEditionsTableTableManager(
      _$AppDatabase db, $CachedEditionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedEditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedEditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedEditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> identifier = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> englishName = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedEditionsCompanion(
            identifier: identifier,
            language: language,
            name: name,
            englishName: englishName,
            type: type,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String identifier,
            required String language,
            required String name,
            required String englishName,
            required String type,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedEditionsCompanion.insert(
            identifier: identifier,
            language: language,
            name: name,
            englishName: englishName,
            type: type,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedEditionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedEditionsTable,
    CachedEdition,
    $$CachedEditionsTableFilterComposer,
    $$CachedEditionsTableOrderingComposer,
    $$CachedEditionsTableAnnotationComposer,
    $$CachedEditionsTableCreateCompanionBuilder,
    $$CachedEditionsTableUpdateCompanionBuilder,
    (
      CachedEdition,
      BaseReferences<_$AppDatabase, $CachedEditionsTable, CachedEdition>
    ),
    CachedEdition,
    PrefetchHooks Function()>;
typedef $$CachedRecitersTableCreateCompanionBuilder = CachedRecitersCompanion
    Function({
  required String identifier,
  required String language,
  required String name,
  required String englishName,
  Value<int> rowid,
});
typedef $$CachedRecitersTableUpdateCompanionBuilder = CachedRecitersCompanion
    Function({
  Value<String> identifier,
  Value<String> language,
  Value<String> name,
  Value<String> englishName,
  Value<int> rowid,
});

class $$CachedRecitersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedRecitersTable> {
  $$CachedRecitersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get identifier => $composableBuilder(
      column: $table.identifier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => ColumnFilters(column));
}

class $$CachedRecitersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedRecitersTable> {
  $$CachedRecitersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get identifier => $composableBuilder(
      column: $table.identifier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => ColumnOrderings(column));
}

class $$CachedRecitersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedRecitersTable> {
  $$CachedRecitersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get identifier => $composableBuilder(
      column: $table.identifier, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get englishName => $composableBuilder(
      column: $table.englishName, builder: (column) => column);
}

class $$CachedRecitersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedRecitersTable,
    CachedReciter,
    $$CachedRecitersTableFilterComposer,
    $$CachedRecitersTableOrderingComposer,
    $$CachedRecitersTableAnnotationComposer,
    $$CachedRecitersTableCreateCompanionBuilder,
    $$CachedRecitersTableUpdateCompanionBuilder,
    (
      CachedReciter,
      BaseReferences<_$AppDatabase, $CachedRecitersTable, CachedReciter>
    ),
    CachedReciter,
    PrefetchHooks Function()> {
  $$CachedRecitersTableTableManager(
      _$AppDatabase db, $CachedRecitersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedRecitersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedRecitersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedRecitersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> identifier = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> englishName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedRecitersCompanion(
            identifier: identifier,
            language: language,
            name: name,
            englishName: englishName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String identifier,
            required String language,
            required String name,
            required String englishName,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedRecitersCompanion.insert(
            identifier: identifier,
            language: language,
            name: name,
            englishName: englishName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedRecitersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedRecitersTable,
    CachedReciter,
    $$CachedRecitersTableFilterComposer,
    $$CachedRecitersTableOrderingComposer,
    $$CachedRecitersTableAnnotationComposer,
    $$CachedRecitersTableCreateCompanionBuilder,
    $$CachedRecitersTableUpdateCompanionBuilder,
    (
      CachedReciter,
      BaseReferences<_$AppDatabase, $CachedRecitersTable, CachedReciter>
    ),
    CachedReciter,
    PrefetchHooks Function()>;
typedef $$LogsTableCreateCompanionBuilder = LogsCompanion Function({
  Value<int> id,
  required String level,
  required String message,
  Value<String?> stackTrace,
  Value<DateTime> timestamp,
});
typedef $$LogsTableUpdateCompanionBuilder = LogsCompanion Function({
  Value<int> id,
  Value<String> level,
  Value<String> message,
  Value<String?> stackTrace,
  Value<DateTime> timestamp,
});

class $$LogsTableFilterComposer extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stackTrace => $composableBuilder(
      column: $table.stackTrace, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$LogsTableOrderingComposer extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stackTrace => $composableBuilder(
      column: $table.stackTrace, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$LogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get stackTrace => $composableBuilder(
      column: $table.stackTrace, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$LogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LogsTable,
    LogEntry,
    $$LogsTableFilterComposer,
    $$LogsTableOrderingComposer,
    $$LogsTableAnnotationComposer,
    $$LogsTableCreateCompanionBuilder,
    $$LogsTableUpdateCompanionBuilder,
    (LogEntry, BaseReferences<_$AppDatabase, $LogsTable, LogEntry>),
    LogEntry,
    PrefetchHooks Function()> {
  $$LogsTableTableManager(_$AppDatabase db, $LogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<String?> stackTrace = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              LogsCompanion(
            id: id,
            level: level,
            message: message,
            stackTrace: stackTrace,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String level,
            required String message,
            Value<String?> stackTrace = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              LogsCompanion.insert(
            id: id,
            level: level,
            message: message,
            stackTrace: stackTrace,
            timestamp: timestamp,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LogsTable,
    LogEntry,
    $$LogsTableFilterComposer,
    $$LogsTableOrderingComposer,
    $$LogsTableAnnotationComposer,
    $$LogsTableCreateCompanionBuilder,
    $$LogsTableUpdateCompanionBuilder,
    (LogEntry, BaseReferences<_$AppDatabase, $LogsTable, LogEntry>),
    LogEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$AyahsTableTableManager get ayahs =>
      $$AyahsTableTableManager(_db, _db.ayahs);
  $$TranslationsTableTableManager get translations =>
      $$TranslationsTableTableManager(_db, _db.translations);
  $$WordTranslationsTableTableManager get wordTranslations =>
      $$WordTranslationsTableTableManager(_db, _db.wordTranslations);
  $$DownloadedAudiosTableTableManager get downloadedAudios =>
      $$DownloadedAudiosTableTableManager(_db, _db.downloadedAudios);
  $$AiCacheTableTableManager get aiCache =>
      $$AiCacheTableTableManager(_db, _db.aiCache);
  $$CachedEditionsTableTableManager get cachedEditions =>
      $$CachedEditionsTableTableManager(_db, _db.cachedEditions);
  $$CachedRecitersTableTableManager get cachedReciters =>
      $$CachedRecitersTableTableManager(_db, _db.cachedReciters);
  $$LogsTableTableManager get logs => $$LogsTableTableManager(_db, _db.logs);
}
