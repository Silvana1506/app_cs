import 'package:cronosalud/views/dashboard/enviarmensajescreen.dart';
import 'package:cronosalud/views/dashboard/interfaz_examenes.dart';
import 'package:cronosalud/views/notificacion/notificacionscreen.dart';
import 'package:cronosalud/widgets/buttons/custombottombar.dart';
import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:cronosalud/widgets/widget/menuitem.dart';
import 'package:flutter/material.dart';
import 'package:cronosalud/controllers/menuitemcontroller.dart';

class MenuUsuarioScreen extends StatelessWidget {
  final String userId;

  const MenuUsuarioScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Utilizando el método estático 'buildMenuItems' de MenuitemController
    final menuItems = MenuitemController.buildMenuItems(context, userId);
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Imagen de fondo
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imagen1.jpg'),
                  fit: BoxFit.cover, // La imagen cubre toda la pantalla
                ),
              ),
            ),
            // Contenido principal
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContainerShape01(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.15),
                    const Text(
                      "Menú Principal",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return MenuItemWidget(
                          menuItem: item,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Barra de navegación inferior personalizada
        bottomNavigationBar: CustomBottomBar(
          currentIndex: 0, // Índice inicial
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MenuUsuarioScreen(userId: userId)));
                break;
              case 1:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationScreen(userId: userId)));
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EnviarMensajeScreen(userId: userId)));
                break;
              case 3:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InterfazExamenes(userId: userId)));
                break;
            }
          },
        ),
      ),
    );
  }
}
