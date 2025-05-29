import 'package:flutter/material.dart';
import 'package:movie/Screens/detalle_movie.dart';
import 'package:movie/Screens/favoritos.dart';
import 'package:movie/Screens/initApp.dart';
import 'package:movie/Screens/movies_screen.dart';
import 'package:movie/Screens/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔴 IMPORTANTE
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: const Initapp(),
        routes: {
          "/detalle": (context) => const DetalleMovie(),
          "/api": (context) => const MoviesScreen(),
          "/favoritos": (context) => const Favoritos(),
          "/22": (context) => const TestSessionScreen(),
        },
      ),
    );
  }
}
