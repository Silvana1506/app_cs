import 'package:flutter/material.dart';

//LA PARTE SUPERIOR DE LA PANTALLA DONDE APARECE LA IMAGEN Y VOLVER
class ContainerShape01 extends StatelessWidget {
  const ContainerShape01({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      width: MediaQuery.of(context).size.width,
      color: Colors.white, // Fondo blanco
      child: Center(
        child: Image.asset(
          'assets/images/logo_crono.png', // Ruta de la imagen en tu proyecto
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
