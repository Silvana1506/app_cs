import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;

class NotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicita permisos para recibir notificaciones (iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      developer.log('Usuario autorizó notificaciones.');
    } else {
      developer.log('Usuario no autorizó notificaciones.');
    }

    // Manejo de notificaciones en segundo plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log('Nueva notificación: ${message.notification?.title}');
    });

    // Manejo de notificaciones al tocar la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('Notificación abierta: ${message.notification?.title}');
    });
  }
}
