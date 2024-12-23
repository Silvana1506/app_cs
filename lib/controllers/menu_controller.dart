import 'package:cronosalud/views/dashboard/citasmedicasscreen.dart';
import 'package:cronosalud/models/menu_item_model.dart';
import 'package:cronosalud/views/dashboard/enviarmensajescreen.dart';
import 'package:cronosalud/views/dashboard/interfaz_datos_historicos.dart';
import 'package:cronosalud/views/dashboard/interfaz_examenes.dart';
import 'package:cronosalud/views/dashboard/perfil_screen.dart';
import 'package:cronosalud/views/dashboard/ingresodatosalud.dart';
import 'package:cronosalud/views/dashboard/tratamientos.dart';
import 'package:cronosalud/views/notificacion/notificacionscreen.dart';
import 'package:flutter/material.dart';

class MenuitemController {
  final String userId;
  final String? userType;
  // Constructor
  MenuitemController({
    required this.userId,
    this.userType,
  });

  static List<MenuItemModel> buildMenuItems(BuildContext context, String userId,
      {String? userType}) {
    userType ??= "usuario";
    return [
      MenuItemModel(
        icon: Icons.person,
        title: 'Mi Perfil',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PerfilScreenUsuario(userId: userId),
          ),
        ),
      ),
      MenuItemModel(
        icon: Icons.medical_services,
        title: 'Medicamentos',
        onPressed: () {
          // Acción para navegar a Medicamentos
        },
      ),
      MenuItemModel(
        icon: Icons.access_time,
        title: 'Citas',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CitasMedicasScreen(userId: userId),
          ),
        ),
      ),
      MenuItemModel(
        icon: Icons.notifications_active,
        title: 'Notificaciones',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        ),
      ),
      MenuItemModel(
        icon: Icons.health_and_safety,
        title: 'Datos de Salud',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IngresoDatoSaludScreen(userId: userId),
          ),
        ),
      ),
      MenuItemModel(
        icon: Icons.assignment,
        title: 'Tratamientos',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TratamientosScreen(userId: userId),
          ),
        ),
      ),
      MenuItemModel(
        icon: Icons.show_chart,
        title: 'Historial de mis Datos Salud',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoricalDataScreen(userId: userId),
          ),
        ),
      ),
      MenuItemModel(
        icon: Icons.description,
        title: 'Examenes',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InterfazExamenes(userId: userId),
          ),
        ),
      ),
      MenuItemModel(
        icon: Icons.message,
        title: 'Mensajes',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnviarMensajeScreen(userId: userId),
          ),
        ),
      ),
    ];
  }
}
