import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:movie/models/Movie_model.dart';
import 'package:movie/services/auth_services.dart';
import 'package:movie/services/sessionManager.dart';

class MovieApi {
  final String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTJmZjI1YzY2ZTgyNjkyZGRjMjhmY2VhMDMyNDdlMiIsIm5iZiI6MTczMDYwNDI0Ni43OTM4OTU3LCJzdWIiOiI2NmZlZjc4OGZhM2U2OWUwZWY3YzlmNDQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YvB5DsjbjTSiNS3AYZIO8YrdOdEQXDXDxAdeKm9gabo';

  AuthServices authService = new AuthServices();
  final String apiKey = '052ff25c66e82692ddc28fcea03247e2';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final dio = Dio();
  Future<List<MovieModel>> getAllMovies() async {
    String url =
        'https://api.themoviedb.org/3/movie/popular?api_key=052ff25c66e82692ddc28fcea03247e2&language=es-MX&page=1';

    final response = await dio.get(url);
    final res = response.data['results'] as List;

    print('Respuesta de la API: ${response.data}');
    print('Cantidad de películas: ${res.length}');

    List<MovieModel> movies =
        res.map((movie) => MovieModel.fromMap(movie)).toList();

    for (var movie in movies) {
      print('Título: ${movie.title}, Poster: ${movie.posterPath}');
    }

    return movies;
  }

  Future<Map<String, dynamic>> fetchCredits(int idMovie) async {
    final apiKey = '052ff25c66e82692ddc28fcea03247e2';
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$idMovie/credits?api_key=$apiKey&language=es-MX',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> fetchTrailer(int idMovie) async {
    final apiKey = '052ff25c66e82692ddc28fcea03247e2';
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$idMovie/videos?api_key=$apiKey&language=es-MX',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0]; // Retorna solo el primer resultado
      } else {
        throw Exception('No se encontraron videos');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> Reviews(int idMovie) async {
    final apiKey = '052ff25c66e82692ddc28fcea03247e2';
    final url = Uri.parse(
      //https://api.themoviedb.org/3/movie/912649/reviews?api_key=052ff25c66e82692ddc28fcea03247e2&language=es-MX
      'https://api.themoviedb.org/3/movie/$idMovie/reviews?api_key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data; // Retorna solo el primer resultado
      } else {
        throw Exception('No se encontraron videos');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<bool?> addToFavorites(int movieId) async {
    final sessionId = await SessionManager.obtenerSessionID();

    // if (sessionId == null) {
    //   print('❌ No se encontró session ID');
    //   return;
    // }

    final String url =
        'https://api.themoviedb.org/3/list/8533596/add_item?session_id=$sessionId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'media_id': movieId}),
    );

    if (response.statusCode == 201) {
      print('✅ Película agregada a favoritos exitosamente.');
      return true;
    } else {
      MovieApi movieRemove = new MovieApi();
      bool? remo = await movieRemove.removeFromFavorites(movieId);

      print('❌ Se elimino el item de favoritos: ${response.statusCode}');
      print('Mensaje: ${response.body}');
      return false;
    }
  }

  Future<void> deleteToFavorites(
    String accountId,
    int movieId,
    bool isFavorite,
  ) async {
    final String url =
        'https://api.themoviedb.org/3/account/$accountId/favorite';
    final String bearerToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTJmZjI1YzY2ZTgyNjkyZGRjMjhmY2VhMDMyNDdlMiIsIm5iZiI6MTczMDYwNDI0Ni43OTM4OTU3LCJzdWIiOiI2NmZlZjc4OGZhM2U2OWUwZWY3YzlmNDQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YvB5DsjbjTSiNS3AYZIO8YrdOdEQXDXDxAdeKm9gabo';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': isFavorite,
      }),
    );

    if (response.statusCode == 200) {
      print('Película agregada a favoritos exitosamente.');
    } else {
      print('Error al agregar a favoritos: ${response.statusCode}');
      print('Mensaje: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> getFavoriteMovies(String accountId) async {
    final String url =
        'https://api.themoviedb.org/3/account/$accountId/favorite/movies?language=en-US&page=1&sort_by=created_at.asc';
    final String bearerToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTJmZjI1YzY2ZTgyNjkyZGRjMjhmY2VhMDMyNDdlMiIsIm5iZiI6MTczMDYwNDI0Ni43OTM4OTU3LCJzdWIiOiI2NmZlZjc4OGZhM2U2OWUwZWY3YzlmNDQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YvB5DsjbjTSiNS3AYZIO8YrdOdEQXDXDxAdeKm9gabo';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('Películas favoritas:');
      // print(data);
      return data;
      // Puedes procesar los datos como desees
    } else {
      print('Error al obtener películas favoritas: ${response.statusCode}');
      print('Mensaje: ${response.body}');
    }
    return null;
  }

  Future<bool?> removeFromFavorites(int movieId) async {
    final sessionId = await SessionManager.obtenerSessionID();

    if (sessionId == null) {
      print('❌ No se encontró session ID');
      return false;
    }

    final String url =
        'https://api.themoviedb.org/3/list/8533596/remove_item?session_id=$sessionId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'media_id': movieId}),
    );

    if (response.statusCode == 200) {
      print('🗑️ Película eliminada de favoritos exitosamente.');
      return true;
    } else {
      print('❌ Error al eliminar de favoritos: ${response.statusCode}');
      print('Mensaje: ${response.body}');
      return false;
    }
  }
}

  // Future<int> isFavoriteMovie(String accountId, int movieId) async {
  //   final String bearerToken =
  //       'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTJmZjI1YzY2ZTgyNjkyZGRjMjhmY2VhMDMyNDdlMiIsIm5iZiI6MTczMDYwNDI0Ni43OTM4OTU3LCJzdWIiOiI2NmZlZjc4OGZhM2U2OWUwZWY3YzlmNDQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YvB5DsjbjTSiNS3AYZIO8YrdOdEQXDXDxAdeKm9gabo';

  //   final String url =
  //       'https://api.themoviedb.org/3/account/$accountId/favorite/movies?language=en-US&page=1&sort_by=created_at.asc';

  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken',
  //       'Accept': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'media_type': 'movie',
  //       'media_id': movieId,
  //       'favorite': true,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     // Verifica si el ID de la película está en la lista de favoritos
  //     // final favoriteMovies = data['results'] as List;
  //     // int isFavorite = favoriteMovies.any((movie) => movie['id'] == movieId);
  //     // print('la respuesta en back=$isFavorite');
  //     return data;
  //   } else {
  //     print('Error al obtener películas favoritas: ${response.statusCode}');
  //     print('Mensaje: ${response.body}');
  //     return 0; // En caso de error, devuelve false
  //   }
  // }
  // Future<Map<String, dynamic>> fetchTrailer(int movieId) async {
  //   final apiKey = '052ff25c66e82692ddc28fcea03247e2';
  //   final response = await http.get(Uri.parse(
  //       'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey&language=es-MX'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print('es lo que trae la response en data ${data}');
  //     return json.decode(data[0]);
  //     // Devuelve el mapa decodificado
  //   } else {
  //     throw Exception('Failed to load trailer');
  //   }
  // }

