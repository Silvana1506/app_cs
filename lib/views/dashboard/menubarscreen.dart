import 'package:cronosalud/views/dashboard/enviarmensajescreen.dart';
import 'package:cronosalud/views/dashboard/interfaz_examenes.dart';
import 'package:cronosalud/views/dashboard/menuprincipalusuario.dart';
import 'package:cronosalud/views/dashboard/perfil_usuario.dart';
import 'package:cronosalud/views/notificacion/notificacionscreen.dart';
import 'package:flutter/material.dart';

// Pantalla Principal abajo
class MenuBarScreen extends StatefulWidget {
  final String userId;
  // final String? userType; // Añadido userType

  const MenuBarScreen({super.key, required this.userId});

  @override
  State<MenuBarScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuBarScreen> {
  int _currentIndex = 0;

  // Lista de widgets para cada pestaña de navegación
  late final List<Widget> _screens = [
    MenuUsuarioScreen(
      userId: widget.userId,
    ),
    PerfilScreenUsuario(
      userId: widget.userId,
    ),
    const NotificationScreen(),
    EnviarMensajeScreen(),
    ExamenesScreen(userId: widget.userId),
  ];

  // Cambiar pestaña
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[
            _currentIndex], // Aquí cargamos la pantalla correspondiente dinámicamente
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Mi Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificación',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Mensaje',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Examenes',
            ),
          ],
        ),
      ),
    );
  }
}
