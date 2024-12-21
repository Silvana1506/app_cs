import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Guardar el token del dispositivo en Firestore
  Future<void> saveDeviceToken(String userId) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'deviceToken': token});
        developer.log('Token guardado con éxito: $token');
      } else {
        developer.log('No se pudo obtener el token.');
      }
    } catch (e) {
      developer.log('Error al guardar el token del dispositivo: $e');
    }
  }

  // Inicializar el servicio de notificaciones
  Future<void> init(String userId) async {
    tz.initializeTimeZones(); // Inicializar las zonas horarias
    await _setupFirebaseMessaging(userId);
    await _setupLocalNotifications();
    developer.log('Servicio de notificaciones inicializado correctamente.');
  }

  // Configuración de Firebase Messaging
  Future<void> _setupFirebaseMessaging(String userId) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      developer.log('Usuario autorizó las notificaciones.');
      await saveDeviceToken(userId);
    } else {
      developer.log('El usuario no autorizó las notificaciones.');
    }
    // Escuchar notificaciones en primer plano
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
    // Manejar notificaciones cuando la app se abre desde una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('Notificación abierta: ${message.notification?.title}');
    });
    // Manejar mensajes en segundo plano
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // Obtener y mostrar el token del dispositivo
    String? token = await _firebaseMessaging.getToken();
    developer.log("Firebase Token: $token");
  }

  // Configuración de notificaciones locales
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

  // Mostrar una notificación inmediata
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

  // Programar notificaciones recurrentes
  Future<void> scheduleRecurringNotification(
      String title, String body, int hour, int minute) async {
    final androidDetails = AndroidNotificationDetails(
      'recurring_channel',
      'Recurring Notifications',
      channelDescription: 'Canal para notificaciones recurrentes',
      importance: Importance.high,
      priority: Priority.high,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1, // ID único
      title,
      body,
      _nextInstanceOf(hour, minute),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repetir diario
    );
  }

  // Calcular la próxima instancia para una hora específica
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

// Manejador de mensajes en segundo plano
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('Mensaje recibido en segundo plano: ${message.messageId}');
}
