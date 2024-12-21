import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cronosalud/controllers/notificaciones_service.dart';
import 'package:cronosalud/views/login/reset_password_screen.dart';
import 'package:cronosalud/views/login/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'dart:developer' as developer;

final NotificationService notificationService = NotificationService();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Obtén userId del usuario autenticado
  final user = FirebaseAuth.instance.currentUser;
  String? userId = user?.uid;

  if (userId != null) {
    await notificationService.init(userId);
  } else {
    developer.log('No se encontró un usuario autenticado.');
  }

  await Future.delayed(const Duration(seconds: 1));
  await AndroidAlarmManager.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CronoSalud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: _getInitialScreen(), // Determinar la pantalla inicial
    );
  }

  Widget _getInitialScreen() {
    // Verificar si se está accediendo con un enlace de restablecimiento de contraseña
    final String? oobCode = Uri.base.queryParameters['oobCode'];

    if (oobCode != null && oobCode.isNotEmpty) {
      return ResetPasswordScreen(
          oobCode: oobCode); // Ir a la vista de restablecimiento
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const WelcomeScreen(); // Usuario no autenticado
    }
    // Mostrar la vista inicial del usuario autenticado (puede ser Dashboard)
    return const WelcomeScreen(); // Puedes cambiar por Dashboard u otra vista
  }
}
