// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Book _$BookFromJson(Map<String, dynamic> json) {
  return _Book.fromJson(json);
}

/// @nodoc
mixin _$Book {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get authors => throw _privateConstructorUsedError;
  @JsonKey(name: 'authors_list', defaultValue: [])
  List<String> get authorsList => throw _privateConstructorUsedError;
  int get pages => throw _privateConstructorUsedError;
  String get publisher => throw _privateConstructorUsedError;
  int get reviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'publish_year', defaultValue: 0)
  int get publishYear => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String? get isbn => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url')
  String? get coverUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_local_path')
  String? get coverLocalPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'google_books_id')
  String? get googleBooksId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_reading_list', defaultValue: false)
  bool get isReadingList => throw _privateConstructorUsedError;
  @JsonKey(name: 'interaction_score', defaultValue: 0)
  int get interactionScore => throw _privateConstructorUsedError;
  double? get similarity => throw _privateConstructorUsedError;

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookCopyWith<Book> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookCopyWith<$Res> {
  factory $BookCopyWith(Book value, $Res Function(Book) then) =
      _$BookCopyWithImpl<$Res, Book>;
  @useResult
  $Res call(
      {int id,
      String name,
      String authors,
      @JsonKey(name: 'authors_list', defaultValue: []) List<String> authorsList,
      int pages,
      String publisher,
      int reviews,
      @JsonKey(name: 'publish_year', defaultValue: 0) int publishYear,
      double rating,
      String? isbn,
      String? description,
      @JsonKey(name: 'cover_url') String? coverUrl,
      @JsonKey(name: 'cover_local_path') String? coverLocalPath,
      @JsonKey(name: 'google_books_id') String? googleBooksId,
      @JsonKey(name: 'is_reading_list', defaultValue: false) bool isReadingList,
      @JsonKey(name: 'interaction_score', defaultValue: 0) int interactionScore,
      double? similarity});
}

/// @nodoc
class _$BookCopyWithImpl<$Res, $Val extends Book>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? authors = null,
    Object? authorsList = null,
    Object? pages = null,
    Object? publisher = null,
    Object? reviews = null,
    Object? publishYear = null,
    Object? rating = null,
    Object? isbn = freezed,
    Object? description = freezed,
    Object? coverUrl = freezed,
    Object? coverLocalPath = freezed,
    Object? googleBooksId = freezed,
    Object? isReadingList = null,
    Object? interactionScore = null,
    Object? similarity = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      authors: null == authors
          ? _value.authors
          : authors // ignore: cast_nullable_to_non_nullable
              as String,
      authorsList: null == authorsList
          ? _value.authorsList
          : authorsList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as int,
      publisher: null == publisher
          ? _value.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as int,
      publishYear: null == publishYear
          ? _value.publishYear
          : publishYear // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      isbn: freezed == isbn
          ? _value.isbn
          : isbn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      coverLocalPath: freezed == coverLocalPath
          ? _value.coverLocalPath
          : coverLocalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      googleBooksId: freezed == googleBooksId
          ? _value.googleBooksId
          : googleBooksId // ignore: cast_nullable_to_non_nullable
              as String?,
      isReadingList: null == isReadingList
          ? _value.isReadingList
          : isReadingList // ignore: cast_nullable_to_non_nullable
              as bool,
      interactionScore: null == interactionScore
          ? _value.interactionScore
          : interactionScore // ignore: cast_nullable_to_non_nullable
              as int,
      similarity: freezed == similarity
          ? _value.similarity
          : similarity // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookImplCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$$BookImplCopyWith(
          _$BookImpl value, $Res Function(_$BookImpl) then) =
      __$$BookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String authors,
      @JsonKey(name: 'authors_list', defaultValue: []) List<String> authorsList,
      int pages,
      String publisher,
      int reviews,
      @JsonKey(name: 'publish_year', defaultValue: 0) int publishYear,
      double rating,
      String? isbn,
      String? description,
      @JsonKey(name: 'cover_url') String? coverUrl,
      @JsonKey(name: 'cover_local_path') String? coverLocalPath,
      @JsonKey(name: 'google_books_id') String? googleBooksId,
      @JsonKey(name: 'is_reading_list', defaultValue: false) bool isReadingList,
      @JsonKey(name: 'interaction_score', defaultValue: 0) int interactionScore,
      double? similarity});
}

