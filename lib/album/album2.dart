class Album2 {
  final String posterPath;
  final int id;
  final int budget;
  final String title;
  final String overview;
  final List<String> genreids;
  final double popularity;
  final String releasedate;
  String get logoUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
  const Album2({
    required this.posterPath,
    required this.id,
    required this.budget,
    required this.title,
    required this.overview,
    required this.genreids,
    required this.popularity,
    required this.releasedate,
  });

  factory Album2.fromJson(Map<String, dynamic> json) {
    var genresFromJson = json['genres'] as List;
    List<String> genresList =
        genresFromJson.map((genre) => genre['name'] as String).toList();
    return Album2(
      posterPath: json['backdrop_path'] ?? '',
      id: json['id'] ?? '',
      budget: json['budget'] ?? '',
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      genreids: genresList,
      popularity: (json['popularity'] as num).toDouble(),
      releasedate: json["release_date"] ?? '',
    );
  }
}
