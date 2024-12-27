import 'package:flutter/material.dart';

class MyLoginButton extends StatelessWidget {
  final String text;
  final Color colortext;
  final Color colorbuttonbackground;
  final Widget? widgetToNavigate;
  final VoidCallback? onPressed;

  const MyLoginButton({
    super.key,
    required this.text,
    required this.colortext,
    required this.colorbuttonbackground,
    this.widgetToNavigate,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      padding: EdgeInsets.only(top: 12.0, bottom: 12),
      // width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed ??
            () {
              if (widgetToNavigate != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widgetToNavigate!),
                );
              }
            },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: colorbuttonbackground,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ), // Color de fondo
        ),
        child: Text(
          text,
          style: TextStyle(
            color: colortext,
            letterSpacing: 1.5,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
