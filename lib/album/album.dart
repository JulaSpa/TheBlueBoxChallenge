class Album {
  final String posterPath;
  final int id;
  final String title;
  final String overview;
  final List<int> genreids;
  final double popularity;
  final String releasedate;
  String get logoUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
  const Album({
    required this.posterPath,
    required this.id,
    required this.title,
    required this.overview,
    required this.genreids,
    required this.popularity,
    required this.releasedate,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      posterPath: json['backdrop_path'] ?? '',
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      genreids: List<int>.from(json['genre_ids']),
      popularity: (json['popularity'] as num).toDouble(),
      releasedate: json["release_date"] ?? '',
    );
  }
}
