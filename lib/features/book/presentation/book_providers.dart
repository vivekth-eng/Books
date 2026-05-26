import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:libri_stack/features/book/domain/models/book.dart';
import 'package:libri_stack/features/book/data/book_repository.dart';

part 'book_providers.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
  
  void setQuery(String q) => state = q;
}

@riverpod
class SemanticMode extends _$SemanticMode {
  @override
  bool build() => false;
  
  void toggle() => state = !state;
}

@riverpod
class SelectedPublisher extends _$SelectedPublisher {
  @override
  String? build() => null;
  
  void setPublisher(String? pub) => state = pub;
}

@riverpod
class BookList extends _$BookList {
  @override
  FutureOr<List<Book>> build() async {
    final search = ref.watch(searchQueryProvider);
    final semantic = ref.watch(semanticModeProvider);
    final publisher = ref.watch(selectedPublisherProvider);
    
    final repo = ref.watch(bookRepositoryProvider);
    final List<Book> books;
    if (semantic && search.trim().isNotEmpty) {
      books = await repo.searchSemantic(search, limit: 100);
    } else {
      books = await repo.getBooks(
        search: search,
        semantic: semantic,
        publisher: publisher,
        limit: 100, // Simple batch limit for dashboard performance
      );
    }

    // Stable sort: place books with covers first
    final withCovers = books.where((b) => b.coverUrl != null && b.coverUrl!.isNotEmpty).toList();
    final withoutCovers = books.where((b) => b.coverUrl == null || b.coverUrl!.isEmpty).toList();
    return [...withCovers, ...withoutCovers];
  }
}

@riverpod
Future<List<Map<String, dynamic>>> publishersList(PublishersListRef ref) async {
  final repo = ref.watch(bookRepositoryProvider);
  return repo.getPublishers();
}

@riverpod
class ReadingListNotifier extends _$ReadingListNotifier {
  @override
  FutureOr<List<Book>> build() async {
    final repo = ref.watch(bookRepositoryProvider);
    return repo.getReadingList();
  }
  
  Future<void> toggle(Book book) async {
    final repo = ref.read(bookRepositoryProvider);
    final currentStatus = book.isReadingList;
    await repo.toggleReadingList(book.id, currentStatus);
    
    // Invalidate collections to automatically refresh components
    ref.invalidateSelf();
    ref.invalidate(bookListProvider);
  }
}

@riverpod
class BookDetailsNotifier extends _$BookDetailsNotifier {
  @override
  FutureOr<Book?> build(String isbn) async {
    final repo = ref.watch(bookRepositoryProvider);
    return repo.getBookByIsbn(isbn);
  }
  
  Future<void> rate(int score) async {
    final repo = ref.read(bookRepositoryProvider);
    final book = state.value;
    if (book != null) {
      await repo.interact(book.id, score);
      
      // Refresh detailed and list states
      ref.invalidateSelf();
      ref.invalidate(bookListProvider);
      ref.invalidate(readingListNotifierProvider);
    }
  }
  
  Future<void> toggleReadingList(Book book) async {
    final repo = ref.read(bookRepositoryProvider);
    final currentStatus = book.isReadingList;
    await repo.toggleReadingList(book.id, currentStatus);
    
    // Refresh detailed and list states
    ref.invalidateSelf();
    ref.invalidate(bookListProvider);
    ref.invalidate(readingListNotifierProvider);
  }
}
