import 'dart:convert';
import 'package:novel_we_li/features/data/models/chapter_model.dart';
import 'package:novel_we_li/features/data/models/novel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
//

abstract class NovelLocalDataSource {
  Future<List<NovelModel>> getCachedFeaturedNovels();
  Future<void> cacheFeaturedNovels(List<NovelModel> novels);
  Future<List<NovelModel>> getCachedRecentlyUpdatedNovels();
  Future<void> cacheRecentlyUpdatedNovels(List<NovelModel> novels);
  Future<List<NovelModel>> getCachedPopularNovels();
  Future<void> cachePopularNovels(List<NovelModel> novels);
  Future<List<NovelModel>> getCachedRecommendedNovels();
  Future<void> cacheRecommendedNovels(List<NovelModel> novels);
  Future<NovelModel> getCachedNovelDetails(String novelId);
  Future<void> cacheNovelDetails(NovelModel novel);
  Future<List<ChapterModel>> getCachedChapters(String novelId);
  Future<void> cacheChapters(String novelId, List<ChapterModel> chapters);
  Future<ChapterModel> getCachedChapterContent(String chapterId);
  Future<void> cacheChapterContent(ChapterModel chapter);
  Future<void> toggleFavorite(String novelId);
  Future<List<NovelModel>> getFavoriteNovels();
  Future<void> markChapterAsRead(String chapterId);
  Future<void> downloadNovel(NovelModel novel, List<ChapterModel> chapters);
  Future<List<NovelModel>> getDownloadedNovels();
}

