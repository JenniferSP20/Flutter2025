import 'package:flutter/material.dart';
import 'package:movie/models/Movie_model.dart';
import 'package:movie/services/movie_api.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  bool _isVisible = false;

  void _startDelay() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isVisible = true;
    });
  }

  MovieApi? movieApi;

  @override
  void initState() {
    super.initState();
    _startDelay();
    movieApi = MovieApi();
  }

  @override
  Widget build(BuildContext context) {
    // Tema personalizado SOLO para esta pantalla
    final localTheme = Theme.of(context).copyWith(
      scaffoldBackgroundColor: const Color(0xFFF3E5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6A1B9A),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: const Color(0xFF7B1FA2),
        secondary: const Color(0xFFE1BEE7),
      ),
    );

    return Theme(
      data: localTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todos tus estrenos en un clic :)'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/favoritos');
                },
                icon: const Icon(Icons.favorite, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
        body:
            _isVisible
                ? FutureBuilder(
                  future: movieApi!.getAllMovies(),
                  builder: (context, AsyncSnapshot<List<MovieModel>> snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: .7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return CardPopular(snapshot.data![index]);
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Ocurrió un error :('));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget CardPopular(MovieModel movie) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detalle', arguments: movie),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade200.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xAA4A148C)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
