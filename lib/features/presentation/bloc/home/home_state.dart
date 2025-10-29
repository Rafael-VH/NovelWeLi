part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Novel> featuredNovels;
  final List<Novel> recentlyUpdatedNovels;
  final List<Novel> popularNovels;
  final List<Novel> recommendedNovels;
  final bool isRefreshing;

  const HomeLoaded({
    required this.featuredNovels,
    required this.recentlyUpdatedNovels,
    required this.popularNovels,
    required this.recommendedNovels,
    this.isRefreshing = false,
  });

  @override
  List<Object> get props => [
        featuredNovels,
        recentlyUpdatedNovels,
        popularNovels,
        recommendedNovels,
        isRefreshing,
      ];

  HomeLoaded copyWith({
    List<Novel>? featuredNovels,
    List<Novel>? recentlyUpdatedNovels,
    List<Novel>? popularNovels,
    List<Novel>? recommendedNovels,
    bool? isRefreshing,
  }) {
    return HomeLoaded(
      featuredNovels: featuredNovels ?? this.featuredNovels,
      recentlyUpdatedNovels:
          recentlyUpdatedNovels ?? this.recentlyUpdatedNovels,
      popularNovels: popularNovels ?? this.popularNovels,
      recommendedNovels: recommendedNovels ?? this.recommendedNovels,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
