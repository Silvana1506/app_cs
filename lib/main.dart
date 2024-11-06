//import 'package:app_cs/MainScreens/login/welcomeScreen.dart';
import 'package:app_cs/MainScreens/login/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
//import 'package:app_cs/MainScreens/widgets/DesignWidgets.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(const MyApp());
}

void setup() async {
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 249, 248, 250)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
