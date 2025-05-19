import 'package:flutter/material.dart';
import 'package:tap2025/screens/challenge_screen.dart';
import 'package:tap2025/screens/challengep2_screen.dart';
import 'package:tap2025/screens/contador_screen.dart';
import 'package:tap2025/screens/dashboard_screen.dart';
import 'package:tap2025/screens/login_screen.dart';
import 'package:tap2025/screens/popular_screen.dart';
import 'package:tap2025/utils/global_values.dart';
import 'package:tap2025/utils/theme_settings.dart';
import 'package:tap2025/screens/detail_popular_movie.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder(
      valueListenable: GlobalValues.themeMode,
      builder: (context, value, widget) {
        return MaterialApp(
          theme: ThemeSettings.setTheme(value),
          debugShowCheckedModeBanner:false,
          home: const LoginScreen(),
          routes: {
            "/dash" : (context) => const DashboardScreen(),
            "/reto" : (context) => const ChallengScreen(),
            "/api" : (context) => const PopularScreen(),
            "/cha" : (context) => const Challengep2Screen(),
            "/detail" : (context) => const DetailPopularMovie()
          },
        );
      }
    );
  }
}



