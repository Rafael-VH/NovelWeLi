import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/core/themes/app_theme.dart';
import 'package:novel_we_li/features/presentation/screens/library/widgets/empty_state_widget.dart';
import 'package:novel_we_li/features/presentation/screens/library/widgets/filter_sort_bottom_sheet.dart';
import 'package:novel_we_li/features/presentation/screens/library/widgets/library_search_bar.dart';
import 'package:novel_we_li/features/presentation/screens/library/widgets/library_segment_control.dart';
import 'package:novel_we_li/features/presentation/screens/library/widgets/novel_card_widget.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_app_bar.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_bottom_bar.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with TickerProviderStateMixin {
  int _selectedSegment = 0;
  String _searchQuery = '';
  String _currentSort = 'recent';
  bool _isBatchSelectionMode = false;
  final Set<int> _selectedNovels = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock data for different library segments
  final List<Map<String, dynamic>> _readingNovels = [
    {
      "id": 1,
      "title": "El Señor de los Anillos: La Comunidad del Anillo",
      "author": "J.R.R. Tolkien",
      "coverUrl": "https://images.unsplash.com/photo-1490122999541-769c7954d1cf",
      "semanticLabel": "Portada del libro El Señor de los Anillos mostrando un anillo dorado sobre fondo oscuro con montañas",
      "progress": 0.65,
      "lastRead": "Hace 2 horas",
      "isDownloaded": true,
      "storageSize": "45 MB",
      "category": "Fantasía",
      "dateAdded": "2024-10-15",
    },
    {
      "id": 2,
      "title": "Cien Años de Soledad",
      "author": "Gabriel García Márquez",
      "coverUrl": "https://images.unsplash.com/photo-1697131927249-0f8e066ec43b",
      "semanticLabel": "Portada de libro clásico con diseño vintage en tonos amarillos y marrones",
      "progress": 0.32,
      "lastRead": "Ayer",
      "isDownloaded": false,
      "storageSize": "",
      "category": "Realismo Mágico",
      "dateAdded": "2024-10-20",
    },
    {
      "id": 3,
      "title": "Dune",
      "author": "Frank Herbert",
      "coverUrl": "https://images.unsplash.com/photo-1560301510-61ba9b4a6835",
      "semanticLabel": "Paisaje desértico con dunas de arena dorada bajo cielo azul, evocando el planeta Arrakis",
      "progress": 0.78,
      "lastRead": "Hace 3 días",
      "isDownloaded": true,
      "storageSize": "62 MB",
      "category": "Ciencia Ficción",
      "dateAdded": "2024-09-28",
    },
  ];
  final List<Map<String, dynamic>> _downloadedNovels = [
    {
      "id": 4,
      "title": "Harry Potter y la Piedra Filosofal",
      "author": "J.K. Rowling",
      "coverUrl": "https://images.unsplash.com/photo-1669759340120-45e670b4165b",
      "semanticLabel": "Libro mágico con elementos fantásticos y colores dorados representando el mundo de Harry Potter",
      "progress": 1.0,
      "lastRead": "Hace 1 semana",
      "isDownloaded": true,
      "storageSize": "38 MB",
      "category": "Fantasía",
      "dateAdded": "2024-09-15",
    },
    {
      "id": 5,
      "title": "1984",
      "author": "George Orwell",
      "coverUrl": "https://images.unsplash.com/photo-1526050071463-2c476b162a4c",
      "semanticLabel": "Portada de libro distópico con diseño minimalista en blanco y negro representando vigilancia",
      "progress": 0.45,
      "lastRead": "Hace 5 días",
      "isDownloaded": true,
      "storageSize": "28 MB",
      "category": "Distopía",
      "dateAdded": "2024-10-01",
    },
  ];
  final List<Map<String, dynamic>> _favoriteNovels = [
    {
      "id": 6,
      "title": "El Principito",
      "author": "Antoine de Saint-Exupéry",
      "coverUrl": "https://images.unsplash.com/photo-1676792381720-c8908e1cd723",
      "semanticLabel": "Ilustración infantil con un pequeño príncipe en un planeta pequeño con una rosa",
      "progress": 1.0,
      "lastRead": "Hace 2 semanas",
      "isDownloaded": false,
      "storageSize": "",
      "category": "Filosofía",
      "dateAdded": "2024-08-20",
    },
    {
      "id": 7,
      "title": "Orgullo y Prejuicio",
      "author": "Jane Austen",
      "coverUrl": "https://images.unsplash.com/photo-1564645320928-7b23d3eedf1a",
      "semanticLabel": "Portada elegante de novela romántica del siglo XIX con diseño clásico en tonos pastel",
      "progress": 0.89,
      "lastRead": "Hace 1 mes",
      "isDownloaded": true,
      "storageSize": "32 MB",
      "category": "Romance",
      "dateAdded": "2024-07-10",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentNovels {
    List<Map<String, dynamic>> novels;
    switch (_selectedSegment) {
      case 0:
        novels = _readingNovels;
        break;
      case 1:
        novels = _downloadedNovels;
        break;
      case 2:
        novels = _favoriteNovels;
        break;
      default:
        novels = _readingNovels;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      novels = novels.where((novel) {
        final title = (novel['title'] as String).toLowerCase();
        final author = (novel['author'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }

    // Apply sorting
    switch (_currentSort) {
      case 'alphabetical':
        novels.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'progress':
        novels.sort((a, b) => (b['progress'] as double).compareTo(a['progress'] as double));
        break;
      case 'date_added':
        novels.sort((a, b) => (b['dateAdded'] as String).compareTo(a['dateAdded'] as String));
        break;
      case 'recent':
      default:
        // Keep original order (most recent first)
        break;
    }

    return novels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Mi Biblioteca',
        variant: CustomAppBarVariant.standard,
        actions: [
          if (_isBatchSelectionMode) ...[
            TextButton(
              onPressed: _cancelBatchSelection,
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.primary, fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ] else ...[
            IconButton(
              icon: CustomIconWidget(iconName: 'tune', color: AppTheme.lightTheme.colorScheme.onSurface, size: 24),
              onPressed: _showFilterSortBottomSheet,
              tooltip: 'Filtros y ordenación',
            ),
            IconButton(
              icon: CustomIconWidget(iconName: 'select_all', color: AppTheme.lightTheme.colorScheme.onSurface, size: 24),
              onPressed: _enableBatchSelection,
              tooltip: 'Selección múltiple',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Segment Control
          LibrarySegmentControl(selectedIndex: _selectedSegment, onSegmentChanged: _onSegmentChanged),
          // Search Bar
          LibrarySearchBar(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            hintText: _getSearchHint(),
          ),
          // Batch Selection Info
          if (_isBatchSelectionMode)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedNovels.length} seleccionados',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppTheme.lightTheme.colorScheme.primary),
                  ),
                  if (_selectedNovels.isNotEmpty)
                    TextButton(
                      onPressed: _performBatchAction,
                      child: Text(
                        'Eliminar',
                        style: TextStyle(color: AppTheme.lightTheme.colorScheme.error, fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(opacity: _fadeAnimation, child: _buildContent());
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1, // Library tab

        variant: CustomBottomBarVariant.standard,
        items: [],
      ),
    );
  }

  Widget _buildContent() {
    final novels = _currentNovels;
    if (novels.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: novels.length,
      itemBuilder: (context, index) {
        final novel = novels[index];
        final novelId = novel['id'] as int;
        final isSelected = _selectedNovels.contains(novelId);
        return GestureDetector(
          onTap: _isBatchSelectionMode ? () => _toggleNovelSelection(novelId) : () => _onNovelTap(novel),
          child: Container(
            decoration: BoxDecoration(color: isSelected ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent),
            child: Stack(
              children: [
                NovelCardWidget(
                  novel: novel,
                  onTap: () => _onNovelTap(novel),
                  onContinueReading: () => _onContinueReading(novel),
                  onDownloadChapters: () => _onDownloadChapters(novel),
                  onRemoveFromLibrary: () => _onRemoveFromLibrary(novel),
                  onMarkCompleted: () => _onMarkCompleted(novel),
                  onChangeCategory: () => _onChangeCategory(novel),
                  onExport: () => _onExport(novel),
                ),
                if (_isBatchSelectionMode)
                  Positioned(
                    top: 2.h,
                    right: 6.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? AppTheme.lightTheme.colorScheme.primary : AppTheme.lightTheme.colorScheme.outline, width: 2),
                      ),
                      child: isSelected
                          ? Center(
                              child: CustomIconWidget(iconName: 'check', color: AppTheme.lightTheme.colorScheme.onPrimary, size: 16),
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    switch (_selectedSegment) {
      case 0: // Reading
        return EmptyStateWidget(
          title: 'No hay novelas en lectura',
          description: 'Descubre nuevas novelas y comienza tu aventura de lectura',
          buttonText: 'Descubrir Novelas',
          onButtonPressed: () => Navigator.pushNamed(context, '/search-screen'),
          illustrationUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
          semanticLabel: 'Ilustración de libros apilados representando una biblioteca vacía esperando nuevas lecturas',
        );
      case 1: // Downloaded
        return EmptyStateWidget(
          title: 'No hay novelas descargadas',
          description: 'Descarga novelas para leer sin conexión a internet',
          buttonText: 'Ir Online para Descargar',
          onButtonPressed: () => Navigator.pushNamed(context, '/home-screen'),
          illustrationUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
          semanticLabel: 'Ilustración de descarga con flecha hacia abajo y símbolo de wifi representando contenido offline',
        );
      case 2: // Favorites
        return EmptyStateWidget(
          title: 'No tienes favoritos',
          description: 'Marca tus novelas favoritas para acceder rápidamente a ellas',
          buttonText: 'Explorar Novelas',
          onButtonPressed: () => Navigator.pushNamed(context, '/search-screen'),
          illustrationUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
          semanticLabel: 'Ilustración de corazón vacío representando lista de favoritos sin contenido',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _getSearchHint() {
    switch (_selectedSegment) {
      case 0:
        return 'Buscar en lectura...';
      case 1:
        return 'Buscar descargados...';
      case 2:
        return 'Buscar favoritos...';
      default:
        return 'Buscar en biblioteca...';
    }
  }

  void _onSegmentChanged(int index) {
    setState(() {
      _selectedSegment = index;
      _searchQuery = '';
      _isBatchSelectionMode = false;
      _selectedNovels.clear();
    });
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _onRefresh() async {
    setState(() {
    });
    HapticFeedback.lightImpact();
    // Simulate sync operation
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
    });
  }

  void _showFilterSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterSortBottomSheet(
        currentSortOption: _currentSort,
        onSortChanged: (sortOption) {
          setState(() {
            _currentSort = sortOption;
          });
        },
      ),
    );
  }

  void _enableBatchSelection() {
    setState(() {
      _isBatchSelectionMode = true;
      _selectedNovels.clear();
    });
  }

  void _cancelBatchSelection() {
    setState(() {
      _isBatchSelectionMode = false;
      _selectedNovels.clear();
    });
  }

  void _toggleNovelSelection(int novelId) {
    setState(() {
      if (_selectedNovels.contains(novelId)) {
        _selectedNovels.remove(novelId);
      } else {
        _selectedNovels.add(novelId);
      }
    });
  }

  void _performBatchAction() {
    // Implement batch removal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar novelas'),
        content: Text('¿Estás seguro de que quieres eliminar ${_selectedNovels.length} novelas de tu biblioteca?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBatchSelection();
              // Implement actual removal logic here
            },
            child: Text('Eliminar', style: TextStyle(color: AppTheme.lightTheme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _onNovelTap(Map<String, dynamic> novel) {
    if (_isBatchSelectionMode) {
      _toggleNovelSelection(novel['id'] as int);
    } else {
      Navigator.pushNamed(context, '/novel-detail-screen');
    }
  }

  void _onContinueReading(Map<String, dynamic> novel) {
    Navigator.pushNamed(context, '/reader-screen');
  }

  void _onDownloadChapters(Map<String, dynamic> novel) {
    // Implement download logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Descargando capítulos de "${novel['title']}"...'), backgroundColor: AppTheme.lightTheme.colorScheme.primary));
  }

  void _onRemoveFromLibrary(Map<String, dynamic> novel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar de biblioteca'),
        content: Text('¿Estás seguro de que quieres eliminar "${novel['title']}" de tu biblioteca?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement removal logic
            },
            child: Text('Eliminar', style: TextStyle(color: AppTheme.lightTheme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _onMarkCompleted(Map<String, dynamic> novel) {
    // Implement mark as completed logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${novel['title']}" marcada como completada'), backgroundColor: AppTheme.lightTheme.colorScheme.tertiary));
  }

  void _onChangeCategory(Map<String, dynamic> novel) {
    // Implement category change logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar categoría'),
        content: const Text('Funcionalidad de cambio de categoría próximamente'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
      ),
    );
  }

  void _onExport(Map<String, dynamic> novel) {
    // Implement export logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportando "${novel['title']}"...'), backgroundColor: AppTheme.lightTheme.colorScheme.secondary));
  }
}
