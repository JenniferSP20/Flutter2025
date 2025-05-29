import 'package:flutter/material.dart';
import 'package:movie/services/movie_api.dart';

class Comentarios extends StatefulWidget {
  final int id;
  const Comentarios(this.id, {super.key});

  @override
  State<Comentarios> createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  MovieApi movieApi = MovieApi();

  @override
  Widget build(BuildContext context) {
    const authorStyle = TextStyle(
      color: Colors.deepPurple,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    const contentStyle = TextStyle(
      color: Colors.black87,
      fontSize: 14,
      height: 1.4,
    );

    return FutureBuilder(
      future: movieApi.Reviews(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List reviews = snapshot.data!['results'];

          return SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            height: MediaQuery.of(context).size.height * .75,
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final avatarPath = review['author_details']['avatar_path'];
                final imageUrl = avatarPath != null
                    ? (avatarPath.contains('http')
                        ? avatarPath.replaceFirst('/', '')
                        : 'https://image.tmdb.org/t/p/w500/$avatarPath')
                    : null;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple[100],
                        backgroundImage:
                            imageUrl != null ? NetworkImage(imageUrl) : null,
                        child: imageUrl == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(review['author'], style: authorStyle),
                            const SizedBox(height: 6),
                            Text(
                              review['content'] ?? 'No hay contenido.',
                              style: contentStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Error al cargar los datos'));
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }
      },
    );
  }
}
