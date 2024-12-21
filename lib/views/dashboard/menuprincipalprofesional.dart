import 'package:flutter/material.dart';

class MenuProfesionalScreen extends StatelessWidget {
  final String userId;

  const MenuProfesionalScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menú Principal - Profesional")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),
        children: [
          _buildMenuItem(Icons.people, "Pacientes", () {}),
          _buildMenuItem(Icons.mail, "Consultas", () {}),
          _buildMenuItem(Icons.calendar_today, "Horarios", () {}),
          _buildMenuItem(Icons.notifications, "Notificaciones", () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.lightBlueAccent),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
