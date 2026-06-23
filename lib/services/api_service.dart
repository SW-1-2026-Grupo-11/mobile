import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models.dart';

class ApiService {
  // Conectado al backend en la nube
  static const String baseUrl = 'https://api.albadev.me/api';
  static String? token;
  static String? userRole;
  static String? userFirstName;
  static String? userLastName;
  static String? userEmail;
  static String? userPhone;

  Map<String, dynamic> _decodeToken(String tkn) {
    try {
      final parts = tkn.split('.');
      if (parts.length != 3) return {};
      String payload = parts[1];
      payload = payload.padRight(payload.length + (4 - payload.length % 4) % 4, '=');
      final resp = utf8.decode(base64Url.decode(payload));
      return jsonDecode(resp);
    } catch (e) {
      return {};
    }
  }

  // Login manual
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['access'];

        // Extraer ID y obtener el rol del usuario
        final decodedToken = _decodeToken(token!);
        final userId = decodedToken['user_id'];
        if (userId != null) {
          final userResp = await http.get(
            Uri.parse('$baseUrl/usuarios/usuarios/$userId/'),
            headers: {'Authorization': 'Bearer $token'},
          );
          if (userResp.statusCode == 200) {
            final userData = jsonDecode(utf8.decode(userResp.bodyBytes));
            userRole = userData['rol']?.toString().toLowerCase(); 
            userFirstName = userData['first_name'];
            userLastName = userData['last_name'];
            userEmail = userData['email'];
            userPhone = userData['telefono'];
          } else {
            print('Error fetching user profile: ${userResp.statusCode}');
          }
        }

        return true;
      }
    } catch (e) {
      print('Error en login: $e');
    }
    return false;
  }

  Future<List<Entrevista>> getEntrevistas() async {
    if (token == null) return [];
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/entrevistas/entrevistas/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        List data = [];
        if (decoded is Map && decoded.containsKey('results')) {
          data = decoded['results'] ?? [];
        } else if (decoded is List) {
          data = decoded;
        }
        return data.map((e) => Entrevista.fromJson(Map<String, dynamic>.from(e))).toList();
      }
    } catch (e) {
      print('Error al obtener entrevistas: $e');
    }
    return []; // Fallback si falla
  }

  Future<bool> programarEntrevista({
    required String titulo,
    required String descripcion,
    required String fechaProgramada,
    int? duracionMinutos,
    required int pruebaId,
    required List<Map<String, String>> invitados,
  }) async {
    if (token == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/entrevistas/entrevistas/programar/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'titulo': titulo,
          'descripcion': descripcion,
          'fecha_programada': fechaProgramada,
          if (duracionMinutos != null) 'duracion_minutos': duracionMinutos,
          'prueba_id': pruebaId,
          'invitados': invitados,
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error programar: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al programar entrevista: $e');
      return false;
    }
  }

  Future<bool> registrarTokenFCM(String fcmToken) async {
    if (token == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/fcm-token/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': fcmToken}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error al registrar token FCM: $e');
      return false; // Silent fail if backend is not ready
    }
  }

  Future<List<Reporte>> getReportes() async {
    if (token == null) return [];
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reportes/reportes/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        List data = [];
        if (decoded is Map && decoded.containsKey('results')) {
          data = decoded['results'] ?? [];
        } else if (decoded is List) {
          data = decoded;
        }
        return data.map((e) => Reporte.fromJson(Map<String, dynamic>.from(e))).toList();
      }
    } catch (e) {
      print('Error al obtener reportes: $e');
    }
    return []; // Fallback si falla
  }

  Future<List<Prueba>> getPruebas() async {
    if (token == null) return [];
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pruebas/pruebas/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        List data = [];
        if (decoded is Map && decoded.containsKey('results')) {
          data = decoded['results'] ?? [];
        } else if (decoded is List) {
          data = decoded;
        }
        return data.map((e) => Prueba.fromJson(Map<String, dynamic>.from(e))).toList();
      }
    } catch (e) {
      print('Error al obtener pruebas: $e');
    }
    return [];
  }
}
