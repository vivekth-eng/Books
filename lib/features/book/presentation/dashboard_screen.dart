import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libri_stack/features/auth/presentation/providers/auth_provider.dart';
import 'package:libri_stack/features/book/presentation/book_providers.dart';
import 'package:libri_stack/features/book/presentation/widgets/book_card.dart';
import 'package:libri_stack/core/providers/core_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _searchController = TextEditingController();
  bool _isSyncing = false;
  String _syncStatusText = 'Idle';

  @override
  void initState() {
    super.initState();
    // Periodically poll sync status while active to reflect backend ingestion progress
    _checkSyncStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkSyncStatus() async {
    if (!mounted) return;
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/sync/status');
      final status = response.data['status'] ?? 'idle';
      
      setState(() {
        _syncStatusText = status.toUpperCase();
        _isSyncing = (status == 'ingesting' || status == 'vectorizing' || status == 'enriching');
      });

      // Poll every 3 seconds if active
      if (_isSyncing) {
        Future.delayed(const Duration(seconds: 3), _checkSyncStatus);
      }
    } catch (_) {
      // Graceful error ignore
    }
  }

  Future<void> _triggerSync() async {
    if (_isSyncing) return;
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/sync/trigger');
      setState(() {
        _isSyncing = true;
        _syncStatusText = 'INGESTING';
      });
      Future.delayed(const Duration(seconds: 2), _checkSyncStatus);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed to trigger: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final booksAsync = ref.watch(bookListProvider);
    final publishersAsync = ref.watch(publishersListProvider);
    
    final searchMode = ref.watch(semanticModeProvider);
    final selectedPub = ref.watch(selectedPublisherProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0D12),
      body: Row(
        children: [
          // 1. Sleek Sidebar Filters & Sync Controls
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border(right: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header brand title
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book, color: Colors.blueAccent, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'LibriStack',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white.withOpacity(0.05)),
                
                // User Profile & Logout section
                if (authState.user != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent.withOpacity(0.15),
                          radius: 18,
                          child: Text(
                            authState.user!.email[0].toUpperCase(),
                            style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authState.user!.fullName ?? 'Local User',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                authState.user!.email,
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                          icon: const Icon(Icons.logout_rounded, color: Colors.white38, size: 18),
                          tooltip: 'Logout',
                        )
                      ],
                    ),
                  ),
                Divider(color: Colors.white.withOpacity(0.05)),

                // Ingestion & Sync Pipeline section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DATABASE PIPELINE',
                        style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Ingestion status:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text(
                                _syncStatusText,
                                style: TextStyle(
                                  color: _isSyncing ? Colors.amberAccent : Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: _isSyncing ? null : _triggerSync,
                            icon: Icon(
                              _isSyncing ? Icons.sync : Icons.refresh_rounded,
                              color: _isSyncing ? Colors.amberAccent : Colors.blueAccent,
                              size: 20,
                            ),
                            tooltip: 'Trigger Spreadsheet Sync',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white.withOpacity(0.05)),

                // Publisher List filters
                Expanded(
                  child: publishersAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('Failed to load publishers', style: TextStyle(color: Colors.white38)),
                    ),
                    data: (publishers) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        children: [
                          Text(
                            'FILTER BY PUBLISHER',
                            style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              ChoiceChip(
                                label: const Text('All'),
                                selected: selectedPub == null,
                                onSelected: (_) => ref.read(selectedPublisherProvider.notifier).setPublisher(null),
                                selectedColor: Colors.blueAccent.withOpacity(0.3),
                                backgroundColor: Colors.transparent,
                                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              ...publishers.take(15).map((p) {
                                final name = p['name'] as String;
                                final isSelected = selectedPub == name;
                                return ChoiceChip(
                                  label: Text(name),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    ref.read(selectedPublisherProvider.notifier).setPublisher(selected ? name : null);
                                  },
                                  selectedColor: Colors.blueAccent.withOpacity(0.3),
                                  backgroundColor: Colors.transparent,
                                  labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                                );
                              }),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // 2. Main Content Grid View
          Expanded(
            child: Column(
              children: [
                // Top Search Bar Panel
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 20),
                  child: Row(
                    children: [
                      // Search box
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: searchMode ? 'Type description keywords to Search Semantically...' : 'Search by Book Name, Authors...',
                            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                            prefixIcon: Icon(searchMode ? Icons.psychology : Icons.search, color: Colors.blueAccent),
                            suffixIcon: _searchController.text.isNotEmpty 
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.white54),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(searchQueryProvider.notifier).setQuery('');
                                  },
                                )
                              : null,
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (val) {
                            // Instant reactive filter
                            ref.read(searchQueryProvider.notifier).setQuery(val);
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Semantic Toggle Chip
                      FilterChip(
                        avatar: Icon(Icons.psychology, color: searchMode ? Colors.white : Colors.grey),
                        label: const Text('Semantic Search'),
                        selected: searchMode,
                        onSelected: (_) => ref.read(semanticModeProvider.notifier).toggle(),
                        selectedColor: Colors.blueAccent.withOpacity(0.8),
                        backgroundColor: Colors.black.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: searchMode ? Colors.white : Colors.grey.shade400,
                          fontWeight: searchMode ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Books Grid area
                Expanded(
                  child: booksAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Text(
                        'Connection Error: $err',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    data: (books) {
                      // Non-Zero UI Guard
                      if (books.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off_rounded, size: 64, color: Colors.white24),
                              const SizedBox(height: 16),
                              Text(
                                'No Books Found',
                                style: GoogleFonts.outfit(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Check your search filters, or click the refresh button\nin the sidebar to trigger database ingestion.',
                                style: TextStyle(color: Colors.white38),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, idx) {
                          final book = books[idx];
                          return BookCard(book: book);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
