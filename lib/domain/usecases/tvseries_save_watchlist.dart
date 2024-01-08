import 'package:dartz/dartz.dart';
import '../../common/failure.dart';
import '../entities/tvseries_detail.dart';
import '../repositories/tvseries_repository.dart';

class TvSeriesSaveWatchlist {
  final TvSeriesRepository repository;

  TvSeriesSaveWatchlist({required this.repository});

  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) {
    return repository.saveTvSeriesWatchlist(tvSeries);
  }
}
