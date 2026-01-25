// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'research_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResearchMessage {

 bool get isUser; ResearchContent get content; bool get isTyping;
/// Create a copy of ResearchMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResearchMessageCopyWith<ResearchMessage> get copyWith => _$ResearchMessageCopyWithImpl<ResearchMessage>(this as ResearchMessage, _$identity);

  /// Serializes this ResearchMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResearchMessage&&(identical(other.isUser, isUser) || other.isUser == isUser)&&(identical(other.content, content) || other.content == content)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isUser,content,isTyping);

@override
String toString() {
  return 'ResearchMessage(isUser: $isUser, content: $content, isTyping: $isTyping)';
}


}

/// @nodoc
abstract mixin class $ResearchMessageCopyWith<$Res>  {
  factory $ResearchMessageCopyWith(ResearchMessage value, $Res Function(ResearchMessage) _then) = _$ResearchMessageCopyWithImpl;
@useResult
$Res call({
 bool isUser, ResearchContent content, bool isTyping
});


$ResearchContentCopyWith<$Res> get content;

}
/// @nodoc
class _$ResearchMessageCopyWithImpl<$Res>
    implements $ResearchMessageCopyWith<$Res> {
  _$ResearchMessageCopyWithImpl(this._self, this._then);

  final ResearchMessage _self;
  final $Res Function(ResearchMessage) _then;

/// Create a copy of ResearchMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isUser = null,Object? content = null,Object? isTyping = null,}) {
  return _then(_self.copyWith(
isUser: null == isUser ? _self.isUser : isUser // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ResearchContent,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ResearchMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResearchContentCopyWith<$Res> get content {
  
  return $ResearchContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [ResearchMessage].
extension ResearchMessagePatterns on ResearchMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResearchMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResearchMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResearchMessage value)  $default,){
final _that = this;
switch (_that) {
case _ResearchMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResearchMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ResearchMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isUser,  ResearchContent content,  bool isTyping)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResearchMessage() when $default != null:
return $default(_that.isUser,_that.content,_that.isTyping);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isUser,  ResearchContent content,  bool isTyping)  $default,) {final _that = this;
switch (_that) {
case _ResearchMessage():
return $default(_that.isUser,_that.content,_that.isTyping);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isUser,  ResearchContent content,  bool isTyping)?  $default,) {final _that = this;
switch (_that) {
case _ResearchMessage() when $default != null:
return $default(_that.isUser,_that.content,_that.isTyping);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResearchMessage extends ResearchMessage {
  const _ResearchMessage({required this.isUser, required this.content, this.isTyping = false}): super._();
  factory _ResearchMessage.fromJson(Map<String, dynamic> json) => _$ResearchMessageFromJson(json);

@override final  bool isUser;
@override final  ResearchContent content;
@override@JsonKey() final  bool isTyping;

/// Create a copy of ResearchMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResearchMessageCopyWith<_ResearchMessage> get copyWith => __$ResearchMessageCopyWithImpl<_ResearchMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResearchMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResearchMessage&&(identical(other.isUser, isUser) || other.isUser == isUser)&&(identical(other.content, content) || other.content == content)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isUser,content,isTyping);

@override
String toString() {
  return 'ResearchMessage(isUser: $isUser, content: $content, isTyping: $isTyping)';
}


}

/// @nodoc
abstract mixin class _$ResearchMessageCopyWith<$Res> implements $ResearchMessageCopyWith<$Res> {
  factory _$ResearchMessageCopyWith(_ResearchMessage value, $Res Function(_ResearchMessage) _then) = __$ResearchMessageCopyWithImpl;
@override @useResult
$Res call({
 bool isUser, ResearchContent content, bool isTyping
});


@override $ResearchContentCopyWith<$Res> get content;

}
/// @nodoc
class __$ResearchMessageCopyWithImpl<$Res>
    implements _$ResearchMessageCopyWith<$Res> {
  __$ResearchMessageCopyWithImpl(this._self, this._then);

  final _ResearchMessage _self;
  final $Res Function(_ResearchMessage) _then;

/// Create a copy of ResearchMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isUser = null,Object? content = null,Object? isTyping = null,}) {
  return _then(_ResearchMessage(
isUser: null == isUser ? _self.isUser : isUser // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ResearchContent,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ResearchMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResearchContentCopyWith<$Res> get content {
  
  return $ResearchContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

ResearchContent _$ResearchContentFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'text':
          return TextContent.fromJson(
            json
          );
                case 'grammar':
          return GrammarContent.fromJson(
            json
          );
                case 'history':
          return HistoryContent.fromJson(
            json
          );
                case 'insight':
          return InsightContent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'ResearchContent',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ResearchContent {



  /// Serializes this ResearchContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResearchContent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResearchContent()';
}


}

/// @nodoc
class $ResearchContentCopyWith<$Res>  {
$ResearchContentCopyWith(ResearchContent _, $Res Function(ResearchContent) __);
}


/// Adds pattern-matching-related methods to [ResearchContent].
extension ResearchContentPatterns on ResearchContent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextContent value)?  text,TResult Function( GrammarContent value)?  grammar,TResult Function( HistoryContent value)?  history,TResult Function( InsightContent value)?  insight,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that);case GrammarContent() when grammar != null:
return grammar(_that);case HistoryContent() when history != null:
return history(_that);case InsightContent() when insight != null:
return insight(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextContent value)  text,required TResult Function( GrammarContent value)  grammar,required TResult Function( HistoryContent value)  history,required TResult Function( InsightContent value)  insight,}){
final _that = this;
switch (_that) {
case TextContent():
return text(_that);case GrammarContent():
return grammar(_that);case HistoryContent():
return history(_that);case InsightContent():
return insight(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextContent value)?  text,TResult? Function( GrammarContent value)?  grammar,TResult? Function( HistoryContent value)?  history,TResult? Function( InsightContent value)?  insight,}){
final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that);case GrammarContent() when grammar != null:
return grammar(_that);case HistoryContent() when history != null:
return history(_that);case InsightContent() when insight != null:
return insight(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  text,TResult Function( List<GrammarWord> words)?  grammar,TResult Function( String title,  String era,  List<String> events,  List<String> sources)?  history,TResult Function( String title,  String body,  List<String> tags,  String reference)?  insight,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that.text);case GrammarContent() when grammar != null:
return grammar(_that.words);case HistoryContent() when history != null:
return history(_that.title,_that.era,_that.events,_that.sources);case InsightContent() when insight != null:
return insight(_that.title,_that.body,_that.tags,_that.reference);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  text,required TResult Function( List<GrammarWord> words)  grammar,required TResult Function( String title,  String era,  List<String> events,  List<String> sources)  history,required TResult Function( String title,  String body,  List<String> tags,  String reference)  insight,}) {final _that = this;
switch (_that) {
case TextContent():
return text(_that.text);case GrammarContent():
return grammar(_that.words);case HistoryContent():
return history(_that.title,_that.era,_that.events,_that.sources);case InsightContent():
return insight(_that.title,_that.body,_that.tags,_that.reference);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  text,TResult? Function( List<GrammarWord> words)?  grammar,TResult? Function( String title,  String era,  List<String> events,  List<String> sources)?  history,TResult? Function( String title,  String body,  List<String> tags,  String reference)?  insight,}) {final _that = this;
switch (_that) {
case TextContent() when text != null:
return text(_that.text);case GrammarContent() when grammar != null:
return grammar(_that.words);case HistoryContent() when history != null:
return history(_that.title,_that.era,_that.events,_that.sources);case InsightContent() when insight != null:
return insight(_that.title,_that.body,_that.tags,_that.reference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TextContent implements ResearchContent {
  const TextContent(this.text, {final  String? $type}): $type = $type ?? 'text';
  factory TextContent.fromJson(Map<String, dynamic> json) => _$TextContentFromJson(json);

 final  String text;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextContentCopyWith<TextContent> get copyWith => _$TextContentCopyWithImpl<TextContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextContent&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'ResearchContent.text(text: $text)';
}


}

/// @nodoc
abstract mixin class $TextContentCopyWith<$Res> implements $ResearchContentCopyWith<$Res> {
  factory $TextContentCopyWith(TextContent value, $Res Function(TextContent) _then) = _$TextContentCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$TextContentCopyWithImpl<$Res>
    implements $TextContentCopyWith<$Res> {
  _$TextContentCopyWithImpl(this._self, this._then);

  final TextContent _self;
  final $Res Function(TextContent) _then;

/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(TextContent(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GrammarContent implements ResearchContent {
  const GrammarContent({required final  List<GrammarWord> words, final  String? $type}): _words = words,$type = $type ?? 'grammar';
  factory GrammarContent.fromJson(Map<String, dynamic> json) => _$GrammarContentFromJson(json);

 final  List<GrammarWord> _words;
 List<GrammarWord> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarContentCopyWith<GrammarContent> get copyWith => _$GrammarContentCopyWithImpl<GrammarContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarContent&&const DeepCollectionEquality().equals(other._words, _words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_words));

@override
String toString() {
  return 'ResearchContent.grammar(words: $words)';
}


}

/// @nodoc
abstract mixin class $GrammarContentCopyWith<$Res> implements $ResearchContentCopyWith<$Res> {
  factory $GrammarContentCopyWith(GrammarContent value, $Res Function(GrammarContent) _then) = _$GrammarContentCopyWithImpl;
@useResult
$Res call({
 List<GrammarWord> words
});




}
/// @nodoc
class _$GrammarContentCopyWithImpl<$Res>
    implements $GrammarContentCopyWith<$Res> {
  _$GrammarContentCopyWithImpl(this._self, this._then);

  final GrammarContent _self;
  final $Res Function(GrammarContent) _then;

/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? words = null,}) {
  return _then(GrammarContent(
words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<GrammarWord>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class HistoryContent implements ResearchContent {
  const HistoryContent({this.title = '', this.era = '', final  List<String> events = const [], final  List<String> sources = const [], final  String? $type}): _events = events,_sources = sources,$type = $type ?? 'history';
  factory HistoryContent.fromJson(Map<String, dynamic> json) => _$HistoryContentFromJson(json);

@JsonKey() final  String title;
@JsonKey() final  String era;
 final  List<String> _events;
@JsonKey() List<String> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

 final  List<String> _sources;
@JsonKey() List<String> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryContentCopyWith<HistoryContent> get copyWith => _$HistoryContentCopyWithImpl<HistoryContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryContent&&(identical(other.title, title) || other.title == title)&&(identical(other.era, era) || other.era == era)&&const DeepCollectionEquality().equals(other._events, _events)&&const DeepCollectionEquality().equals(other._sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,era,const DeepCollectionEquality().hash(_events),const DeepCollectionEquality().hash(_sources));

@override
String toString() {
  return 'ResearchContent.history(title: $title, era: $era, events: $events, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $HistoryContentCopyWith<$Res> implements $ResearchContentCopyWith<$Res> {
  factory $HistoryContentCopyWith(HistoryContent value, $Res Function(HistoryContent) _then) = _$HistoryContentCopyWithImpl;
@useResult
$Res call({
 String title, String era, List<String> events, List<String> sources
});




}
/// @nodoc
class _$HistoryContentCopyWithImpl<$Res>
    implements $HistoryContentCopyWith<$Res> {
  _$HistoryContentCopyWithImpl(this._self, this._then);

  final HistoryContent _self;
  final $Res Function(HistoryContent) _then;

/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? era = null,Object? events = null,Object? sources = null,}) {
  return _then(HistoryContent(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,era: null == era ? _self.era : era // ignore: cast_nullable_to_non_nullable
as String,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class InsightContent implements ResearchContent {
  const InsightContent({this.title = '', this.body = '', final  List<String> tags = const [], this.reference = '', final  String? $type}): _tags = tags,$type = $type ?? 'insight';
  factory InsightContent.fromJson(Map<String, dynamic> json) => _$InsightContentFromJson(json);

@JsonKey() final  String title;
@JsonKey() final  String body;
 final  List<String> _tags;
@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@JsonKey() final  String reference;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightContentCopyWith<InsightContent> get copyWith => _$InsightContentCopyWithImpl<InsightContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsightContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightContent&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.reference, reference) || other.reference == reference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body,const DeepCollectionEquality().hash(_tags),reference);

@override
String toString() {
  return 'ResearchContent.insight(title: $title, body: $body, tags: $tags, reference: $reference)';
}


}

/// @nodoc
abstract mixin class $InsightContentCopyWith<$Res> implements $ResearchContentCopyWith<$Res> {
  factory $InsightContentCopyWith(InsightContent value, $Res Function(InsightContent) _then) = _$InsightContentCopyWithImpl;
@useResult
$Res call({
 String title, String body, List<String> tags, String reference
});




}
/// @nodoc
class _$InsightContentCopyWithImpl<$Res>
    implements $InsightContentCopyWith<$Res> {
  _$InsightContentCopyWithImpl(this._self, this._then);

  final InsightContent _self;
  final $Res Function(InsightContent) _then;

/// Create a copy of ResearchContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,Object? tags = null,Object? reference = null,}) {
  return _then(InsightContent(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GrammarWord {

 String get arabicWord; String get transliteration; String get root; String get form; String get tense; String get mood; String get meaning;
/// Create a copy of GrammarWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarWordCopyWith<GrammarWord> get copyWith => _$GrammarWordCopyWithImpl<GrammarWord>(this as GrammarWord, _$identity);

  /// Serializes this GrammarWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarWord&&(identical(other.arabicWord, arabicWord) || other.arabicWord == arabicWord)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.root, root) || other.root == root)&&(identical(other.form, form) || other.form == form)&&(identical(other.tense, tense) || other.tense == tense)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.meaning, meaning) || other.meaning == meaning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,arabicWord,transliteration,root,form,tense,mood,meaning);

@override
String toString() {
  return 'GrammarWord(arabicWord: $arabicWord, transliteration: $transliteration, root: $root, form: $form, tense: $tense, mood: $mood, meaning: $meaning)';
}


}

/// @nodoc
abstract mixin class $GrammarWordCopyWith<$Res>  {
  factory $GrammarWordCopyWith(GrammarWord value, $Res Function(GrammarWord) _then) = _$GrammarWordCopyWithImpl;
@useResult
$Res call({
 String arabicWord, String transliteration, String root, String form, String tense, String mood, String meaning
});




}
/// @nodoc
class _$GrammarWordCopyWithImpl<$Res>
    implements $GrammarWordCopyWith<$Res> {
  _$GrammarWordCopyWithImpl(this._self, this._then);

  final GrammarWord _self;
  final $Res Function(GrammarWord) _then;

/// Create a copy of GrammarWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? arabicWord = null,Object? transliteration = null,Object? root = null,Object? form = null,Object? tense = null,Object? mood = null,Object? meaning = null,}) {
  return _then(_self.copyWith(
arabicWord: null == arabicWord ? _self.arabicWord : arabicWord // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as String,tense: null == tense ? _self.tense : tense // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarWord].
extension GrammarWordPatterns on GrammarWord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarWord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarWord value)  $default,){
final _that = this;
switch (_that) {
case _GrammarWord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarWord value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarWord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String arabicWord,  String transliteration,  String root,  String form,  String tense,  String mood,  String meaning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarWord() when $default != null:
return $default(_that.arabicWord,_that.transliteration,_that.root,_that.form,_that.tense,_that.mood,_that.meaning);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String arabicWord,  String transliteration,  String root,  String form,  String tense,  String mood,  String meaning)  $default,) {final _that = this;
switch (_that) {
case _GrammarWord():
return $default(_that.arabicWord,_that.transliteration,_that.root,_that.form,_that.tense,_that.mood,_that.meaning);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String arabicWord,  String transliteration,  String root,  String form,  String tense,  String mood,  String meaning)?  $default,) {final _that = this;
switch (_that) {
case _GrammarWord() when $default != null:
return $default(_that.arabicWord,_that.transliteration,_that.root,_that.form,_that.tense,_that.mood,_that.meaning);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarWord extends GrammarWord {
  const _GrammarWord({required this.arabicWord, this.transliteration = '', this.root = '', this.form = '', this.tense = '', this.mood = '', this.meaning = ''}): super._();
  factory _GrammarWord.fromJson(Map<String, dynamic> json) => _$GrammarWordFromJson(json);

@override final  String arabicWord;
@override@JsonKey() final  String transliteration;
@override@JsonKey() final  String root;
@override@JsonKey() final  String form;
@override@JsonKey() final  String tense;
@override@JsonKey() final  String mood;
@override@JsonKey() final  String meaning;

/// Create a copy of GrammarWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarWordCopyWith<_GrammarWord> get copyWith => __$GrammarWordCopyWithImpl<_GrammarWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarWord&&(identical(other.arabicWord, arabicWord) || other.arabicWord == arabicWord)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.root, root) || other.root == root)&&(identical(other.form, form) || other.form == form)&&(identical(other.tense, tense) || other.tense == tense)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.meaning, meaning) || other.meaning == meaning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,arabicWord,transliteration,root,form,tense,mood,meaning);

@override
String toString() {
  return 'GrammarWord(arabicWord: $arabicWord, transliteration: $transliteration, root: $root, form: $form, tense: $tense, mood: $mood, meaning: $meaning)';
}


}

/// @nodoc
abstract mixin class _$GrammarWordCopyWith<$Res> implements $GrammarWordCopyWith<$Res> {
  factory _$GrammarWordCopyWith(_GrammarWord value, $Res Function(_GrammarWord) _then) = __$GrammarWordCopyWithImpl;
@override @useResult
$Res call({
 String arabicWord, String transliteration, String root, String form, String tense, String mood, String meaning
});




}
/// @nodoc
class __$GrammarWordCopyWithImpl<$Res>
    implements _$GrammarWordCopyWith<$Res> {
  __$GrammarWordCopyWithImpl(this._self, this._then);

  final _GrammarWord _self;
  final $Res Function(_GrammarWord) _then;

/// Create a copy of GrammarWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? arabicWord = null,Object? transliteration = null,Object? root = null,Object? form = null,Object? tense = null,Object? mood = null,Object? meaning = null,}) {
  return _then(_GrammarWord(
arabicWord: null == arabicWord ? _self.arabicWord : arabicWord // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as String,tense: null == tense ? _self.tense : tense // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
