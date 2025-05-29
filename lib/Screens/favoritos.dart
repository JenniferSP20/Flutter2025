import 'package:flutter/material.dart';
import 'package:movie/models/Movie_model.dart';
import 'package:movie/services/favoritosController.dart';
import 'package:movie/services/movie_api.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<Map<String, dynamic>> _peliculas = [];
  bool _cargando = true;
  final controller = Favoritoscontroller();
  MovieApi movie = new MovieApi();

  @override
  void initState() {
    super.initState();
    cargarFavoritos();
  }

  Future<void> cargarFavoritos() async {
    try {
      final favoritos = await controller.obtenerFavoritos();
      setState(() {
        _peliculas = favoritos;
        _cargando = false;
      });
    } catch (e) {
      print("Error cargando favoritos: $e");
    }
  }

  Future<bool> eliminarFavorito(int mediaId) async {
    try {
      final result = await movie.removeFromFavorites(mediaId);
      return result ?? false;
    } catch (e) {
      print("Error eliminando favorito: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body:
          _cargando
              ? const Center(child: CircularProgressIndicator())
              : _peliculas.isEmpty
              ? const Center(child: Text('No hay favoritos'))
              : ListView.builder(
                itemCount: _peliculas.length,
                itemBuilder: (context, index) {
                  final pelicula = _peliculas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading:
                          pelicula['poster_path'] != null
                              ? Image.network(
                                'https://image.tmdb.org/t/p/w92${pelicula['poster_path']}',
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.movie),
                      title: Text(pelicula['title'] ?? 'Sin título'),
                      subtitle: Text(
                        pelicula['overview'] ?? 'Sin descripción',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        final movieModel = MovieModel.fromMap(pelicula);
                        Navigator.pushNamed(
                          context,
                          '/detalle',
                          arguments: movieModel,
                        );
                      },

                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final int movieId = pelicula["id"];
                          bool success = await eliminarFavorito(movieId);

                          final messenger = ScaffoldMessenger.of(context);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Película eliminada de favoritos'
                                    : 'No se pudo eliminar',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );

                          if (success) {
                            setState(() {
                              _peliculas.removeAt(index);
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
