import 'dart:convert';

import 'package:tap2025/models/Movie_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  final String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNTJmZjI1YzY2ZTgyNjkyZGRjMjhmY2VhMDMyNDdlMiIsIm5iZiI6MTczMDYwNDI0Ni43OTM4OTU3LCJzdWIiOiI2NmZlZjc4OGZhM2U2OWUwZWY3YzlmNDQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YvB5DsjbjTSiNS3AYZIO8YrdOdEQXDXDxAdeKm9gabo';
  Future<void> iniciarSesion() async {
    final tokenRequest = ObtenerTokenSession();
  }

  Future<String> ObtenerTokenSession() async {
    String tokenRequest = '';
    final url = Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/new',
    );

    final respuestaServer = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (respuestaServer.statusCode == 200) {
      final data = jsonDecode(respuestaServer.body);
      print('Código de estado: ${respuestaServer.statusCode}');
      print('Respuesta completa: ${respuestaServer.body}');

      if (data != null && data.isNotEmpty) {
        tokenRequest = data['request_token'];
        print('token= $tokenRequest');
        iniciarSesionApi(tokenRequest);
        print('Datos decodificados: $data');
        // Aquí podrías guardar el token si lo necesitas globalmente
      } else {
        throw Exception('No se encontraron datos');
      }
    } else {
      throw Exception('Error en la solicitud: ${respuestaServer.statusCode}');
    }
    return tokenRequest;
  }

  Future<String> iniciarSesionApi(String requestToken) async {
    print('INICIO DE SESIO');
    final url = Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/validate_with_login',
    );

    final bodyData = jsonEncode({
      "username": "megadeth_111",
      "password": "Miguel/12",
      "request_token": requestToken,
    });

    final respuestaServer = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
      body: bodyData,
    );

    if (respuestaServer.statusCode == 200) {
      final data = jsonDecode(respuestaServer.body);
      print('Código de estado: ${respuestaServer.statusCode}');
      print('Respuesta completa: ${respuestaServer.body}');

      if (data != null && data.isNotEmpty) {
        String tokenRequest = data['success'];
        print('token= $tokenRequest');
        return tokenRequest;
      } else {
        throw Exception('No se encontraron datos');
      }
    } else {
      throw Exception('Error en la solicitud: ${respuestaServer.statusCode}');
    }
  }
}
