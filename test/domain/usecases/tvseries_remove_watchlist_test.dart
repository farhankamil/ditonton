import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvseries_remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRemoveWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = TvSeriesRemoveWatchlist(repository: mockTvSeriesRepository);
  });

  test('should remove watchlist TV Series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.removeTvSeriesWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.removeTvSeriesWatchlist(testTvSeriesDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
