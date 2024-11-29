import 'package:flutter/material.dart';

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
}
