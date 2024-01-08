import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvseries_save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesSaveWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = TvSeriesSaveWatchlist(repository: mockTvSeriesRepository);
  });

  test('should save TV Series to the repository', () async {
    // arrange
    when(mockTvSeriesRepository.saveTvSeriesWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.saveTvSeriesWatchlist(testTvSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
