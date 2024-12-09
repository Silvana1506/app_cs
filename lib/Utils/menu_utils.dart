import 'package:cronosalud/MainScreens/login/perfilscreen.dart';
import 'package:cronosalud/MainScreens/widgets/widget/interfazcitas.dart';
import 'package:cronosalud/MainScreens/widgets/widget/interfazmedicamento.dart';
import 'package:cronosalud/MainScreens/widgets/widget/notificacionscreen.dart';
import 'package:cronosalud/main.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> buildMenuItems(BuildContext context, String userId) {
  return [
    {
      'icon': Icons.person,
      'title': 'Mi Perfil',
      'onPressed': () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PerfilScreen(userId: userId)),
          ),
    },
    {
      'icon': Icons.medical_services,
      'title': 'Medicamentos',
      'onPressed': () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InterfazmedicamentoScreen()),
          ),
    },
    {
      'icon': Icons.access_time,
      'title': 'Citas',
      'onPressed': () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InterfazcitasScreen()),
          ),
    },
    {
      'icon': Icons.notifications_active,
      'title': 'Notificaciones',
      'onPressed': () {
        notificationService.showNotification(
          1,
          'Título',
          'Mensaje',
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
      },
    },
  ];
}
