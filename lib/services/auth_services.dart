import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTJmZjI1YzY2ZTgyNjkyZGRjMjhmY2VhMDMyNDdlMiIsIm5iZiI6MTczMDYwNDI0Ni43OTM4OTU3LCJzdWIiOiI2NmZlZjc4OGZhM2U2OWUwZWY3YzlmNDQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YvB5DsjbjTSiNS3AYZIO8YrdOdEQXDXDxAdeKm9gabo';
  static final AuthServices _instancia = AuthServices._internal();
  factory AuthServices() => _instancia;
  AuthServices._internal();

  /// Inicia todo el proceso
  Future<void> iniciarSesion() async {
    try {
      final requestToken = await obtenerTokenSession();
      final validatedToken = await iniciarSesionApi(requestToken);
      final sessionID = await obtenerSesionID(validatedToken);
      final save = await guardarSessionID(sessionID);
      print("✅ Sesión iniciada con ID: $sessionID");
    } catch (e) {
      print("❌ Error durante inicio de sesión: $e");
    }
  }

  Future<void> guardarSessionID(String sessionID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', sessionID);
  }

  /// Paso 1: Obtener token de sesión
  Future<String> obtenerTokenSession() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/new',
    );

    final respuesta = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (respuesta.statusCode == 200) {
      final data = jsonDecode(respuesta.body);
      final token = data['request_token'];
      print('🔑 Token obtenido: $token');
      return token;
    } else {
      throw Exception('Error al obtener token: ${respuesta.statusCode}');
    }
  }

  /// Paso 2: Validar token con usuario/contraseña
  Future<String> iniciarSesionApi(String requestToken) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/validate_with_login',
    );

    final bodyData = jsonEncode({
      "username": "megadeth_111",
      "password": "Miguel/12",
      "request_token": requestToken,
    });

    final respuesta = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
      body: bodyData,
    );

    if (respuesta.statusCode == 200) {
      final data = jsonDecode(respuesta.body);
      final validatedToken = data['request_token'];
      print('✅ Token validado: $validatedToken');
      return validatedToken;
    } else {
      print('❌ Error validando token: ${respuesta.body}');
      throw Exception('Error validando token: ${respuesta.statusCode}');
    }
  }

  /// Paso 3: Obtener Session ID
  Future<String> obtenerSesionID(String requestToken) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/authentication/session/new',
    );

    final bodyData = jsonEncode({"request_token": requestToken});

    final respuesta = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
      body: bodyData,
    );

    if (respuesta.statusCode == 200) {
      final data = jsonDecode(respuesta.body);
      final sessionID = data['session_id'];
      print('🆔 Session ID obtenido: $sessionID');
      return sessionID;
    } else {
      print('❌ Error al obtener Session ID: ${respuesta.body}');
      throw Exception('Error creando sesión: ${respuesta.statusCode}');
    }
  }
}
