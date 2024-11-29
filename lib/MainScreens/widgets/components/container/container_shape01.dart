import 'package:flutter/material.dart';

//LA PARTE SUPERIOR DE LA PANTALLA DONDE APARECE LA IMAGEN Y VOLVER
class ContainerShape01 extends StatelessWidget {
  const ContainerShape01({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 450, //double.infinity, // Ocupa todo el ancho disponible
        height: 150, //MediaQuery.of(context).size.height * 0.15,
        alignment: Alignment.center, // Centra la imagen
        clipBehavior: Clip.hardEdge, // 15% de la altura
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Image.asset(
          'assets/images/logo_crono.png',
          fit: BoxFit.contain,
          //fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.high, // Alta calidad de renderizado
        ),
      ),
    );
  }
}
