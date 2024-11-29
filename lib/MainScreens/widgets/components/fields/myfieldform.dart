import 'package:flutter/material.dart';

class Myfieldform extends StatelessWidget {
  final String tittle;
  final bool isPassword;
  final IconData? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // Agregamos el nuevo parámetro

  const Myfieldform({
    super.key,
    required this.tittle,
    this.isPassword = false,
    this.icon,
    this.controller, // Aquí agregamos el controlador
    this.validator,
  }); // Lo hacemos opcional

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Usamos el controlador aquí
      obscureText: isPassword,
      validator: validator, // Aplicamos el validador si está presente
      decoration: InputDecoration(
        labelText: tittle,
        //prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade200, // Fondo gris
        prefixIcon: icon != null
            ? Icon(icon)
            : null, // Muestra el ícono si se proporciona
        border: const OutlineInputBorder(),
      ),
    );
  }
}
