import 'package:tap2025/services/movie_api.dart';
import 'package:flutter/material.dart';

class ListaActoresWidget extends StatefulWidget {
  final int id;
  const ListaActoresWidget(this.id, {super.key});

  @override
  State<ListaActoresWidget> createState() => _ListaActoresWidgetState();
}

class _ListaActoresWidgetState extends State<ListaActoresWidget> {
  MovieApi movieApi = MovieApi();
  Map<String, dynamic>? actores;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ObtenerActores(widget.id);
  }

  Future<void> ObtenerActores(int id) async {
    try {
      var result = await movieApi.fetchCredits(id);
      if (mounted) {
        setState(() {
          actores = result;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error obteniendo actores: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
    }

    if (actores == null || actores!['cast'].isEmpty) {
      return const Center(
        child: Text(
          "No se encontraron actores.",
          style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: actores!['cast'].length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final actor = actores!['cast'][index];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            width: 110,
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: actor['profile_path'] == null
                      ? Container(
                          width: 70,
                          height: 70,
                          color: Colors.deepPurple[100],
                          child: const Icon(Icons.person, size: 40, color: Colors.white),
                        )
                      : Image.network(
                          'https://image.tmdb.org/t/p/w500/${actor['profile_path']}',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 70,
                              height: 70,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    actor['name'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
