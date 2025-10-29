import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novel_we_li/core/usecases/usecases.dart';
//
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/domain/usecases/get_featured_novels.dart';
import 'package:novel_we_li/features/domain/usecases/get_popular_novels.dart';
import 'package:novel_we_li/features/domain/usecases/get_recently_updated_novels.dart';
import 'package:novel_we_li/features/domain/usecases/get_recommended_novels.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetFeaturedNovels getFeaturedNovels;
  final GetRecentlyUpdatedNovels getRecentlyUpdatedNovels;
  final GetPopularNovels getPopularNovels;
  final GetRecommendedNovels getRecommendedNovels;

  HomeBloc({required this.getFeaturedNovels, required this.getRecentlyUpdatedNovels, required this.getPopularNovels, required this.getRecommendedNovels}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      final results = await Future.wait([getFeaturedNovels(NoParams()), getRecentlyUpdatedNovels(NoParams()), getPopularNovels(NoParams()), getRecommendedNovels(NoParams())] as Iterable<Future>);

      final featuredResult = results[0];
      final recentlyUpdatedResult = results[1];
      final popularResult = results[2];
      final recommendedResult = results[3];

      if (featuredResult.isLeft() || recentlyUpdatedResult.isLeft() || popularResult.isLeft() || recommendedResult.isLeft()) {
        // Get the first error
        final failure = featuredResult.fold(
          (failure) => failure,
          (_) => recentlyUpdatedResult.fold((failure) => failure, (_) => popularResult.fold((failure) => failure, (_) => recommendedResult.fold((failure) => failure, (_) => null))),
        );

        if (failure != null) {
          emit(HomeError(failure.message));
          return;
        }
      }

      final featuredNovels = featuredResult.fold((_) => <Novel>[], (novels) => novels);

      final recentlyUpdatedNovels = recentlyUpdatedResult.fold((_) => <Novel>[], (novels) => novels);

      final popularNovels = popularResult.fold((_) => <Novel>[], (novels) => novels);

      final recommendedNovels = recommendedResult.fold((_) => <Novel>[], (novels) => novels);

      emit(HomeLoaded(featuredNovels: featuredNovels, recentlyUpdatedNovels: recentlyUpdatedNovels, popularNovels: popularNovels, recommendedNovels: recommendedNovels));
    } catch (e) {
      emit(HomeError('Error inesperado: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    // Keep current state while refreshing
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(isRefreshing: true));
    }

    // Load fresh data
    add(LoadHomeData());
  }
}
