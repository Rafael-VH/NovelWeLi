import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
//
import 'package:novel_we_li/core/failiures/failure.dart';
import 'package:novel_we_li/core/usecases/usecases.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/domain/repositories/novel_repository.dart';

class SearchNovels implements UseCase<List<Novel>, SearchNovelsParams> {
  final NovelRepository repository;

  SearchNovels(this.repository);

  @override
  Future<Either<Failure, List<Novel>>> call(SearchNovelsParams params) async {
    return await repository.searchNovels(params.query);
  }
}

class SearchNovelsParams extends Equatable {
  final String query;

  const SearchNovelsParams({required this.query});

  @override
  List<Object> get props => [query];
}
