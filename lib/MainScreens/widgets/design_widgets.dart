import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:cupertino_icons/cupertino_icons.dart';

class Designwidgets {
  static LinearGradient linearGradientMain(BuildContext context) {
    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).primaryColorLight,
          Theme.of(context).primaryColor
        ]);
  }

  static RichText titleCustom() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Ingresa a tu Perfil',
          style: GoogleFonts.portLligatSans(
              fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
          children: [
            TextSpan(
                text: "!", style: TextStyle(color: Colors.black, fontSize: 48))
          ]),
    );
  }
}
