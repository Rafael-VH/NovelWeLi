import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
//
import 'package:novel_we_li/features/presentation/screens/detail/widgets/action_buttons_row.dart';
import 'package:novel_we_li/features/presentation/screens/detail/widgets/chapter_list_section.dart';
import 'package:novel_we_li/features/presentation/screens/detail/widgets/expandable_synopsis.dart';
import 'package:novel_we_li/features/presentation/screens/detail/widgets/novel_hero_section.dart';
import 'package:novel_we_li/features/presentation/screens/detail/widgets/novel_metadata_section.dart';
import 'package:novel_we_li/features/presentation/screens/detail/widgets/reviews_section.dart';
import 'package:novel_we_li/features/presentation/widgets/custom_icon_widget.dart';

class NovelDetailScreen extends StatefulWidget {
  const NovelDetailScreen({super.key});

  @override
  State<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  // Mock novel data
  final Map<String, dynamic> _novelData = {
    "id": 1,
    "title": "El Emperador de los Mundos Infinitos",
    "author": "Chen Wei Ming",
    "coverImage": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Ym9va3xlbnwwfHwwfHx8MA%3D%3D",
    "coverImageSemanticLabel": "Fantasy book cover with mystical golden symbols and ancient architecture in the background",
    "rating": 4.7,
    "reviewCount": 2847,
    "synopsis":
        """En un mundo donde la cultivación determina el destino, Lin Chen, un joven aparentemente sin talento, descubre un antiguo artefacto que cambiará su vida para siempre. Con el poder de absorber las habilidades de sus enemigos derrotados, Lin Chen comenzará un viaje épico a través de múltiples reinos y dimensiones.Desde las montañas sagradas de su clan hasta los vastos océanos de estrellas, deberá enfrentar demonios ancestrales, maestros inmortales y secretos que podrían destruir la realidad misma. Cada victoria lo acerca más a la verdad sobre su origen y el misterioso artefacto que porta.¿Podrá Lin Chen ascender desde la humildad hasta convertirse en el emperador supremo de todos los mundos? ¿O sucumbirá ante las fuerzas oscuras que buscan reclamar el poder que ahora posee?Una historia épica de cultivación, aventura y descubrimiento personal que te mantendrá al borde de tu asiento desde el primer capítulo hasta el último.""",
    "genres": ["Fantasía", "Cultivación", "Aventura", "Acción", "Xianxia"],
    "status": "ongoing",
    "chapterCount": 1247,
    "lastUpdate": "2025-10-26T15:30:00Z",
    "isInLibrary": false,
    "readingProgress": 0.23,
    "wordCount": 2847000,
  };

  // Mock chapters data
  final List<Map<String, dynamic>> _chapters = [
    {"id": 1, "number": 1, "title": "El Despertar del Artefacto", "releaseDate": "2025-10-26T10:00:00Z", "wordCount": 2500, "isRead": true, "isDownloaded": true},
    {"id": 2, "number": 2, "title": "Primeros Pasos en la Cultivación", "releaseDate": "2025-10-25T14:30:00Z", "wordCount": 2800, "isRead": true, "isDownloaded": false},
    {"id": 3, "number": 3, "title": "El Torneo de los Discípulos Externos", "releaseDate": "2025-10-24T09:15:00Z", "wordCount": 3200, "isRead": false, "isDownloaded": true},
    {"id": 4, "number": 4, "title": "Secretos del Clan Ancestral", "releaseDate": "2025-10-23T16:45:00Z", "wordCount": 2900, "isRead": false, "isDownloaded": false},
    {"id": 5, "number": 5, "title": "La Primera Transformación", "releaseDate": "2025-10-22T11:20:00Z", "wordCount": 3100, "isRead": false, "isDownloaded": false},
  ];

