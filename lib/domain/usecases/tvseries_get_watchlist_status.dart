import '../repositories/tvseries_repository.dart';

class TvSeriesGetWatchListStatus {
  final TvSeriesRepository repository;

  TvSeriesGetWatchListStatus({required this.repository});

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
