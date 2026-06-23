import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize(BuildContext context) async {
    try {
      // 1. Solicitar permisos (Necesario en iOS y Android 13+)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Permiso concedido para notificaciones push');
        
        // 2. Obtener el token FCM del dispositivo
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          print('FCM Token obtenido: $token');
          // 3. Enviar el token al backend silenciosamente
          ApiService().registrarTokenFCM(token);
        }

        // Detectar cuando el token cambia (por si el usuario reinstala la app)
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          ApiService().registrarTokenFCM(newToken);
        });

      } else {
        print('Permiso denegado para notificaciones push');
      }
    } catch (e) {
      print('Firebase Messaging no soportado en esta plataforma (ej. Windows): $e');
      return; // Salir silenciosamente en Windows
    }

    // 4. Configurar escuchador para mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Recibí un mensaje estando en la app: ${message.notification?.title}');
      
      if (message.notification != null) {
        // Mostrar un pequeño mensaje en la pantalla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.notification!.title ?? 'Nueva Notificación', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(message.notification!.body ?? ''),
              ],
            ),
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
  }
}
