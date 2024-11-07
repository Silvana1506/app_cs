import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:cupertino_icons/cupertino_icons.dart';
//TITULOS
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

//titulo pantalla ingresa a tu perfil
  static RichText titleCustom() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Ingresa a tu Perfil !',
        style: GoogleFonts.portLligatSans(
            fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

  //titulo pagina bienvenida
  static RichText titleCustomDark() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Bienvenido !',
        style: GoogleFonts.portLligatSans(
            fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

  //titulo pagina bienvenida
  static RichText titleCustomCrear() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Crear Cuenta',
        style: GoogleFonts.portLligatSans(
            fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

  static RichText titleCustomCrear2() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '¡Listo! Cuenta Creada',
        style: GoogleFonts.portLligatSans(
            fontSize: 48, fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }
}
