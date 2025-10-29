import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/domain/usecases/search_novels.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchNovels searchNovels;

  SearchBloc({required this.searchNovels}) : super(SearchInitial()) {
    on<SearchNovelsRequested>(_onSearchNovelsRequested);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchNovelsRequested(SearchNovelsRequested event, Emitter<SearchState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchNovels(SearchNovelsParams(query: event.query));

    result.fold((failure) => emit(SearchError(failure.message)), (novels) => emit(SearchLoaded(novels)));
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
