import 'package:cronosalud/Utils/textapp.dart';
import 'package:flutter/material.dart';

//boton volver
class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ),
              Text(TextApp.back,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black))
            ],
          ),
        ));
  }
}
