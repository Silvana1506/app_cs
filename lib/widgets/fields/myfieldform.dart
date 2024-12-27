import 'package:flutter/material.dart';

class Myfieldform extends StatelessWidget {
  final String tittle;
  final bool isPassword;
  final IconData? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // Tipo de teclado
  final String? errorText; // Agregamos el nuevo parámetro

  const Myfieldform({
    super.key,
    required this.tittle,
    this.isPassword = false,
    this.icon,
    this.controller, // Aquí agregamos el controlador
    this.validator,
    this.keyboardType = TextInputType.text,
    this.errorText, // Se recibe el error text
  }); // Lo hacemos opcional

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Usamos el controlador aquí
      obscureText: isPassword,
      validator: validator, // Aplicamos el validador si está presente
      decoration: InputDecoration(
        labelText: tittle,
        errorText: errorText,
        filled: true,
        fillColor: Colors.grey.shade200, // Fondo gris
        prefixIcon: icon != null
            ? Icon(icon)
            : null, // Muestra el ícono si se proporciona
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      ),
      keyboardType: keyboardType,
    );
  }
}
