import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: const Center(
        child: Text(
          'Aquí se mostrarán las notificaciones recibidas.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
