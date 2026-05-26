import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:libri_stack/core/config.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const Book._();

  const factory Book({
    required int id,
    required String name,
    @Default('') String authors,
    @JsonKey(name: 'authors_list', defaultValue: []) @Default([]) List<String> authorsList,
    @Default(0) int pages,
    @Default('') String publisher,
    @Default(0) int reviews,
    @JsonKey(name: 'publish_year', defaultValue: 0) @Default(0) int publishYear,
    @Default(0.0) double rating,
    String? isbn,
    String? description,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'cover_local_path') String? coverLocalPath,
    @JsonKey(name: 'google_books_id') String? googleBooksId,
    @JsonKey(name: 'is_reading_list', defaultValue: false) @Default(false) bool isReadingList,
    @JsonKey(name: 'interaction_score', defaultValue: 0) @Default(0) int interactionScore,
    double? similarity,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  String? get coverName => coverUrl;

  String get fullCoverPath {
    if (coverUrl == null || coverUrl!.isEmpty) return '';
    if (coverUrl!.startsWith('http')) return coverUrl!;
    if (kMockDemoMode) {
      return 'assets/assets/covers/${coverUrl!.startsWith('/') ? coverUrl!.substring(1) : coverUrl!}';
    }
    // Locally served from FastAPI backend on Port 8000 static route /static/covers/
    return 'http://localhost:8000/static/covers/${coverUrl!.startsWith('/') ? coverUrl!.substring(1) : coverUrl!}';
  }
}
