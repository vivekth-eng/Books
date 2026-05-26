import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libri_stack/features/book/domain/models/book.dart';
import 'package:libri_stack/features/book/presentation/book_providers.dart';

class BookDetailsDialog extends ConsumerWidget {
  final String isbn;

  const BookDetailsDialog({super.key, required this.isbn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(bookDetailsNotifierProvider(isbn));
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 16,
        vertical: 32,
      ),
      child: Card(
        color: const Color(0xFF0A0C10).withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 760,
          constraints: BoxConstraints(maxHeight: size.height * 0.85),
          child: detailsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Text(
                'Error: $err',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            data: (book) {
              if (book == null) {
                return const Center(child: Text('Book details not found'));
              }
              return Column(
                children: [
                  // Header Bar
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: const CloseButton(color: Colors.white),
                    title: Text(
                      'Book Details',
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Local Cover Image
                              Hero(
                                tag: 'cover_${book.id}',
                                child: Container(
                                  width: isDesktop ? 180 : 110,
                                  height: isDesktop ? 260 : 165,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: book.coverUrl != null && book.coverUrl!.isNotEmpty
                                      ? Image.network(
                                          book.fullCoverPath,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => _buildFallbackCard(book),
                                        )
                                      : _buildFallbackCard(book),
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Core details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.name,
                                      style: GoogleFonts.outfit(
                                        fontSize: isDesktop ? 26 : 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      book.authors.isNotEmpty ? 'by ${book.authors}' : 'Author unknown',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        if (book.rating > 0) ...[
                                          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                                          const SizedBox(width: 4),
                                          Text(
                                            book.rating.toStringAsFixed(2),
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                        ],
                                        const Icon(Icons.pages_outlined, color: Colors.blueAccent, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${book.pages} pgs',
                                          style: GoogleFonts.outfit(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    // Reading List Toggle
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await ref
                                            .read(bookDetailsNotifierProvider(isbn).notifier)
                                            .toggleReadingList(book);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: book.isReadingList
                                            ? Colors.white12
                                            : Colors.blueAccent.withOpacity(0.9),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        minimumSize: const Size(180, 44),
                                      ),
                                      icon: Icon(
                                        book.isReadingList ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                                      ),
                                      label: Text(
                                        book.isReadingList ? 'In Reading List' : 'Add to Reading List',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Interaction chip selection
                          Text(
                            'Reading Progress & Flags',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildInteractionChip(ref, book, 0, 'None', Icons.circle_outlined, Colors.grey),
                              _buildInteractionChip(ref, book, 1, 'Reading', Icons.chrome_reader_mode_outlined, Colors.amber),
                              _buildInteractionChip(ref, book, 2, 'Completed', Icons.check_circle_outline_rounded, Colors.green),
                              _buildInteractionChip(ref, book, 3, 'Favorite', Icons.favorite_border_rounded, Colors.redAccent),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Description Plot
                          if (book.description != null && book.description!.isNotEmpty) ...[
                            Text(
                              'Description / Plot Summary',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              book.description!,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                color: Colors.grey.shade300,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Meta Row
                          Divider(color: Colors.white.withOpacity(0.08)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMetaItem('Publisher', book.publisher.isEmpty ? 'N/A' : book.publisher),
                              _buildMetaItem('Published Year', book.publishYear > 0 ? '${book.publishYear}' : 'N/A'),
                              _buildMetaItem('ISBN', book.isbn == null || book.isbn!.isEmpty ? 'N/A' : book.isbn!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionChip(
    WidgetRef ref, 
    Book book, 
    int score, 
    String label, 
    IconData icon, 
    Color color
  ) {
    final isSelected = book.interactionScore == score;
    return ChoiceChip(
      avatar: Icon(icon, color: isSelected ? Colors.white : color.withOpacity(0.8), size: 16),
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(bookDetailsNotifierProvider(isbn).notifier).rate(score);
        }
      },
      selectedColor: color.withOpacity(0.6),
      backgroundColor: Colors.white.withOpacity(0.04),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade400,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? color : Colors.white.withOpacity(0.05),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildFallbackCard(Book book) {
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
            size: 60,
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

  Widget _buildMetaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}
