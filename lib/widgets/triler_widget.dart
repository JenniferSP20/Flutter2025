import 'package:flutter/material.dart';
import 'package:movie/services/movie_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrilerWidget extends StatefulWidget {
  final int id;

  const TrilerWidget(this.id, {super.key});

  @override
  _TrilerWidgetState createState() => _TrilerWidgetState();
}

class _TrilerWidgetState extends State<TrilerWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future:
          MovieApi().fetchTrailer(widget.id), // Llama a la función fetchTrailer
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se está esperando la respuesta
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Si ocurre un error
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Si no hay datos
          return Center(child: Text('No se pudo cargar el tráiler.'));
        }

        // **Corrected section:**
        if (snapshot.hasData) {
          final trailer = snapshot.data!;
          String videoId = trailer['key'];

          return YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            ),
          );
        }

        // This code will not be reached if data is available
        return Container(); // You can return an empty container here
      },
    );
  }
}