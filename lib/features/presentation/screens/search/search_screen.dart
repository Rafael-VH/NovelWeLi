import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:novel_we_li/core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_filter_sheet.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/popular_searches_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_results_widget.dart';
import './widgets/skeleton_loading_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _debounceTimer;
  bool _isSearching = false;
  bool _isRecording = false;
  bool _hasMore = true;
  int _currentPage = 1;
  List<String> _recentSearches = ['Solo Leveling', 'Overlord', 'Re:Zero', 'Sword Art Online', 'That Time I Got Reincarnated as a Slime'];
  List<Map<String, dynamic>> _activeFilters = [];
  Map<String, dynamic> _currentFilters = {};
  List<Map<String, dynamic>> _searchResults = [];
  // Mock data for popular searches
  final List<Map<String, dynamic>> _popularSearches = [
    {
      'title': 'Solo Leveling',
      'author': 'Chugong',
      'image': 'https://images.unsplash.com/photo-1664203691516-5107fb7cd458',
      'semanticLabel': 'Dark fantasy book cover with glowing blue magical effects and mysterious warrior silhouette',
    },
    {
      'title': 'Overlord',
      'author': 'Kugane Maruyama',
      'image': 'https://images.unsplash.com/photo-1448071440788-6c17eabc7b0f',
      'semanticLabel': 'Medieval fantasy book with ornate golden armor and dark atmospheric background',
    },
    {
      'title': 'Re:Zero',
      'author': 'Tappei Nagatsuki',
      'image': 'https://images.unsplash.com/photo-1647929369347-6282340b846e',
      'semanticLabel': 'Anime-style illustration with blue and white magical energy swirls and fantasy elements',
    },
    {
      'title': 'Sword Art Online',
      'author': 'Reki Kawahara',
      'image': 'https://images.unsplash.com/photo-1681912818492-35c55f33fb25',
      'semanticLabel': 'Futuristic gaming setup with neon blue lights and virtual reality elements',
    },
  ];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isSearching && _hasMore && _searchResults.isNotEmpty) {
        _loadMoreResults();
      }
    }
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    if (_searchController.text.length >= 2) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _performSearch(_searchController.text);
      });
    } else if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults.clear();
        _currentPage = 1;
        _hasMore = true;
      });
    }
  }

  Future<void> _performSearch(String query, {bool isNewSearch = true}) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isSearching = true;
      if (isNewSearch) {
        _searchResults.clear();
        _currentPage = 1;
        _hasMore = true;
      }
    });
    try {
      // Add to recent searches
      if (!_recentSearches.contains(query)) {
        setState(() {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        });
      }
      // Simulate API call with mock data
      await Future.delayed(const Duration(milliseconds: 800));
      final mockResults = _generateMockResults(query, _currentPage);
      setState(() {
        if (isNewSearch) {
          _searchResults = mockResults;
        } else {
          _searchResults.addAll(mockResults);
        }
        _hasMore = mockResults.length == 10;
        // Assume 10 items per page
        _currentPage++;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      _showErrorToast('Error al buscar novelas');
    }
  }

  List<Map<String, dynamic>> _generateMockResults(String query, int page) {
    final baseResults = [
      {
        'id': 1,
        'title': 'Solo Leveling: Arise from the Shadow',
        'author': 'Chugong',
        'cover': 'https://images.unsplash.com/photo-1664203691516-5107fb7cd458',
        'semanticLabel': 'Dark fantasy book cover with glowing blue magical effects and mysterious warrior silhouette',
        'rating': 4.8,
        'chapters': 270,
        'genres': ['Acción', 'Fantasía', 'Aventura'],
        'status': 'Completado',
      },
      {
        'id': 2,
        'title': 'Overlord: The Undead King',
        'author': 'Kugane Maruyama',
        'cover': 'https://images.unsplash.com/photo-1448071440788-6c17eabc7b0f',
        'semanticLabel': 'Medieval fantasy book with ornate golden armor and dark atmospheric background',
        'rating': 4.6,
        'chapters': 180,
        'genres': ['Fantasía', 'Drama', 'Acción'],
        'status': 'En curso',
      },
      {
        'id': 3,
        'title': 'Re:Zero - Starting Life in Another World',
        'author': 'Tappei Nagatsuki',
        'cover': 'https://images.unsplash.com/photo-1647929369347-6282340b846e',
        'semanticLabel': 'Anime-style illustration with blue and white magical energy swirls and fantasy elements',
        'rating': 4.7,
        'chapters': 220,
        'genres': ['Drama', 'Romance', 'Fantasía'],
        'status': 'En curso',
      },
      {
        'id': 4,
        'title': 'Sword Art Online: Progressive',
        'author': 'Reki Kawahara',
        'cover': 'https://images.unsplash.com/photo-1681912818492-35c55f33fb25',
        'semanticLabel': 'Futuristic gaming setup with neon blue lights and virtual reality elements',
        'rating': 4.4,
        'chapters': 150,
        'genres': ['Ciencia Ficción', 'Romance', 'Acción'],
        'status': 'En curso',
      },
      {
        'id': 5,
        'title': 'That Time I Got Reincarnated as a Slime',
        'author': 'Fuse',
        'cover': 'https://images.unsplash.com/photo-1678627841903-f5a585590c6a',
        'semanticLabel': 'Colorful fantasy landscape with magical creatures and bright blue slime character',
        'rating': 4.5,
        'chapters': 190,
        'genres': ['Comedia', 'Fantasía', 'Aventura'],
        'status': 'En curso',
      },
    ];
    // Filter results based on query and current filters
    List<Map<String, dynamic>> filteredResults = baseResults.where((novel) {
      final title = (novel['title'] as String).toLowerCase();
      final author = (novel['author'] as String).toLowerCase();
      final searchQuery = query.toLowerCase();
      bool matchesQuery = title.contains(searchQuery) || author.contains(searchQuery);
      // Apply filters
      if (_currentFilters.isNotEmpty) {
        if (_currentFilters.containsKey('genres')) {
          final selectedGenres = _currentFilters['genres'] as List<String>;
          final novelGenres = novel['genres'] as List<String>;
          matchesQuery = matchesQuery && selectedGenres.any((genre) => novelGenres.contains(genre));
        }
        if (_currentFilters.containsKey('status')) {
          matchesQuery = matchesQuery && novel['status'] == _currentFilters['status'];
        }
        if (_currentFilters.containsKey('minRating')) {
          matchesQuery = matchesQuery && (novel['rating'] as double) >= (_currentFilters['minRating'] as double);
        }
      }
      return matchesQuery;
    }).toList();
    // Simulate pagination
    final startIndex = (page - 1) * 10;
    final endIndex = startIndex + 10;
    if (startIndex >= filteredResults.length) return [];
    return filteredResults.sublist(startIndex, endIndex > filteredResults.length ? filteredResults.length : endIndex);
  }

  void _loadMoreResults() {
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text, isNewSearch: false);
    }
  }

  Future<void> _startVoiceSearch() async {
    if (_isRecording) {
      await _stopVoiceSearch();
      return;
    }
    try {
      bool hasPermission = false;
      if (kIsWeb) {
        hasPermission = true;
        // Browser handles permissions
      } else {
        final status = await Permission.microphone.request();
        hasPermission = status.isGranted;
      }
      if (!hasPermission) {
        _showErrorToast('Permiso de micrófono requerido');
        return;
      }
      setState(() {
        _isRecording = true;
      });
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(const RecordConfig(), path: 'voice_search.m4a');
        _showToast('Grabando... Toca de nuevo para detener');
        // Auto-stop after 10 seconds
        Timer(const Duration(seconds: 10), () {
          if (_isRecording) {
            _stopVoiceSearch();
          }
        });
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorToast('Error al iniciar grabación');
    }
  }

  Future<void> _stopVoiceSearch() async {
    if (!_isRecording) return;
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      if (path != null) {
        // Simulate voice recognition
        await Future.delayed(const Duration(milliseconds: 1000));
        // Mock voice recognition result
        final mockTranscription = 'Solo Leveling';
        _searchController.text = mockTranscription;
        _performSearch(mockTranscription);
        _showToast('Búsqueda por voz: "$mockTranscription"');
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorToast('Error al procesar audio');
    }
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => AdvancedFilterSheet(currentFilters: _currentFilters, onFiltersApplied: _applyFilters),
      ),
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _activeFilters = _buildActiveFiltersList(filters);
    });
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
    HapticFeedback.lightImpact();
  }

  List<Map<String, dynamic>> _buildActiveFiltersList(Map<String, dynamic> filters) {
    List<Map<String, dynamic>> activeFilters = [];
    filters.forEach((key, value) {
      if (key == 'genres' && value is List<String> && value.isNotEmpty) {
        for (String genre in value) {
          activeFilters.add({'key': 'genre_$genre', 'label': genre, 'count': null});
        }
      } else if (key == 'status' && value != null) {
        activeFilters.add({'key': 'status', 'label': 'Estado: $value', 'count': null});
      } else if (key == 'minRating' && value != null) {
        activeFilters.add({'key': 'minRating', 'label': 'Min. ${value.toStringAsFixed(1)}★', 'count': null});
      } else if (key == 'language' && value != null) {
        activeFilters.add({'key': 'language', 'label': 'Idioma: $value', 'count': null});
      } else if (key == 'updateFrequency' && value != null) {
        activeFilters.add({'key': 'updateFrequency', 'label': 'Actualización: $value', 'count': null});
      }
    });
    return activeFilters;
  }

  void _removeFilter(String filterKey) {
    setState(() {
      if (filterKey.startsWith('genre_')) {
        final genre = filterKey.substring(6);
        if (_currentFilters.containsKey('genres')) {
          (_currentFilters['genres'] as List<String>).remove(genre);
          if ((_currentFilters['genres'] as List<String>).isEmpty) {
            _currentFilters.remove('genres');
          }
        }
      } else {
        _currentFilters.remove(filterKey);
      }
      _activeFilters = _buildActiveFiltersList(_currentFilters);
    });
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters.clear();
      _activeFilters.clear();
    });
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
    _showToast('Historial de búsqueda limpiado');
  }

  void _onRecentSearchTapped(String search) {
    _searchController.text = search;
    _performSearch(search);
  }

  void _onPopularSearchTapped(String search) {
    _searchController.text = search;
    _performSearch(search);
  }

  void _onNovelTapped(Map<String, dynamic> novel) {
    Navigator.pushNamed(context, '/novel-detail-screen', arguments: novel);
  }

  void _onAddToLibrary(Map<String, dynamic> novel) {
    _showToast('${novel['title']} añadido a la biblioteca');
    HapticFeedback.lightImpact();
  }

  void _onDownload(Map<String, dynamic> novel) {
    _showToast('Descargando ${novel['title']}...');
    HapticFeedback.lightImpact();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      textColor: Theme.of(context).colorScheme.onInverseSurface,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                // Handled by listener
              },
              onVoicePressed: _startVoiceSearch,
              onClearPressed: () {
                setState(() {
                  _searchResults.clear();
                  _currentPage = 1;
                  _hasMore = true;
                });
              },
            ),
            // Advanced filters button
            if (_searchController.text.isNotEmpty || _activeFilters.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _showAdvancedFilters,
                      icon: CustomIconWidget(iconName: 'tune', color: colorScheme.primary, size: 18),
                      label: Text('Filtros avanzados', style: theme.textTheme.labelMedium),
                    ),
                    const Spacer(),
                    if (_searchResults.isNotEmpty) Text('${_searchResults.length} resultados', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7))),
                  ],
                ),
              ),
            // Active filters
            FilterChipsWidget(activeFilters: _activeFilters, onFilterRemoved: _removeFilter, onClearAll: _clearAllFilters),

            // Content
            Expanded(child: _searchController.text.isEmpty ? _buildEmptySearchState() : _buildSearchResults()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2,
        items: [],
        // Search tab
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          // Recent searches
          RecentSearchesWidget(recentSearches: _recentSearches, onSearchTapped: _onRecentSearchTapped, onClearHistory: _clearRecentSearches),
          // Popular searches
          PopularSearchesWidget(popularSearches: _popularSearches, onSearchTapped: _onPopularSearchTapped),
          // Search suggestions
          _buildSearchSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          if (_isSearching && _searchResults.isEmpty)
            const SkeletonLoadingWidget()
          else
            SearchResultsWidget(
              searchResults: _searchResults,
              isLoading: _isSearching,
              hasMore: _hasMore,
              onLoadMore: _loadMoreResults,
              onNovelTapped: _onNovelTapped,
              onAddToLibrary: _onAddToLibrary,
              onDownload: _onDownload,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final suggestions = ['Novelas de fantasía', 'Romance moderno', 'Acción y aventura', 'Ciencia ficción', 'Misterio y suspense'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categorías populares', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: suggestions.map((suggestion) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = suggestion;
                  _performSearch(suggestion);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(iconName: 'category', color: colorScheme.onPrimaryContainer, size: 16),
                      SizedBox(width: 2.w),
                      Text(
                        suggestion,
                        style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
