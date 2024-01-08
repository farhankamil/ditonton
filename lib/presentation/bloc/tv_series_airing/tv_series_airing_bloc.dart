import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tvseries.dart';
import '../../../domain/usecases/tvseries_get_airing.dart';

part 'tv_series_airing_event.dart';
part 'tv_series_airing_state.dart';

class TvSeriesAiringBloc
    extends Bloc<TvSeriesAiringEvent, TvSeriesAiringState> {
  final TvSeriesGetAiring usecases;
  TvSeriesAiringBloc(
    this.usecases,
  ) : super(TvSeriesAiringInitial()) {
    on<TvSeriesAiringGetEvent>((event, emit) async {
      emit(TvSeriesAiringLoading());
      final result = await usecases.execute();
      result.fold(
        (l) => emit(TvSeriesAiringError(message: l.message)),
        (r) => emit(TvSeriesAiringLoaded(tvSeriesList: r)),
      );
    });
  }
}
