class MovieModel {
  final String backdropPath;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final int voteCount;

  MovieModel({
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieModel.fromMap(Map<String, dynamic> popular) {
    return MovieModel(
      backdropPath: popular['backdrop_path'] ?? '',
      id: popular['id'] ?? 0,
      originalLanguage: popular['original_language'] ?? '',
      originalTitle: popular['original_title'] ?? '',
      overview: popular['overview'] ?? '',
      popularity: (popular['popularity'] ?? 0).toDouble(),
      posterPath: popular['poster_path'] ?? '',
      releaseDate: popular['release_date'] ?? '',
      title: popular['title'] ?? 'Sin título',
      voteAverage: (popular['vote_average'] ?? 0).toDouble(),
      voteCount: popular['vote_count'] ?? 0,
    );
  }
}