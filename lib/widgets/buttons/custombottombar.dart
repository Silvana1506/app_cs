import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.blueGrey[900], // Color de fondo oscuro
      selectedItemColor: Colors.white, // Color para el elemento seleccionado
      unselectedItemColor:
          Colors.grey[400], // Color para elementos no seleccionados
      type: BottomNavigationBarType
          .fixed, // Para evitar el efecto de desplazamiento
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Mensajes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Exámenes',
        ),
      ],
    );
  }
}
