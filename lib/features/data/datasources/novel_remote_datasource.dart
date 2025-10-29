import 'package:dio/dio.dart';
import 'package:novel_we_li/features/data/models/chapter_model.dart';
import 'package:novel_we_li/features/data/models/novel_model.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';
//


abstract class NovelRemoteDataSource {
  Future<List<NovelModel>> getFeaturedNovels();
  Future<List<NovelModel>> getRecentlyUpdatedNovels();
  Future<List<NovelModel>> getPopularNovels();
  Future<List<NovelModel>> getRecommendedNovels();
  Future<List<NovelModel>> searchNovels(String query);
  Future<NovelModel> getNovelDetails(String novelId);
  Future<List<ChapterModel>> getNovelChapters(String novelId);
  Future<ChapterModel> getChapterContent(String chapterId);
}

class NovelRemoteDataSourceImpl implements NovelRemoteDataSource {
  final Dio dio;

  NovelRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NovelModel>> getFeaturedNovels() async {
    try {
      // Mock data for demonstration - replace with actual API call
      return _getMockNovels().take(5).toList();
    } catch (e) {
      throw Exception('Failed to load featured novels: $e');
    }
  }

  @override
  Future<List<NovelModel>> getRecentlyUpdatedNovels() async {
    try {
      // Mock data for demonstration - replace with actual API call
      return _getMockNovels().take(8).toList();
    } catch (e) {
      throw Exception('Failed to load recently updated novels: $e');
    }
  }

  @override
  Future<List<NovelModel>> getPopularNovels() async {
    try {
      // Mock data for demonstration - replace with actual API call
      return _getMockNovels().take(6).toList();
    } catch (e) {
      throw Exception('Failed to load popular novels: $e');
    }
  }

  @override
  Future<List<NovelModel>> getRecommendedNovels() async {
    try {
      // Mock data for demonstration - replace with actual API call
      return _getMockNovels().take(7).toList();
    } catch (e) {
      throw Exception('Failed to load recommended novels: $e');
    }
  }

  @override
  Future<List<NovelModel>> searchNovels(String query) async {
    try {
      // Mock search implementation - replace with actual API call
      final novels = _getMockNovels();
      return novels.where((novel) => novel.title.toLowerCase().contains(query.toLowerCase()) || novel.author.toLowerCase().contains(query.toLowerCase())).toList();
    } catch (e) {
      throw Exception('Failed to search novels: $e');
    }
  }

  @override
  Future<NovelModel> getNovelDetails(String novelId) async {
    try {
      // Mock implementation - replace with actual API call
      final novels = _getMockNovels();
      return novels.firstWhere((novel) => novel.id == novelId);
    } catch (e) {
      throw Exception('Failed to load novel details: $e');
    }
  }

