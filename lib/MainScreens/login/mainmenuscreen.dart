import 'package:cronosalud/MainScreens/login/menuitem.dart';
import 'package:cronosalud/MainScreens/widgets/components/buttons/my_back_button.dart';
import 'package:cronosalud/MainScreens/widgets/components/container/container_shape01.dart';
import 'package:cronosalud/Utils/menu_utils.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final String userId;
  const MainMenuScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final menuItems = buildMenuItems(context, userId);
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
                  image: AssetImage('assets/images/imagen4.jpg'),
                  fit: BoxFit.cover, // La imagen cubre toda la pantalla
                ),
              ),
            ),
            // Fondo decorativo en la parte superior
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
                      shrinkWrap:
                          true, // Necesario para GridView dentro de SingleChildScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), // Deshabilita scroll adicional
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Número de columnas
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return MenuItem(
                          icon: item['icon'],
                          title: item['title'],
                          onPressed: item['onPressed'] ??
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Acción no definida'),
                                  ),
                                );
                              },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Botón de retroceso
            Positioned(
              top: height * 0.01,
              left: 0.01,
              child: const MyBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
