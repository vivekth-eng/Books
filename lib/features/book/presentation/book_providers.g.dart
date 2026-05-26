// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publishersListHash() => r'714fb680e10805a11e709dd105abf1d0c18a101a';

/// See also [publishersList].
@ProviderFor(publishersList)
final publishersListProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  publishersList,
  name: r'publishersListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$publishersListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PublishersListRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$searchQueryHash() => r'0bcdb7b716d24a9fc2ff883805b98eec70434183';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$semanticModeHash() => r'e10b38a3c4b8d612115490d50ff1fe02efed097f';

/// See also [SemanticMode].
@ProviderFor(SemanticMode)
final semanticModeProvider =
    AutoDisposeNotifierProvider<SemanticMode, bool>.internal(
  SemanticMode.new,
  name: r'semanticModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$semanticModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SemanticMode = AutoDisposeNotifier<bool>;
String _$selectedPublisherHash() => r'18a606b271ec7317507a1edb77a6731612517825';

/// See also [SelectedPublisher].
@ProviderFor(SelectedPublisher)
final selectedPublisherProvider =
    AutoDisposeNotifierProvider<SelectedPublisher, String?>.internal(
  SelectedPublisher.new,
  name: r'selectedPublisherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedPublisherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedPublisher = AutoDisposeNotifier<String?>;
String _$bookListHash() => r'c196ca043dd3a3b54ac01e9f3af1a8f818948da0';

/// See also [BookList].
@ProviderFor(BookList)
final bookListProvider =
    AutoDisposeAsyncNotifierProvider<BookList, List<Book>>.internal(
  BookList.new,
  name: r'bookListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookList = AutoDisposeAsyncNotifier<List<Book>>;
String _$readingListNotifierHash() =>
    r'28d0bc4a265c8aebdc72b6b56f56699dc302d1ed';

/// See also [ReadingListNotifier].
@ProviderFor(ReadingListNotifier)
final readingListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReadingListNotifier, List<Book>>.internal(
  ReadingListNotifier.new,
  name: r'readingListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readingListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReadingListNotifier = AutoDisposeAsyncNotifier<List<Book>>;
String _$bookDetailsNotifierHash() =>
    r'61ba7194c9f6c36499650b9deb7fa23f8fc44859';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$BookDetailsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Book?> {
  late final String isbn;

  FutureOr<Book?> build(
    String isbn,
  );
}

/// See also [BookDetailsNotifier].
@ProviderFor(BookDetailsNotifier)
const bookDetailsNotifierProvider = BookDetailsNotifierFamily();

/// See also [BookDetailsNotifier].
class BookDetailsNotifierFamily extends Family<AsyncValue<Book?>> {
  /// See also [BookDetailsNotifier].
  const BookDetailsNotifierFamily();

  /// See also [BookDetailsNotifier].
  BookDetailsNotifierProvider call(
    String isbn,
  ) {
    return BookDetailsNotifierProvider(
      isbn,
    );
  }

  @override
  BookDetailsNotifierProvider getProviderOverride(
    covariant BookDetailsNotifierProvider provider,
  ) {
    return call(
      provider.isbn,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookDetailsNotifierProvider';
}

/// See also [BookDetailsNotifier].
class BookDetailsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BookDetailsNotifier, Book?> {
  /// See also [BookDetailsNotifier].
  BookDetailsNotifierProvider(
    String isbn,
  ) : this._internal(
          () => BookDetailsNotifier()..isbn = isbn,
          from: bookDetailsNotifierProvider,
          name: r'bookDetailsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookDetailsNotifierHash,
          dependencies: BookDetailsNotifierFamily._dependencies,
          allTransitiveDependencies:
              BookDetailsNotifierFamily._allTransitiveDependencies,
          isbn: isbn,
        );

  BookDetailsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isbn,
  }) : super.internal();

  final String isbn;

  @override
  FutureOr<Book?> runNotifierBuild(
    covariant BookDetailsNotifier notifier,
  ) {
    return notifier.build(
      isbn,
    );
  }

  @override
  Override overrideWith(BookDetailsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookDetailsNotifierProvider._internal(
        () => create()..isbn = isbn,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isbn: isbn,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BookDetailsNotifier, Book?>
      createElement() {
    return _BookDetailsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookDetailsNotifierProvider && other.isbn == isbn;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isbn.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookDetailsNotifierRef on AutoDisposeAsyncNotifierProviderRef<Book?> {
  /// The parameter `isbn` of this provider.
  String get isbn;
}

class _BookDetailsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BookDetailsNotifier, Book?>
    with BookDetailsNotifierRef {
  _BookDetailsNotifierProviderElement(super.provider);

  @override
  String get isbn => (origin as BookDetailsNotifierProvider).isbn;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