  @override
  Future<List<ChapterModel>> getNovelChapters(String novelId) async {
    try {
      // Mock implementation - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      return List.generate(
        50,
        (index) => ChapterModel(
          id: 'chapter_${novelId}_${index + 1}',
          novelId: novelId,
          title: 'Capítulo ${index + 1}: ${_getRandomChapterTitle()}',
          chapterNumber: index + 1,
          publishedDate: DateTime.now().subtract(Duration(days: 50 - index)),
          isRead: index < 10,
          wordCount: 2500 + (index * 50),
        ),
      );
    } catch (e) {
      throw Exception('Failed to load novel chapters: $e');
    }
  }

  @override
  Future<ChapterModel> getChapterContent(String chapterId) async {
    try {
      // Mock implementation - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 800));
      return ChapterModel(
        id: chapterId,
        novelId: 'novel_1',
        title: 'Capítulo 1: El Despertar',
        chapterNumber: 1,
        content: _getMockChapterContent(),
        publishedDate: DateTime.now().subtract(const Duration(days: 1)),
        wordCount: 2500,
      );
    } catch (e) {
      throw Exception('Failed to load chapter content: $e');
    }
  }

  List<NovelModel> _getMockNovels() {
    return [
      const NovelModel(
        id: 'novel_1',
        title: 'El Último Emperador Inmortal',
        author: 'Zhang Wei',
        synopsis: 'En un mundo donde la inmortalidad es el mayor poder, un joven debe descubrir los secretos de su linaje imperial perdido.',
        coverImageUrl: 'https://picsum.photos/400/600?random=1',
        genres: ['Fantasía', 'Aventura', 'Cultivación'],
        rating: 4.8,
        totalChapters: 500,
        readChapters: 45,
        status: NovelStatus.ongoing,
      ),
      const NovelModel(
        id: 'novel_2',
        title: 'Academia de Magia Moderna',
        author: 'Elena Rosales',
        synopsis: 'Una academia donde la magia antigua se combina con la tecnología moderna para formar a los magos del futuro.',
        coverImageUrl: 'https://picsum.photos/400/600?random=2',
        genres: ['Magia', 'Escuela', 'Romance'],
        rating: 4.6,
        totalChapters: 300,
        readChapters: 120,
        status: NovelStatus.ongoing,
      ),
      const NovelModel(
        id: 'novel_3',
        title: 'El Camino del Samurái Perdido',
        author: 'Hiroshi Tanaka',
        synopsis: 'Un samurái deshonrado busca redimir su honor en un Japón feudal lleno de demonios y espíritus.',
        coverImageUrl: 'https://picsum.photos/400/600?random=3',
        genres: ['Histórico', 'Acción', 'Sobrenatural'],
        rating: 4.7,
        totalChapters: 250,
        readChapters: 0,
        status: NovelStatus.completed,
      ),
      const NovelModel(
        id: 'novel_4',
        title: 'La Reina de las Sombras',
        author: 'Victoria Blackwood',
        synopsis: 'En un reino donde las sombras cobran vida, una joven descubre que es la heredera de un poder ancestral.',
        coverImageUrl: 'https://picsum.photos/400/600?random=4',
        genres: ['Fantasía Oscura', 'Romance', 'Política'],
        rating: 4.9,
        totalChapters: 400,
        readChapters: 200,
        status: NovelStatus.ongoing,
      ),
      const NovelModel(
        id: 'novel_5',
        title: 'Los Guardianes del Tiempo',
        author: 'Marcus Stone',
        synopsis: 'Un grupo de guerreros viaja a través del tiempo para evitar el colapso de la realidad misma.',
        coverImageUrl: 'https://picsum.photos/400/600?random=5',
        genres: ['Ciencia Ficción', 'Aventura', 'Viajes en el Tiempo'],
        rating: 4.5,
        totalChapters: 350,
        readChapters: 75,
        status: NovelStatus.ongoing,
      ),
    ];
  }

  String _getRandomChapterTitle() {
    final titles = [
      'El Despertar',
      'La Primera Prueba',
      'Secretos Revelados',
      'El Poder Oculto',
      'La Batalla Final',
      'Un Nuevo Amanecer',
      'El Precio del Poder',
      'Aliados Inesperados',
      'La Verdad Dolorosa',
      'El Último Recurso',
    ];
    return titles[DateTime.now().millisecond % titles.length];
  }

  String _getMockChapterContent() {
    return '''
En la penumbra del amanecer, el joven emperador se alzó de su lecho con la determinación grabada en su rostro. Los eventos de la noche anterior aún resonaban en su mente como ecos de una tormenta lejana.

"El poder no se otorga, se conquista", murmuró mientras contemplaba el horizonte desde su ventana. Las montañas púrpuras se extendían hacia el infinito, guardando secretos milenarios que solo los inmortales conocían.

Un golpe suave en la puerta interrumpió sus pensamientos. Su consejero más fiel, el maestro Li, entró con paso silencioso.

—Alteza, han llegado noticias de las provincias del sur. Los rebeldes se organizan bajo una nueva bandera.

El emperador asintió lentamente. Sabía que este día llegaría. La profecía ancestral hablaba de una época de caos que precedería al verdadero despertar de su linaje.

—Prepara a los Guardianes Dorados —ordenó—. Es hora de recordar al mundo por qué temían el nombre de nuestra dinastía.

El viento matutino llevó consigo el aroma de las flores de loto del jardín imperial, pero también algo más... el inconfundible olor del cambio que se avecinaba.

En las profundidades del palacio, algo ancestral comenzaba a despertar.
    ''';
  }
}
