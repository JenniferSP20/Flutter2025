import 'package:tap2025/services/movie_api.dart';
import 'package:flutter/material.dart';

class Credits extends StatefulWidget {
  const Credits({super.key});

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  MovieApi movieApi = MovieApi();
  Map<String, dynamic>? actores;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ObtenerActores();
  }

Future<void> ObtenerActores() async {
  try {
    var result = await movieApi.fetchCredits(912649);
    if (mounted) { // Verifica si el widget está montado
      setState(() {
        actores = result; // Guarda los actores obtenidos
        isLoading = false; // Cambia el estado a no cargando
      });
    }
  } catch (e) {
    print("Error obteniendo actores: $e");
    if (mounted) { // Verifica si el widget está montado
      setState(() {
        isLoading = false; // Cambia el estado a no cargando en caso de error
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator()); // Muestra un indicador de carga
    }

    if (actores == null) {
      return Center(
          child: Text(
              "No se encontraron actores.")); // Mensaje si no se encontraron actores
    }

    // Aquí puedes construir el widget que muestra los actores
    return ListView.builder(
      itemCount: actores!['cast']
          .length, // Suponiendo que 'cast' es la clave que contiene la lista de actores
      itemBuilder: (context, index) {
        final actor = actores!['cast'][index]; // Obtén el actor actual
        return ListTile(
          title: Text(actor['name']), // Nombre del actor
          subtitle: Text(actor['character']), // Personaje que interpreta
        );
      },
    );
  }
}