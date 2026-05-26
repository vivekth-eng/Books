import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:libri_stack/features/book/domain/models/book.dart';
import 'package:libri_stack/core/providers/core_providers.dart';
import 'package:libri_stack/core/config.dart';

part 'book_repository.g.dart';

class BookRepository {
  final Dio _dio;
  BookRepository(this._dio);

  static final List<Book> _mockBooks = [
    const Book(
      id: 1,
      name: 'Harry Potter and the Prisoner of Azkaban',
      authors: 'J.K. Rowling',
      authorsList: ['J.K. Rowling'],
      pages: 435,
      publisher: 'Scholastic',
      reviews: 948,
      publishYear: 1999,
      rating: 4.8,
      isbn: '043965548X',
      description: 'Harry Potter, along with his best friends, Ron and Hermione, is about to start his third year at Hogwarts School of Witchcraft and Wizardry. Harry can\'t wait to get back to school after the summer holidays. But when Harry arrives at Hogwarts, the atmosphere is tense. There\'s an escaped killer on the loose...',
      coverUrl: 'Harry_Potter_and_the_Prisoner_of_Azkaban_(Harry_Potter,_#3)_043965548X.jpg',
      isReadingList: false,
      interactionScore: 3,
    ),
    const Book(
      id: 2,
      name: 'Da Vinci Code',
      authors: 'Dan Brown',
      authorsList: ['Dan Brown'],
      pages: 489,
      publisher: 'Doubleday',
      reviews: 582,
      publishYear: 2003,
      rating: 4.1,
      isbn: '2266144340',
      description: 'While in Paris, Harvard symbologist Robert Langdon is awakened by a phone call in the dead of the night. The elderly curator of the Louvre has been murdered inside the museum, his body covered in baffling symbols. As Langdon and gifted French cryptologist Sophie Neveu unpack the bizarre riddles...',
      coverUrl: 'Da_Vinci_Code_(Robert_Langdon,_#2)_2266144340.jpg',
      isReadingList: true,
      interactionScore: 2,
    ),
    const Book(
      id: 3,
      name: 'Angels & Demons',
      authors: 'Dan Brown',
      authorsList: ['Dan Brown'],
      pages: 569,
      publisher: 'Pocket Books',
      reviews: 742,
      publishYear: 2000,
      rating: 4.3,
      isbn: '1416524797',
      description: 'World-renowned Harvard symbologist Robert Langdon is summoned to a Swiss research facility to analyze a mysterious symbol seared into the chest of a murdered physicist. What he discovers is unimaginable: a deadly vendetta against the Catholic Church by a legendary secret society, the Illuminati.',
      coverUrl: 'Angels_&_Demons_(Robert_Langdon,_#1)_1416524797.jpg',
      isReadingList: false,
      interactionScore: 0,
    ),
    const Book(
      id: 4,
      name: 'Fahrenheit 451',
      authors: 'Ray Bradbury',
      authorsList: ['Ray Bradbury'],
      pages: 156,
      publisher: 'Ballantine Books',
      reviews: 1205,
      publishYear: 1953,
      rating: 4.6,
      isbn: '078617627X',
      description: 'Guy Montag is a fireman. In his world, where television rules and literature is on the brink of extinction, firemen start fires rather than put them out. His job is to destroy the most illegal of commodities, the printed book, along with the houses in which they are hidden.',
      coverUrl: 'Fahrenheit_451_078617627X.jpg',
      isReadingList: false,
      interactionScore: 1,
    ),
    const Book(
      id: 5,
      name: 'About a Boy',
      authors: 'Nick Hornby',
      authorsList: ['Nick Hornby'],
      pages: 307,
      publisher: 'Riverhead Books',
      reviews: 210,
      publishYear: 1998,
      rating: 4.2,
      isbn: '1573229571',
      description: 'About a Boy is a 1998 novel written by British writer Nick Hornby. It touches on themes of growing up, responsibility, and friendship. The story features Will Freeman, a 36-year-old Londoner, and Marcus Brewer, a socially awkward schoolboy.',
      coverUrl: 'About_a_Boy_1573229571.jpg',
      isReadingList: false,
      interactionScore: 0,
    ),
    const Book(
      id: 6,
      name: 'Siddhartha',
      authors: 'Hermann Hesse',
      authorsList: ['Hermann Hesse'],
      pages: 152,
      publisher: 'New Directions',
      reviews: 310,
      publishYear: 1922,
      rating: 4.4,
      isbn: '1419147188',
      description: 'Siddhartha is a 1922 novel by Hermann Hesse that deals with the spiritual journey of self-discovery of a man named Siddhartha during the time of the Gautama Buddha. The book, Hesse\'s ninth novel, was written in German, in a simple, lyrical style.',
      coverUrl: 'Siddhartha_1419147188.jpg',
      isReadingList: false,
      interactionScore: 0,
    ),
    const Book(
      id: 7,
      name: 'Moby Dick',
      authors: 'Herman Melville',
      authorsList: ['Herman Melville'],
      pages: 654,
      publisher: 'Harper & Brothers',
      reviews: 432,
      publishYear: 1851,
      rating: 4.0,
      isbn: '9626343583',
      description: 'Moby-Dick; or, The Whale is an 1851 novel by American writer Herman Melville. The book is sailor Ishmael\'s narrative of the obsessive quest of Ahab, captain of the whaling ship Pequod, for revenge on Moby Dick, the giant white sperm whale.',
      coverUrl: 'Moby_Dick_9626343583.jpg',
      isReadingList: false,
      interactionScore: 0,
    ),
    const Book(
      id: 8,
      name: 'Agile Web Development with Rails',
      authors: 'Dave Thomas',
      authorsList: ['Dave Thomas'],
      pages: 540,
      publisher: 'Pragmatic Bookshelf',
      reviews: 150,
      publishYear: 2005,
      rating: 4.5,
      isbn: '097669400X',
      description: 'Rails is a full-stack, open-source web framework that enables you to build full-featured, database-backed web applications. This book is the official guide to learning Rails and building robust, real-world web systems.',
      coverUrl: 'Agile_Web_Development_with_Rails_A_Pragmatic_Guide_097669400X.jpg',
      isReadingList: false,
      interactionScore: 0,
    ),
    const Book(
      id: 9,
      name: 'Deception Point',
      authors: 'Dan Brown',
      authorsList: ['Dan Brown'],
      pages: 556,
      publisher: 'Pocket Books',
      reviews: 320,
      publishYear: 2001,
      rating: 3.9,
      isbn: '1416524800',
      description: 'When a new NASA satellite detects evidence of an astonishingly rare object buried deep in the Arctic ice, the floundering space agency proclaims a much-needed victory... a victory that has profound implications for U.S. space policy.',
      coverUrl: 'Deception_Point_1416524800.jpg',
      isReadingList: false,
      interactionScore: 0,
    ),
    const Book(
      id: 10,
      name: '1000 Families',
      authors: 'Uwe Ommer',
      authorsList: ['Uwe Ommer'],
      pages: 520,
      publisher: 'Taschen',
      reviews: 88,
      publishYear: 2000,
      rating: 4.2,
      isbn: '3822822647',
      description: 'Over the course of four years, photographer Uwe Ommer traveled across all five continents to document families in all their diversity. 1,000 families from all walks of life were photographed and interviewed.',
      coverUrl: '1000_Families_3822822647.jpg',
      isReadingList: false,
      interactionScore: 0,
    ),
  ];

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
    if (kMockDemoMode) {
      Iterable<Book> list = _mockBooks;
      if (readingList != null && readingList) {
        list = list.where((b) => b.isReadingList);
      }
      if (publisher != null && publisher.isNotEmpty) {
        list = list.where((b) => b.publisher.toLowerCase() == publisher.toLowerCase());
      }
      if (search != null && search.trim().isNotEmpty) {
        final query = search.toLowerCase();
        if (semantic != null && semantic) {
          list = list.map((b) {
            double sim = 0.05;
            final text = '${b.name} ${b.authors} ${b.description}'.toLowerCase();
            final words = query.split(RegExp(r'\s+'));
            int matches = 0;
            for (final word in words) {
              if (text.contains(word)) matches++;
            }
            if (matches > 0) {
              sim = 0.5 + (matches / words.length) * 0.45;
            }
            if ((query.contains('mystery') || query.contains('thriller') || query.contains('code') || query.contains('assassin')) &&
                (b.name.contains('Code') || b.name.contains('Demons') || b.name.contains('Deception'))) {
              sim = 0.92;
            } else if ((query.contains('magic') || query.contains('wizard') || query.contains('potter') || query.contains('hogwarts')) &&
                b.name.contains('Potter')) {
              sim = 0.95;
            } else if ((query.contains('rails') || query.contains('web') || query.contains('code') || query.contains('program')) &&
                b.name.contains('Rails')) {
              sim = 0.88;
            } else if ((query.contains('spiritual') || query.contains('india') || query.contains('buddha') || query.contains('journey')) &&
                b.name.contains('Siddhartha')) {
              sim = 0.91;
            } else if ((query.contains('fire') || query.contains('burn') || query.contains('book') || query.contains('censor')) &&
                b.name.contains('Fahrenheit')) {
              sim = 0.93;
            }
            return b.copyWith(similarity: sim);
          });
          final sortedList = list.toList();
          sortedList.sort((a, b) => (b.similarity ?? 0.0).compareTo(a.similarity ?? 0.0));
          return sortedList.take(limit).toList();
        } else {
          list = list.where((b) {
            return b.name.toLowerCase().contains(query) ||
                b.authors.toLowerCase().contains(query) ||
                (b.description?.toLowerCase().contains(query) ?? false);
          });
        }
      }
      return list.skip(offset).take(limit).toList();
    }

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
    if (kMockDemoMode) {
      try {
        return _mockBooks.firstWhere(
          (b) => b.isbn == isbn || b.id.toString() == isbn,
        );
      } catch (_) {
        return null;
      }
    }
    final response = await _dio.get('/api/v1/books/$isbn');
    if (response.statusCode == 200) {
      return Book.fromJson(response.data);
    }
    return null;
  }

  Future<List<Book>> searchSemantic(String query, {int limit = 50}) async {
    if (kMockDemoMode) {
      return getBooks(search: query, semantic: true, limit: limit);
    }
    final response = await _dio.get(
      '/api/v1/books/search/semantic',
      queryParameters: {'query': query, 'limit': limit},
    );
    final List data = response.data;
    return data.map((e) => Book.fromJson(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getPublishers() async {
    if (kMockDemoMode) {
      final Map<String, int> counts = {};
      for (final b in _mockBooks) {
        counts[b.publisher] = (counts[b.publisher] ?? 0) + 1;
      }
      return counts.entries
          .map((e) => {'name': e.key, 'count': e.value})
          .toList();
    }
    final response = await _dio.get('/publishers');
    final List data = response.data;
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getConfig() async {
    if (kMockDemoMode) {
      final publishers = _mockBooks.map((b) => b.publisher).toSet();
      return {
        'total_books': _mockBooks.length,
        'total_publishers': publishers.length,
        'db_active': true,
      };
    }
    final response = await _dio.get('/config');
    return response.data as Map<String, dynamic>;
  }

  Future<void> interact(int bookId, int score) async {
    if (kMockDemoMode) {
      final idx = _mockBooks.indexWhere((b) => b.id == bookId);
      if (idx != -1) {
        _mockBooks[idx] = _mockBooks[idx].copyWith(interactionScore: score);
      }
      return;
    }
    await _dio.post('/books/$bookId/interact', data: {'score': score});
  }

  Future<void> toggleReadingList(int bookId, bool currentStatus) async {
    if (kMockDemoMode) {
      final idx = _mockBooks.indexWhere((b) => b.id == bookId);
      if (idx != -1) {
        _mockBooks[idx] = _mockBooks[idx].copyWith(isReadingList: !currentStatus);
      }
      return;
    }
    final action = currentStatus ? 'remove' : 'add';
    await _dio.post('/books/$bookId/reading-list', data: {'action': action});
  }

  Future<List<Book>> getReadingList() async {
    if (kMockDemoMode) {
      return _mockBooks.where((b) => b.isReadingList).toList();
    }
    final response = await _dio.get('/reading-list');
    final List data = response.data;
    return data.map((e) => Book.fromJson(e)).toList();
  }
}

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return BookRepository(ref.watch(dioProvider));
}
