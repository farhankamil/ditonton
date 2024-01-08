import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/tvseries_get_airing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesGetAiring usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = TvSeriesGetAiring(repository: mockTvSeriesRepository);
  });

  final tvSeries = <TvSeries>[];

  test('get list of TV Series airing from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getAiringTvSeries())
        .thenAnswer((_) async => Right(tvSeries));
    //act
    final result = await usecase.execute();
    //assert
    expect(result, Right(tvSeries));
  });
}
