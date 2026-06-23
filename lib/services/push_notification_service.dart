import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import '../screens/notificaciones_screen.dart';
import 'api_service.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      // 0. Configurar notificaciones locales para mostrar "heads-up" en primer plano
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await _localNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (details) {},
      );

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'Notificaciones Importantes',
        description: 'Este canal se usa para notificaciones importantes.',
        importance: Importance.max,
        playSound: true,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 1. Solicitar permisos (Necesario en iOS y Android 13+)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('Estado de permiso de notificaciones: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('Permiso concedido para notificaciones push');

        // 2. Obtener el token FCM del dispositivo
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          print('FCM Token obtenido: $token');
          // 3. Enviar el token al backend silenciosamente
          ApiService().registrarTokenFCM(token);
        } else {
          print('No se pudo obtener el token FCM');
        }

        // Detectar cuando el token cambia (por si el usuario reinstala la app)
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          ApiService().registrarTokenFCM(newToken);
        });

      } else {
        print('Permiso denegado para notificaciones push. Estado: ${settings.authorizationStatus}');
      }

      // 4. Configurar escuchador para mensajes en primer plano
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('>>> Mensaje recibido en primer plano: ${message.notification?.title}');

        RemoteNotification? notification = message.notification;

        if (notification != null) {
          // Guardar en el historial local
          NotificationStore().addNotification(
            notification.title ?? 'Nueva Notificación',
            notification.body ?? '',
          );

          // Disparar la notificación nativa con sonido en Android (heads-up)
          _localNotificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'Notificaciones Importantes',
                channelDescription: 'Este canal se usa para notificaciones importantes.',
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              ),
            ),
          );

          // También mostrar el pequeño SnackBar dentro de la app
          rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title ?? 'Nueva Notificación',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(notification.body ?? ''),
                ],
              ),
              backgroundColor: Colors.blueAccent,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      });

    } catch (e) {
      print('Error inicializando notificaciones: $e');
    }
  }
}
