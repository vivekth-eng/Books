import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:libri_stack/features/book/domain/models/book.dart';
import 'package:libri_stack/core/providers/core_providers.dart';

part 'book_repository.g.dart';

class BookRepository {
  final Dio _dio;
  BookRepository(this._dio);

  Future<List<Book>> getBooks({
    int limit = 50,
    int offset = 0,
    String? authors,
    String? publisher,
    int? yearMin,
    int? yearMax,
    String? sortBy,
    String? sortOrder,
    String? search,
    bool? readingList,
    double? minRating,
    bool? semantic,
  }) async {
    final Map<String, dynamic> queryParams = {
      'limit': limit,
      'offset': offset,
    };

    if (authors != null && authors.isNotEmpty) {
      queryParams['authors'] = authors;
    }
    if (publisher != null && publisher.isNotEmpty) {
      queryParams['publisher'] = publisher;
    }
    if (yearMin != null) {
      queryParams['year_min'] = yearMin;
    }
    if (yearMax != null) {
      queryParams['year_max'] = yearMax;
    }
    if (sortBy != null) {
      queryParams['sort_by'] = sortBy;
    }
    if (sortOrder != null) {
      queryParams['sort_order'] = sortOrder;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (readingList != null) {
      queryParams['reading_list'] = readingList;
    }
    if (minRating != null) {
      queryParams['min_rating'] = minRating;
    }
    if (semantic != null) {
      queryParams['semantic'] = semantic;
    }

    final response = await _dio.get('/books', queryParameters: queryParams);
    final List data = response.data;
    return data.map((e) => Book.fromJson(e)).toList();
  }

  Future<Book?> getBookByIsbn(String isbn) async {
    final response = await _dio.get('/api/v1/books/$isbn');
    if (response.statusCode == 200) {
      return Book.fromJson(response.data);
    }
    return null;
  }

  Future<List<Book>> searchSemantic(String query, {int limit = 50}) async {
    final response = await _dio.get(
      '/api/v1/books/search/semantic',
      queryParameters: {'query': query, 'limit': limit},
    );
    final List data = response.data;
    return data.map((e) => Book.fromJson(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getPublishers() async {
    final response = await _dio.get('/publishers');
    final List data = response.data;
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getConfig() async {
    final response = await _dio.get('/config');
    return response.data as Map<String, dynamic>;
  }

  Future<void> interact(int bookId, int score) async {
    await _dio.post('/books/$bookId/interact', data: {'score': score});
  }

  Future<void> toggleReadingList(int bookId, bool currentStatus) async {
    final action = currentStatus ? 'remove' : 'add';
    await _dio.post('/books/$bookId/reading-list', data: {'action': action});
  }

  Future<List<Book>> getReadingList() async {
    final response = await _dio.get('/reading-list');
    final List data = response.data;
    return data.map((e) => Book.fromJson(e)).toList();
  }
}

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return BookRepository(ref.watch(dioProvider));
}
