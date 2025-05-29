import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Favoritoscontroller {
  final String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTJmZjI1YzY2ZTgyNjkyZGRjMjhmY2VhMDMyNDdlMiIsIm5iZiI6MTczMDYwNDI0Ni43OTM4OTU3LCJzdWIiOiI2NmZlZjc4OGZhM2U2OWUwZWY3YzlmNDQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YvB5DsjbjTSiNS3AYZIO8YrdOdEQXDXDxAdeKm9gabo';

  Future<String?> obtenerSessionID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }

  Future<List<Map<String, dynamic>>> obtenerFavoritos() async {
    final url = Uri.parse('https://api.themoviedb.org/3/list/8533596');

    final respuesta = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (respuesta.statusCode == 200) {
      final data = jsonDecode(respuesta.body);
      final List favoritos = data['items'];
      return favoritos.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al obtener favoritos: ${respuesta.statusCode}');
    }
  }
  
}
