import 'package:dartz/dartz.dart';
import 'package:novel_we_li/core/failiures/failure.dart';
import 'package:novel_we_li/features/domain/entities/chapter.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';


abstract class NovelRepository {
  Future<Either<Failure, List<Novel>>> getFeaturedNovels();
  Future<Either<Failure, List<Novel>>> getRecentlyUpdatedNovels();
  Future<Either<Failure, List<Novel>>> getPopularNovels();
  Future<Either<Failure, List<Novel>>> getRecommendedNovels();
  Future<Either<Failure, List<Novel>>> searchNovels(String query);
  Future<Either<Failure, Novel>> getNovelDetails(String novelId);
  Future<Either<Failure, List<Chapter>>> getNovelChapters(String novelId);
  Future<Either<Failure, Chapter>> getChapterContent(String chapterId);
  Future<Either<Failure, void>> toggleFavorite(String novelId);
  Future<Either<Failure, List<Novel>>> getFavoriteNovels();
  Future<Either<Failure, void>> markChapterAsRead(String chapterId);
  Future<Either<Failure, void>> downloadNovel(String novelId);
  Future<Either<Failure, List<Novel>>> getDownloadedNovels();
}
