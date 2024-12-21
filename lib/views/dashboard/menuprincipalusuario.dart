import 'package:cronosalud/widgets/container/container_shape01.dart';
import 'package:cronosalud/widgets/widget/menuitem.dart';
import 'package:flutter/material.dart';
import 'package:cronosalud/controllers/menu_controller.dart';

//menu principal usuario
class MenuUsuarioScreen extends StatelessWidget {
  final String userId;
  // final String? userType;

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
      ),
    );
  }
}
