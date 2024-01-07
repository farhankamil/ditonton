import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/tv_series.dart';
import '../repositories/tv_series_repository.dart';

class GetAiringTvSeries {
  final TvSeriesRepository repository;
  GetAiringTvSeries({
    required this.repository,
  });

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getAiringTvSeries();
  }
}
