//https://api.themoviedb.org/3/movie/$movieId/videos?api_key=052ff25c66e82692ddc28fcea03247e2&language=es-MX

//https://api.themoviedb.org/3/movie/912649/videos?api_key=052ff25c66e82692ddc28fcea03247e2&language=es-MX

import 'dart:convert';

class Result {
  String iso6391;
  String iso31661;
  String name;
  String key;
  String site;
  int size;
  String type;
  bool official;
  DateTime publishedAt;
  String id;

  Result({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      iso6391: json['iso_639_1'],
      iso31661: json['iso_3166_1'],
      name: json['name'],
      key: json['key'],
      site: json['site'],
      size: json['size'],
      type: json['type'],
      official: json['official'],
      publishedAt: DateTime.parse(json['published_at']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_639_1': iso6391,
      'iso_3166_1': iso31661,
      'name': name,
      'key': key,
      'site': site,
      'size': size,
      'type': type,
      'official': official,
      'published_at': publishedAt.toIso8601String(),
      'id': id,
    };
  }
}