class NovelLocalDataSourceImpl implements NovelLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _featuredNovelsKey = 'featured_novels';
  static const String _recentlyUpdatedNovelsKey = 'recently_updated_novels';
  static const String _popularNovelsKey = 'popular_novels';
  static const String _recommendedNovelsKey = 'recommended_novels';
  static const String _novelDetailsPrefix = 'novel_details_';
  static const String _chaptersPrefix = 'chapters_';
  static const String _chapterContentPrefix = 'chapter_content_';
  static const String _favoriteNovelsKey = 'favorite_novels';
  static const String _readChaptersKey = 'read_chapters';
  static const String _downloadedNovelsKey = 'downloaded_novels';

  NovelLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<NovelModel>> getCachedFeaturedNovels() async {
    final jsonString = sharedPreferences.getString(_featuredNovelsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => NovelModel.fromJson(json)).toList();
    }
    throw Exception('No cached featured novels found');
  }

  @override
  Future<void> cacheFeaturedNovels(List<NovelModel> novels) async {
    final jsonString =
        json.encode(novels.map((novel) => novel.toJson()).toList());
    await sharedPreferences.setString(_featuredNovelsKey, jsonString);
  }

  @override
  Future<List<NovelModel>> getCachedRecentlyUpdatedNovels() async {
    final jsonString = sharedPreferences.getString(_recentlyUpdatedNovelsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => NovelModel.fromJson(json)).toList();
    }
    throw Exception('No cached recently updated novels found');
  }

  @override
  Future<void> cacheRecentlyUpdatedNovels(List<NovelModel> novels) async {
    final jsonString =
        json.encode(novels.map((novel) => novel.toJson()).toList());
    await sharedPreferences.setString(_recentlyUpdatedNovelsKey, jsonString);
  }

  @override
  Future<List<NovelModel>> getCachedPopularNovels() async {
    final jsonString = sharedPreferences.getString(_popularNovelsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => NovelModel.fromJson(json)).toList();
    }
    throw Exception('No cached popular novels found');
  }

  @override
  Future<void> cachePopularNovels(List<NovelModel> novels) async {
    final jsonString =
        json.encode(novels.map((novel) => novel.toJson()).toList());
    await sharedPreferences.setString(_popularNovelsKey, jsonString);
  }

  @override
  Future<List<NovelModel>> getCachedRecommendedNovels() async {
    final jsonString = sharedPreferences.getString(_recommendedNovelsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => NovelModel.fromJson(json)).toList();
    }
    throw Exception('No cached recommended novels found');
  }

  @override
  Future<void> cacheRecommendedNovels(List<NovelModel> novels) async {
    final jsonString =
        json.encode(novels.map((novel) => novel.toJson()).toList());
    await sharedPreferences.setString(_recommendedNovelsKey, jsonString);
  }

  @override
  Future<NovelModel> getCachedNovelDetails(String novelId) async {
    final jsonString =
        sharedPreferences.getString('$_novelDetailsPrefix$novelId');
    if (jsonString != null) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return NovelModel.fromJson(json);
    }
    throw Exception('No cached novel details found for $novelId');
  }

  @override
  Future<void> cacheNovelDetails(NovelModel novel) async {
    final jsonString = json.encode(novel.toJson());
    await sharedPreferences.setString(
        '$_novelDetailsPrefix${novel.id}', jsonString);
  }

  @override
  Future<List<ChapterModel>> getCachedChapters(String novelId) async {
    final jsonString = sharedPreferences.getString('$_chaptersPrefix$novelId');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ChapterModel.fromJson(json)).toList();
    }
    throw Exception('No cached chapters found for $novelId');
  }

  @override
  Future<void> cacheChapters(
      String novelId, List<ChapterModel> chapters) async {
    final jsonString =
        json.encode(chapters.map((chapter) => chapter.toJson()).toList());
    await sharedPreferences.setString('$_chaptersPrefix$novelId', jsonString);
  }

  @override
  Future<ChapterModel> getCachedChapterContent(String chapterId) async {
    final jsonString =
        sharedPreferences.getString('$_chapterContentPrefix$chapterId');
    if (jsonString != null) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return ChapterModel.fromJson(json);
    }
    throw Exception('No cached chapter content found for $chapterId');
  }

  @override
  Future<void> cacheChapterContent(ChapterModel chapter) async {
    final jsonString = json.encode(chapter.toJson());
    await sharedPreferences.setString(
        '$_chapterContentPrefix${chapter.id}', jsonString);
  }

  @override
  Future<void> toggleFavorite(String novelId) async {
    final favoriteIds =
        sharedPreferences.getStringList(_favoriteNovelsKey) ?? [];
    if (favoriteIds.contains(novelId)) {
      favoriteIds.remove(novelId);
    } else {
      favoriteIds.add(novelId);
    }
    await sharedPreferences.setStringList(_favoriteNovelsKey, favoriteIds);
  }

  @override
  Future<List<NovelModel>> getFavoriteNovels() async {
    final favoriteIds =
        sharedPreferences.getStringList(_favoriteNovelsKey) ?? [];
    final List<NovelModel> favoriteNovels = [];
    for (final id in favoriteIds) {
      try {
        final novel = await getCachedNovelDetails(id);
        favoriteNovels.add(novel);
      } catch (e) {
        // Skip if novel not found in cache
      }
    }
    return favoriteNovels;
  }

  @override
  Future<void> markChapterAsRead(String chapterId) async {
    final readChapterIds =
        sharedPreferences.getStringList(_readChaptersKey) ?? [];
    if (!readChapterIds.contains(chapterId)) {
      readChapterIds.add(chapterId);
      await sharedPreferences.setStringList(_readChaptersKey, readChapterIds);
    }
  }

  @override
  Future<void> downloadNovel(
      NovelModel novel, List<ChapterModel> chapters) async {
    // Cache novel details
    await cacheNovelDetails(novel);

    // Cache all chapters
    await cacheChapters(novel.id, chapters);

    // Mark as downloaded
    final downloadedIds =
        sharedPreferences.getStringList(_downloadedNovelsKey) ?? [];
    if (!downloadedIds.contains(novel.id)) {
      downloadedIds.add(novel.id);
      await sharedPreferences.setStringList(
          _downloadedNovelsKey, downloadedIds);
    }
  }

  @override
  Future<List<NovelModel>> getDownloadedNovels() async {
    final downloadedIds =
        sharedPreferences.getStringList(_downloadedNovelsKey) ?? [];
    final List<NovelModel> downloadedNovels = [];
    for (final id in downloadedIds) {
      try {
        final novel = await getCachedNovelDetails(id);
        downloadedNovels.add(novel);
      } catch (e) {
        // Skip if novel not found in cache
      }
    }
    return downloadedNovels;
  }
}
