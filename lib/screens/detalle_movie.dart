import 'package:tap2025/models/Movie_model.dart';
import 'package:tap2025/services/movie_api.dart';
import 'package:tap2025/widgets/Comentarios.dart';
import 'package:tap2025/widgets/lista_actores_widget.dart';
import 'package:tap2025/widgets/triler_widget.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

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
        title: Text('Movie: ${movieData.originalTitle}'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModal(context, movieData.id);
        },
        child: Icon(Icons.reviews),
      ),
      body: _isVisible
          ? SingleChildScrollView(
              child: Hero(
                tag: 'hero_${movieData.id}',
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500/${movieData.posterPath}',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ).blurred(
                            colorOpacity: 0.5,
                            borderRadius: BorderRadius.zero,
                            blur: 10,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.06,
                            left: MediaQuery.of(context).size.width * 0.05,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.zero,
                                child: _isVisible
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w500/${movieData.posterPath}',
                                        fit: BoxFit.cover,
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.06,
                            left: MediaQuery.of(context).size.width * 0.3,
                            child: IconButton(
                              onPressed: () async {
                                MovieApi movieApi = MovieApi();
                                movieApi.addToFavorites(
                                    '21551989', movieData.id, true);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: const Color.fromARGB(255, 188, 9, 220),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.025,
                            left: MediaQuery.of(context).size.width * 0.015,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Row(
                                children:
                                    _buildStarRating(movieData.voteAverage),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.06,
                            left: MediaQuery.of(context).size.width * 0.48,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .50,
                              height: MediaQuery.of(context).size.height * .33,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${movieData.title}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  Text(
                                    '${movieData.id}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      '${movieData.releaseDate}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      '${movieData.overview}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
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
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                    ),
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
      stars.add(const Icon(Icons.star, color: Color.fromARGB(255, 188, 9, 220)));
    }

    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Color.fromARGB(255, 188, 9, 220)));
    }

    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, color: Color.fromARGB(255, 188, 9, 220)));
    }

    return stars;
  }

  void showModal(BuildContext context, int id) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .05,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Comentarios de la pelicula',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Comentarios(id),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cerrar'),
                ),
              ],
            ),
          );
        });
  }
}