  // Mock reviews data
  final List<Map<String, dynamic>> _reviews = [
    {
      "id": 1,
      "username": "DragonReader92",
      "avatar": "https://images.unsplash.com/photo-1632866892073-0b6bfafb2947",
      "avatarSemanticLabel": "Profile photo of a young man with short brown hair wearing a casual blue shirt",
      "rating": 5.0,
      "date": "2025-10-20T14:30:00Z",
      "comment": "¡Increíble historia! La construcción del mundo es fantástica y el desarrollo del personaje principal es muy realista. No puedo esperar a leer más capítulos.",
      "helpfulVotes": 47,
    },
    {
      "id": 2,
      "username": "NovelLover2024",
      "avatar": "https://images.unsplash.com/photo-1575090973814-063b180ffef9",
      "avatarSemanticLabel": "Profile photo of a woman with long blonde hair and a warm smile wearing a red sweater",
      "rating": 4.0,
      "date": "2025-10-18T09:15:00Z",
      "comment": "Muy buena novela de cultivación. El sistema de poder está bien explicado y las peleas son emocionantes. Algunos capítulos pueden ser un poco lentos, pero en general es excelente.",
      "helpfulVotes": 23,
    },
    {
      "id": 3,
      "username": "CultivationMaster",
      "avatar": "https://images.unsplash.com/photo-1585076799882-8f5a25025f4b",
      "avatarSemanticLabel": "Profile photo of an older man with gray hair and glasses wearing a formal black suit",
      "rating": 5.0,
      "date": "2025-10-15T20:45:00Z",
      "comment": "Como veterano lector de novelas xianxia, puedo decir que esta es una joya. El autor realmente entiende el género y aporta elementos frescos sin perder la esencia clásica.",
      "helpfulVotes": 89,
    },
    {
      "id": 4,
      "username": "FantasyFan88",
      "rating": 4.0,
      "date": "2025-10-12T16:20:00Z",
      "comment": "Historia sólida con buenos personajes secundarios. Me gusta cómo el protagonista no es demasiado poderoso desde el principio. El ritmo es perfecto para mantener el interés.",
      "helpfulVotes": 15,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showTitle = _scrollController.offset > 200;
    if (showTitle != _showAppBarTitle) {
      setState(() {
        _showAppBarTitle = showTitle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom app bar with hero image
          SliverAppBar(
            expandedHeight: 50.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            leading: Container(
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                icon: CustomIconWidget(iconName: 'arrow_back_ios', color: Colors.white, size: 20),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
                child: IconButton(
                  icon: CustomIconWidget(iconName: 'more_vert', color: Colors.white, size: 20),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showMoreOptions(context);
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: _showAppBarTitle
                  ? Text(
                      _novelData['title'] ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              background: NovelHeroSection(novelData: _novelData),
              collapseMode: CollapseMode.parallax,
            ),
          ),

          // Content sections
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Action buttons
                ActionButtonsRow(
                  novelData: _novelData,
                  onStartReading: () => _startReading(),
                  onDownload: () => _downloadNovel(),
                  onAddToLibrary: () => _toggleLibrary(),
                  onShare: () => _shareNovel(),
                ),
                // Synopsis
                ExpandableSynopsis(synopsis: _novelData['synopsis'] ?? ''),
                // Novel metadata
                NovelMetadataSection(novelData: _novelData),
                // Divider
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  child: Divider(color: colorScheme.outline.withValues(alpha: 0.2), thickness: 1),
                ),
                // Chapter list
                ChapterListSection(
                  chapters: _chapters,
                  onChapterTap: (chapter) => _readChapter(chapter),
                  onDownloadChapter: (chapter) => _downloadChapter(chapter),
                  onMarkAsRead: (chapter) => _markChapterAsRead(chapter),
                ),
                // Divider
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  child: Divider(color: colorScheme.outline.withValues(alpha: 0.2), thickness: 1),
                ),
                // Reviews
                ReviewsSection(reviews: _reviews, averageRating: _novelData['rating'] ?? 0.0, totalReviews: _novelData['reviewCount'] ?? 0),
                // Bottom padding
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startReading() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/reader-screen');
  }

  void _downloadNovel() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descargar Novela'),
        content: Text('¿Deseas descargar "${_novelData['title']}" completa para lectura offline?\n\nEsto incluirá ${_novelData['chapterCount']} capítulos.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Descarga iniciada. Se completará en segundo plano.'), duration: Duration(seconds: 3)));
            },
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  void _toggleLibrary() {
    HapticFeedback.lightImpact();
    setState(() {
      _novelData['isInLibrary'] = !(_novelData['isInLibrary'] as bool);
    });
    final message = _novelData['isInLibrary'] as bool ? 'Novela añadida a tu biblioteca' : 'Novela eliminada de tu biblioteca';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              _novelData['isInLibrary'] = !(_novelData['isInLibrary'] as bool);
            });
          },
        ),
      ),
    );
  }

  void _shareNovel() {
    HapticFeedback.lightImpact();
    final title = _novelData['title'] ?? 'Novela increíble';
    final author = _novelData['author'] ?? 'Autor desconocido';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Compartiendo "$title" por $author'), duration: const Duration(seconds: 2)));
  }

  void _readChapter(Map<String, dynamic> chapter) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/reader-screen');
  }

  void _downloadChapter(Map<String, dynamic> chapter) {
    HapticFeedback.lightImpact();
    final chapterTitle = chapter['title'] ?? 'Capítulo ${chapter['number']}';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Descargando "$chapterTitle"...'), duration: const Duration(seconds: 2)));
  }

  void _markChapterAsRead(Map<String, dynamic> chapter) {
    HapticFeedback.lightImpact();
    final isRead = chapter['isRead'] as bool? ?? false;
    final chapterTitle = chapter['title'] ?? 'Capítulo ${chapter['number']}';
    final message = isRead ? '"$chapterTitle" marcado como no leído' : '"$chapterTitle" marcado como leído';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  void _showMoreOptions(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(color: theme.colorScheme.outline, borderRadius: BorderRadius.circular(2)),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(iconName: 'report', color: Colors.orange, size: 24),
              title: const Text('Reportar problema'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Función de reporte enviada'), duration: Duration(seconds: 2)));
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: 'bookmark_add', color: theme.colorScheme.primary, size: 24),
              title: const Text('Añadir a lista personalizada'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido a lista personalizada'), duration: Duration(seconds: 2)));
              },
            ),
            ListTile(
              leading: CustomIconWidget(iconName: 'notifications', color: theme.colorScheme.primary, size: 24),
              title: const Text('Notificar nuevos capítulos'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notificaciones activadas'), duration: Duration(seconds: 2)));
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
