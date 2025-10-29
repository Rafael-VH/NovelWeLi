import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//
import 'package:novel_we_li/core/failiures/failure.dart';
//
import 'package:novel_we_li/features/data/datasources/novel_remote_datasource.dart';
import 'package:novel_we_li/features/data/datasources/novel_local_datasource.dart';
//
import 'package:novel_we_li/features/domain/entities/chapter.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/domain/repositories/novel_repository.dart';

class NovelRepositoryImpl implements NovelRepository {
  final NovelRemoteDataSource remoteDataSource;
  final NovelLocalDataSource localDataSource;
  final Connectivity connectivity;

  NovelRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.connectivity});

  @override
  Future<Either<Failure, List<Novel>>> getFeaturedNovels() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final localNovels = await localDataSource.getCachedFeaturedNovels();
        return Right(localNovels.map((model) => model.toEntity()).toList());
      }

      final remoteNovels = await remoteDataSource.getFeaturedNovels();
      await localDataSource.cacheFeaturedNovels(remoteNovels);
      return Right(remoteNovels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Novel>>> getRecentlyUpdatedNovels() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final localNovels = await localDataSource.getCachedRecentlyUpdatedNovels();
        return Right(localNovels.map((model) => model.toEntity()).toList());
      }

      final remoteNovels = await remoteDataSource.getRecentlyUpdatedNovels();
      await localDataSource.cacheRecentlyUpdatedNovels(remoteNovels);
      return Right(remoteNovels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Novel>>> getPopularNovels() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final localNovels = await localDataSource.getCachedPopularNovels();
        return Right(localNovels.map((model) => model.toEntity()).toList());
      }

      final remoteNovels = await remoteDataSource.getPopularNovels();
      await localDataSource.cachePopularNovels(remoteNovels);
      return Right(remoteNovels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Novel>>> getRecommendedNovels() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final localNovels = await localDataSource.getCachedRecommendedNovels();
        return Right(localNovels.map((model) => model.toEntity()).toList());
      }

      final remoteNovels = await remoteDataSource.getRecommendedNovels();
      await localDataSource.cacheRecommendedNovels(remoteNovels);
      return Right(remoteNovels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Novel>>> searchNovels(String query) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }

      final remoteNovels = await remoteDataSource.searchNovels(query);
      return Right(remoteNovels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Novel>> getNovelDetails(String novelId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final localNovel = await localDataSource.getCachedNovelDetails(novelId);
        return Right(localNovel.toEntity());
      }

      final remoteNovel = await remoteDataSource.getNovelDetails(novelId);
      await localDataSource.cacheNovelDetails(remoteNovel);
      return Right(remoteNovel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Chapter>>> getNovelChapters(String novelId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final localChapters = await localDataSource.getCachedChapters(novelId);
        return Right(localChapters.map((model) => model.toEntity()).toList());
      }

      final remoteChapters = await remoteDataSource.getNovelChapters(novelId);
      await localDataSource.cacheChapters(novelId, remoteChapters);
      return Right(remoteChapters.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chapter>> getChapterContent(String chapterId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final localChapter = await localDataSource.getCachedChapterContent(chapterId);
        return Right(localChapter.toEntity());
      }

      final remoteChapter = await remoteDataSource.getChapterContent(chapterId);
      await localDataSource.cacheChapterContent(remoteChapter);
      return Right(remoteChapter.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String novelId) async {
    try {
      await localDataSource.toggleFavorite(novelId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Novel>>> getFavoriteNovels() async {
    try {
      final favoriteNovels = await localDataSource.getFavoriteNovels();
      return Right(favoriteNovels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markChapterAsRead(String chapterId) async {
    try {
      await localDataSource.markChapterAsRead(chapterId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> downloadNovel(String novelId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return const Left(NetworkFailure(message: 'No internet connection for download'));
      }

      final novel = await remoteDataSource.getNovelDetails(novelId);
      final chapters = await remoteDataSource.getNovelChapters(novelId);

      await localDataSource.downloadNovel(novel, chapters);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Novel>>> getDownloadedNovels() async {
    try {
      final downloadedNovels = await localDataSource.getDownloadedNovels();
      return Right(downloadedNovels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
