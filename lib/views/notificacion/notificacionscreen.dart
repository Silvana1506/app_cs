import 'package:flutter/material.dart';
import 'package:cronosalud/controllers/notificaciones_service.dart';

class NotificationScreen extends StatefulWidget {
  final String userId; // Agregar un campo para userId

  const NotificationScreen(
      {super.key, required this.userId}); // Requiere el userId

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.init(widget.userId); // Pasar el userId aquí
  }

  // Método para mostrar la notificación
  void _showNotification() {
    _notificationService.showNotification(
        1, // Asegúrate de pasar un int aquí como ID
        'Recordatorio',
        'Es hora de tomar tu medicamento.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showNotification,
              child: const Text('Mostrar notificación'),
            ),
          ],
        ),
      ),
    );
  }
}
