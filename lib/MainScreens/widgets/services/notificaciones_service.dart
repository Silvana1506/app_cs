import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _setupFirebaseMessaging();
    await _setupLocalNotifications();
  }

  Future<void> _setupFirebaseMessaging() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      developer.log('Usuario autorizó notificaciones.');
    } else {
      developer.log('Usuario no autorizó notificaciones.');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        showNotification(
          notification.hashCode,
          notification.title ?? 'Sin título',
          notification.body ?? 'Sin cuerpo',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('Notificación abierta: ${message.notification?.title}');
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    String? token = await _firebaseMessaging.getToken();
    developer.log("Firebase Token: $token");
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          developer.log('Payload recibido: ${response.payload}');
        }
      },
    );
  }

  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Canal principal de notificaciones',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('Mensaje recibido en segundo plano: ${message.messageId}');
}
