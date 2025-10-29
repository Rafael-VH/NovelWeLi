part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchNovelsRequested extends SearchEvent {
  final String query;

  const SearchNovelsRequested(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends SearchEvent {}
