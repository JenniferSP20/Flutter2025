import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<String?> obtenerSessionID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }
}
