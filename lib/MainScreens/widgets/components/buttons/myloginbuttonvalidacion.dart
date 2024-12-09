import 'package:flutter/material.dart';

// boton de registrarse
class MyLoginButtonValidacion extends StatelessWidget {
  final String text;
  final Color colortext;
  final Color colorbuttonbackground;
  final VoidCallback onPressed; // Asegúrate de que este parámetro esté aquí

  const MyLoginButtonValidacion({
    super.key,
    required this.text,
    required this.colortext,
    required this.colorbuttonbackground,
    required this.onPressed, // Se añade el parámetro onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Se llama a la función onPressed aquí
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        backgroundColor: colorbuttonbackground,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colortext,
          letterSpacing: 1.5,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
