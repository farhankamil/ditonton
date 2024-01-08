part of 'tv_series_top_rated_bloc.dart';

abstract class TvSeriesTopRatedState extends Equatable {
  const TvSeriesTopRatedState();

  @override
  List<Object> get props => [];
}

class TvSeriesTopRatedInitial extends TvSeriesTopRatedState {}

class TvSeriesTopRatedLoading extends TvSeriesTopRatedState {}

class TvSeriesTopRatedLoaded extends TvSeriesTopRatedState {
  final List<TvSeries> tvSeriesList;
  const TvSeriesTopRatedLoaded({
    required this.tvSeriesList,
  });

  @override
  List<Object> get props => [tvSeriesList];
}

class TvSeriesTopRatedError extends TvSeriesTopRatedState {
  final String message;
  const TvSeriesTopRatedError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
