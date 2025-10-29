
import 'package:dartz/dartz.dart';
//
import 'package:novel_we_li/core/failiures/failure.dart';
import 'package:novel_we_li/core/usecases/usecases.dart';
import 'package:novel_we_li/features/domain/entities/novel.dart';
import 'package:novel_we_li/features/domain/repositories/novel_repository.dart';

class GetRecentlyUpdatedNovels implements UseCase<List<Novel>, NoParams> {
  final NovelRepository repository;

  GetRecentlyUpdatedNovels(this.repository);

  @override
  Future<Either<Failure, List<Novel>>> call(NoParams params) async {
    return await repository.getRecentlyUpdatedNovels();
  }
}
