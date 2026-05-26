// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookImpl _$$BookImplFromJson(Map<String, dynamic> json) => _$BookImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      authors: json['authors'] as String? ?? '',
      authorsList: (json['authors_list'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      publisher: json['publisher'] as String? ?? '',
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      publishYear: (json['publish_year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isbn: json['isbn'] as String?,
      description: json['description'] as String?,
      coverUrl: json['cover_url'] as String?,
      coverLocalPath: json['cover_local_path'] as String?,
      googleBooksId: json['google_books_id'] as String?,
      isReadingList: json['is_reading_list'] as bool? ?? false,
      interactionScore: (json['interaction_score'] as num?)?.toInt() ?? 0,
      similarity: (json['similarity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$BookImplToJson(_$BookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'authors': instance.authors,
      'authors_list': instance.authorsList,
      'pages': instance.pages,
      'publisher': instance.publisher,
      'reviews': instance.reviews,
      'publish_year': instance.publishYear,
      'rating': instance.rating,
      'isbn': instance.isbn,
      'description': instance.description,
      'cover_url': instance.coverUrl,
      'cover_local_path': instance.coverLocalPath,
      'google_books_id': instance.googleBooksId,
      'is_reading_list': instance.isReadingList,
      'interaction_score': instance.interactionScore,
      'similarity': instance.similarity,
    };
