import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie/services/auth_services.dart';

class Initapp extends StatelessWidget {
  const Initapp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo desde Internet
          Image.network(
            // 'https://wallpapercave.com/wp/wp1945909.jpg',
            'https://s0.smartresize.com/wallpaper/166/724/HD-wallpaper-amlo-mexico-prian.jpg',
            fit: BoxFit.cover,
          ),

          // Capa oscura para contraste
          Container(color: Colors.black.withOpacity(0.6)),

          // Contenido centrado
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Videoteca Del Bienestar',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      AuthServices auth = AuthServices();
                      await auth.iniciarSesion(); // solo esperar, sin resultado
                      // Navigator.pushNamed(context, '/dash');
                    } catch (e) {
                      print("Fallo en el token: $e");
                      // Mostrar error, etc.
                    }
                    Navigator.pushReplacementNamed(context, '/api');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 12,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 28),
                  label: const Text(
                    'INICIAR',
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
