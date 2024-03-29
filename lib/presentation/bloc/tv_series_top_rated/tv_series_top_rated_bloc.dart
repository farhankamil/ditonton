import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ditonton/domain/usecases/tvseries_get_top_rated.dart';

import '../../../domain/entities/tvseries.dart';

part 'tv_series_top_rated_event.dart';
part 'tv_series_top_rated_state.dart';

class TvSeriesTopRatedBloc
    extends Bloc<TvSeriesTopRatedEvent, TvSeriesTopRatedState> {
  final GetTopRatedTvSeries usecases;
  TvSeriesTopRatedBloc(
    this.usecases,
  ) : super(TvSeriesTopRatedInitial()) {
    on<TvSeriesTopRatedGetEvent>((event, emit) async {
      emit(TvSeriesTopRatedLoading());
      final result = await usecases.execute();
      result.fold(
        (l) => emit(TvSeriesTopRatedError(message: l.message)),
        (r) => emit(TvSeriesTopRatedLoaded(tvSeriesList: r)),
      );
    });
  }
}