/// @nodoc
class __$$BookImplCopyWithImpl<$Res>
    extends _$BookCopyWithImpl<$Res, _$BookImpl>
    implements _$$BookImplCopyWith<$Res> {
  __$$BookImplCopyWithImpl(_$BookImpl _value, $Res Function(_$BookImpl) _then)
      : super(_value, _then);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? authors = null,
    Object? authorsList = null,
    Object? pages = null,
    Object? publisher = null,
    Object? reviews = null,
    Object? publishYear = null,
    Object? rating = null,
    Object? isbn = freezed,
    Object? description = freezed,
    Object? coverUrl = freezed,
    Object? coverLocalPath = freezed,
    Object? googleBooksId = freezed,
    Object? isReadingList = null,
    Object? interactionScore = null,
    Object? similarity = freezed,
  }) {
    return _then(_$BookImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      authors: null == authors
          ? _value.authors
          : authors // ignore: cast_nullable_to_non_nullable
              as String,
      authorsList: null == authorsList
          ? _value._authorsList
          : authorsList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as int,
      publisher: null == publisher
          ? _value.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as int,
      publishYear: null == publishYear
          ? _value.publishYear
          : publishYear // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      isbn: freezed == isbn
          ? _value.isbn
          : isbn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      coverLocalPath: freezed == coverLocalPath
          ? _value.coverLocalPath
          : coverLocalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      googleBooksId: freezed == googleBooksId
          ? _value.googleBooksId
          : googleBooksId // ignore: cast_nullable_to_non_nullable
              as String?,
      isReadingList: null == isReadingList
          ? _value.isReadingList
          : isReadingList // ignore: cast_nullable_to_non_nullable
              as bool,
      interactionScore: null == interactionScore
          ? _value.interactionScore
          : interactionScore // ignore: cast_nullable_to_non_nullable
              as int,
      similarity: freezed == similarity
          ? _value.similarity
          : similarity // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookImpl extends _Book {
  const _$BookImpl(
      {required this.id,
      required this.name,
      this.authors = '',
      @JsonKey(name: 'authors_list', defaultValue: [])
      final List<String> authorsList = const [],
      this.pages = 0,
      this.publisher = '',
      this.reviews = 0,
      @JsonKey(name: 'publish_year', defaultValue: 0) this.publishYear = 0,
      this.rating = 0.0,
      this.isbn,
      this.description,
      @JsonKey(name: 'cover_url') this.coverUrl,
      @JsonKey(name: 'cover_local_path') this.coverLocalPath,
      @JsonKey(name: 'google_books_id') this.googleBooksId,
      @JsonKey(name: 'is_reading_list', defaultValue: false)
      this.isReadingList = false,
      @JsonKey(name: 'interaction_score', defaultValue: 0)
      this.interactionScore = 0,
      this.similarity})
      : _authorsList = authorsList,
        super._();

  factory _$BookImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey()
  final String authors;
  final List<String> _authorsList;
  @override
  @JsonKey(name: 'authors_list', defaultValue: [])
  List<String> get authorsList {
    if (_authorsList is EqualUnmodifiableListView) return _authorsList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_authorsList);
  }

  @override
  @JsonKey()
  final int pages;
  @override
  @JsonKey()
  final String publisher;
  @override
  @JsonKey()
  final int reviews;
  @override
  @JsonKey(name: 'publish_year', defaultValue: 0)
  final int publishYear;
  @override
  @JsonKey()
  final double rating;
  @override
  final String? isbn;
  @override
  final String? description;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @override
  @JsonKey(name: 'cover_local_path')
  final String? coverLocalPath;
  @override
  @JsonKey(name: 'google_books_id')
  final String? googleBooksId;
  @override
  @JsonKey(name: 'is_reading_list', defaultValue: false)
  final bool isReadingList;
  @override
  @JsonKey(name: 'interaction_score', defaultValue: 0)
  final int interactionScore;
  @override
  final double? similarity;

  @override
  String toString() {
    return 'Book(id: $id, name: $name, authors: $authors, authorsList: $authorsList, pages: $pages, publisher: $publisher, reviews: $reviews, publishYear: $publishYear, rating: $rating, isbn: $isbn, description: $description, coverUrl: $coverUrl, coverLocalPath: $coverLocalPath, googleBooksId: $googleBooksId, isReadingList: $isReadingList, interactionScore: $interactionScore, similarity: $similarity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.authors, authors) || other.authors == authors) &&
            const DeepCollectionEquality()
                .equals(other._authorsList, _authorsList) &&
            (identical(other.pages, pages) || other.pages == pages) &&
            (identical(other.publisher, publisher) ||
                other.publisher == publisher) &&
            (identical(other.reviews, reviews) || other.reviews == reviews) &&
            (identical(other.publishYear, publishYear) ||
                other.publishYear == publishYear) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isbn, isbn) || other.isbn == isbn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.coverLocalPath, coverLocalPath) ||
                other.coverLocalPath == coverLocalPath) &&
            (identical(other.googleBooksId, googleBooksId) ||
                other.googleBooksId == googleBooksId) &&
            (identical(other.isReadingList, isReadingList) ||
                other.isReadingList == isReadingList) &&
            (identical(other.interactionScore, interactionScore) ||
                other.interactionScore == interactionScore) &&
            (identical(other.similarity, similarity) ||
                other.similarity == similarity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      authors,
      const DeepCollectionEquality().hash(_authorsList),
      pages,
      publisher,
      reviews,
      publishYear,
      rating,
      isbn,
      description,
      coverUrl,
      coverLocalPath,
      googleBooksId,
      isReadingList,
      interactionScore,
      similarity);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      __$$BookImplCopyWithImpl<_$BookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookImplToJson(
      this,
    );
  }
}

