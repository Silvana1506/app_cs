import 'package:cronosalud/MainScreens/login/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'CronoSalud',
      //theme: ThemeData(
      // primarySwatch: Colors.blue,
      //fontFamily: 'Roboto',
      //),
      title: 'Notificaciones Push',
      home: Scaffold(
        appBar: AppBar(title: const Text('Notificaciones Push')),
        body: const Center(child: Text('Configuración Inicial Completa')),
      ),
      //home: const WelcomeScreen(),
    );
  }
}
