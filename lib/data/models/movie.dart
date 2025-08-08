import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  @JsonKey(name: 'overview')
  final String? description;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  final bool adult;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  final double popularity;
  final bool video;

  const Movie({
    required this.id,
    required this.title,
    this.description,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  String get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w780$backdropPath'
      : '';

  String get formattedReleaseDate {
    if (releaseDate == null || releaseDate!.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate!);
      return '${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  String get ratingText => voteAverage.toStringAsFixed(1);

  Movie copyWith({
    int? id,
    String? title,
    String? description,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    List<int>? genreIds,
    bool? adult,
    String? originalLanguage,
    String? originalTitle,
    double? popularity,
    bool? video,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      genreIds: genreIds ?? this.genreIds,
      adult: adult ?? this.adult,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      popularity: popularity ?? this.popularity,
      video: video ?? this.video,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
