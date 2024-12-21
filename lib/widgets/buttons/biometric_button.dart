import 'package:flutter/material.dart';

class BiometricButton extends StatelessWidget {
  final IconData icon; // Icono para mostrar
  final VoidCallback? onPressed; // Acción al presionar

  const BiometricButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        icon,
        size: 80.0, // Tamaño grande del icono
        color: Colors.black, // Color del icono
      ),
    );
  }
}
