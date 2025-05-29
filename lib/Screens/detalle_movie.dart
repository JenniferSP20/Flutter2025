import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/Movie_model.dart';
import 'package:movie/services/movie_api.dart';
import 'package:movie/widgets/Comentarios.dart';
import 'package:movie/widgets/lista_actores_widget.dart';
import 'package:movie/widgets/triler_widget.dart';

class DetalleMovie extends StatefulWidget {
  const DetalleMovie({super.key});

  @override
  State<DetalleMovie> createState() => _DetalleMovieState();
}

class _DetalleMovieState extends State<DetalleMovie>
    with SingleTickerProviderStateMixin {
  MovieApi movieApi = MovieApi();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  int? id_movie;
  bool _isVisible = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _startDelay();

    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  void _startDelay() async {
    await Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieData = ModalRoute.of(context)?.settings.arguments as MovieModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pelicula:${movieData.originalTitle}'),
        centerTitle: true,
      ),

      body:
          _isVisible
              ? SingleChildScrollView(
                child: Hero(
                  tag: 'hero_${movieData.id}',
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  // Imagen de fondo con blur
                                  Image.network(
                                    'https://image.tmdb.org/t/p/w500/${movieData.posterPath}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ).blurred(
                                    blur: 10,
                                    colorOpacity: 0.4,
                                    borderRadius: BorderRadius.zero,
                                  ),

                                  // Contenido encima del blur
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 20,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Miniatura del póster
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w500/${movieData.posterPath}',
                                              width: 110,
                                              height: 165,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Información textual
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                      84,
                                                      255,
                                                      255,
                                                      255,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    movieData.title,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),

                                                const SizedBox(height: 8),
                                                Row(
                                                  children: _buildStarRating(
                                                    movieData.voteAverage,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                      84,
                                                      255,
                                                      255,
                                                      255,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Estreno: ${movieData.releaseDate}',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                        179,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // const Spacer(),
                                                SizedBox(height: 12),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      bool? confirm =
                                                          await movieApi
                                                              .addToFavorites(
                                                                movieData.id,
                                                              );
                                                      final scaffoldMessenger =
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          );
                                                      scaffoldMessenger.showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            confirm == true
                                                                ? 'Película agregada a favoritos'
                                                                : 'Se eliminó de favoritos',
                                                          ),
                                                          backgroundColor:
                                                              confirm == true
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          duration: Duration(
                                                            seconds: 2,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.favorite,
                                                      color: Colors.pinkAccent,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Descripción debajo del Stack
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                movieData.overview,
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text('REPARTO'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListaActoresWidget(movieData.id),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text('Trailer'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TrilerWidget(movieData.id),
                      ),
                      Padding(padding: const EdgeInsets.all(30.0)),
                    ],
                  ),
                ),
              )
              : SizedBox.shrink(),
    );
  }

  List<Widget> _buildStarRating(double rating) {
    int fullStars = (rating / 2).floor();
    bool hasHalfStar = (rating / 2) % 1 >= 0.5;
    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(
        const Icon(Icons.star, color: Color.fromARGB(255, 188, 9, 220)),
      );
    }

    if (hasHalfStar) {
      stars.add(
        const Icon(Icons.star_half, color: Color.fromARGB(255, 188, 9, 220)),
      );
    }

    while (stars.length < 5) {
      stars.add(
        const Icon(Icons.star_border, color: Color.fromARGB(255, 188, 9, 220)),
      );
    }

    return stars;
  }
}
