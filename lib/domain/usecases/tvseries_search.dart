import 'package:dartz/dartz.dart';

import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class TvSeriesSearch {
  final TvSeriesRepository repository;
  TvSeriesSearch({
    required this.repository,
  });

  Future<Either<Failure, List<TvSeries>>> execute(String query) {
    return repository.searchTvSeries(query);
  }
}
