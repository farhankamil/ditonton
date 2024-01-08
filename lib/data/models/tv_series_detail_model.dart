// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailModel extends Equatable {
  final int id;
  final String name;
  final List<GenreModel> genres;
  final String posterPath;
  final double voteAverage;
  final String overview;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  const TvSeriesDetailModel({
    required this.id,
    required this.name,
    required this.genres,
    required this.posterPath,
    required this.voteAverage,
    required this.overview,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailModel(
        id: json['id'],
        name: json['name'],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        posterPath: json['poster_path'],
        voteAverage: json['vote_average'],
        overview: json['overview'],
        numberOfEpisodes: json['number_of_episodes'],
        numberOfSeasons: json['number_of_seasons'],
      );

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      id: id,
      name: name,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      posterPath: posterPath,
      voteAverage: voteAverage,
      overview: overview,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        genres,
        posterPath,
        voteAverage,
        overview,
        numberOfEpisodes,
        numberOfSeasons
      ];
}
