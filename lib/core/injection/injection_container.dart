import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Data Sources
import 'package:novel_we_li/features/data/datasources/novel_remote_datasource.dart';
import 'package:novel_we_li/features/data/datasources/novel_local_datasource.dart';

// Repositories
import 'package:novel_we_li/features/data/repositories/novel_repository_impl.dart';
import 'package:novel_we_li/features/domain/repositories/novel_repository.dart';

// Use Cases
import 'package:novel_we_li/features/domain/usecases/get_featured_novels.dart';
import 'package:novel_we_li/features/domain/usecases/get_recently_updated_novels.dart';
import 'package:novel_we_li/features/domain/usecases/get_popular_novels.dart';
import 'package:novel_we_li/features/domain/usecases/get_recommended_novels.dart';
import 'package:novel_we_li/features/domain/usecases/search_novels.dart';

// BLoCs
import 'package:novel_we_li/features/presentation/bloc/home/home_bloc.dart';
import 'package:novel_we_li/features/presentation/bloc/search/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - BLoCs
  sl.registerFactory(
    () => HomeBloc(
      getFeaturedNovels: sl(),
      getRecentlyUpdatedNovels: sl(),
      getPopularNovels: sl(),
      getRecommendedNovels: sl(),
    ),
  );

  sl.registerFactory(
    () => SearchBloc(
      searchNovels: sl(),
    ),
  );

  //! Use cases
  sl.registerLazySingleton(() => GetFeaturedNovels(sl()));
  sl.registerLazySingleton(() => GetRecentlyUpdatedNovels(sl()));
  sl.registerLazySingleton(() => GetPopularNovels(sl()));
  sl.registerLazySingleton(() => GetRecommendedNovels(sl()));
  sl.registerLazySingleton(() => SearchNovels(sl()));

  //! Repository
  sl.registerLazySingleton<NovelRepository>(
    () => NovelRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      connectivity: sl(),
    ),
  );

  //! Data sources
  sl.registerLazySingleton<NovelRemoteDataSource>(
    () => NovelRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NovelLocalDataSource>(
    () => NovelLocalDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
