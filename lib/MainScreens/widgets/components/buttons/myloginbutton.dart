import 'package:flutter/material.dart';

class MyLoginButton extends StatelessWidget {
  final String text;
  final Color colortext;
  final Color colorbuttonbackground;
  final Widget widgetToNavigate;

  const MyLoginButton(
      {super.key,
      required this.text,
      required this.colortext,
      required this.colorbuttonbackground,
      required this.widgetToNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25.0, bottom: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => widgetToNavigate)),
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: colorbuttonbackground,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ), // Color de fondo
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
      ),
    );
  }
}
