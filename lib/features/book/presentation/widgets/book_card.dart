import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libri_stack/features/book/domain/models/book.dart';
import 'package:libri_stack/features/book/presentation/book_details_dialog.dart';

class BookCard extends ConsumerWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color flagColor = Colors.transparent;
    IconData? flagIcon;
    if (book.interactionScore == 1) {
      flagColor = Colors.amber;
      flagIcon = Icons.chrome_reader_mode_outlined;
    } else if (book.interactionScore == 2) {
      flagColor = Colors.green;
      flagIcon = Icons.check_circle_outline_rounded;
    } else if (book.interactionScore == 3) {
      flagColor = Colors.redAccent;
      flagIcon = Icons.favorite_rounded;
    }

    final coverName = book.coverName;
    final hasCover = coverName != null && 
        coverName.isNotEmpty && 
        coverName.toLowerCase() != 'null';

    return Card(
      color: const Color(0xFF14161E),
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.06)),
      ),
      child: InkWell(
        onTap: () {
          final isbn = book.isbn;
          if (isbn != null && isbn.isNotEmpty) {
            showDialog(
              context: context,
              builder: (_) => BookDetailsDialog(isbn: isbn),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ISBN not found for this book')),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top of Card Layout: Cover Stack taking remaining height footprint
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'cover_${book.id}',
                    child: hasCover
                        ? Image.network(
                            book.fullCoverPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildFallbackCard(context),
                          )
                        : _buildFallbackCard(context),
                  ),
                  // Reading List Indicator (Top Right Bookmark)
                  if (book.isReadingList)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.bookmark, color: Colors.white, size: 14),
                      ),
                    ),
                  // Status Flag Chip (Bottom Left)
                  if (flagColor != Colors.transparent)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: flagColor.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(flagIcon, color: Colors.white, size: 11),
                            const SizedBox(width: 4),
                            Text(
                              book.interactionScore == 1 
                                ? 'Reading' 
                                : book.interactionScore == 2 
                                  ? 'Done' 
                                  : 'Fav',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Bottom of Card Layout: Flexible Metadata Block with structural spacing safety
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        book.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        book.authors.isNotEmpty ? book.authors : 'Author Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (book.rating > 0)
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                book.rating.toStringAsFixed(1),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        else
                          const SizedBox(),
                        Text(
                          book.publishYear > 0 ? '${book.publishYear}' : '',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackCard(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E2638),
            Color(0xFF0D111A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.03),
          ),
          Text(
            book.name.isNotEmpty ? book.name[0].toUpperCase() : '?',
            style: GoogleFonts.outfit(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent.withOpacity(0.4),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
