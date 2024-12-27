import 'package:cronosalud/views/dashboard/citasmedicasscreen.dart';
import 'package:cronosalud/models/menu_item_model.dart';
import 'package:cronosalud/views/dashboard/patologiasscreen.dart';
import 'package:cronosalud/views/dashboard/perfil_screen.dart';
import 'package:cronosalud/views/dashboard/ingresodatosalud.dart';
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
            builder: (context) => PatologiasScreen(userId: userId),
          ),
        ),
      ),
    ];
  }
}
