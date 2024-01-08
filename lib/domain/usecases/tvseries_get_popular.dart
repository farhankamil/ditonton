import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entities/tvseries.dart';
import '../repositories/tvseries_repository.dart';

class TvSeriesGetPopular {
  final TvSeriesRepository repository;
  TvSeriesGetPopular({
    required this.repository,
  });

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getPopularTvSeries();
  }
}