abstract class _Book extends Book {
  const factory _Book(
      {required final int id,
      required final String name,
      final String authors,
      @JsonKey(name: 'authors_list', defaultValue: [])
      final List<String> authorsList,
      final int pages,
      final String publisher,
      final int reviews,
      @JsonKey(name: 'publish_year', defaultValue: 0) final int publishYear,
      final double rating,
      final String? isbn,
      final String? description,
      @JsonKey(name: 'cover_url') final String? coverUrl,
      @JsonKey(name: 'cover_local_path') final String? coverLocalPath,
      @JsonKey(name: 'google_books_id') final String? googleBooksId,
      @JsonKey(name: 'is_reading_list', defaultValue: false)
      final bool isReadingList,
      @JsonKey(name: 'interaction_score', defaultValue: 0)
      final int interactionScore,
      final double? similarity}) = _$BookImpl;
  const _Book._() : super._();

  factory _Book.fromJson(Map<String, dynamic> json) = _$BookImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get authors;
  @override
  @JsonKey(name: 'authors_list', defaultValue: [])
  List<String> get authorsList;
  @override
  int get pages;
  @override
  String get publisher;
  @override
  int get reviews;
  @override
  @JsonKey(name: 'publish_year', defaultValue: 0)
  int get publishYear;
  @override
  double get rating;
  @override
  String? get isbn;
  @override
  String? get description;
  @override
  @JsonKey(name: 'cover_url')
  String? get coverUrl;
  @override
  @JsonKey(name: 'cover_local_path')
  String? get coverLocalPath;
  @override
  @JsonKey(name: 'google_books_id')
  String? get googleBooksId;
  @override
  @JsonKey(name: 'is_reading_list', defaultValue: false)
  bool get isReadingList;
  @override
  @JsonKey(name: 'interaction_score', defaultValue: 0)
  int get interactionScore;
  @override
  double? get similarity;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
