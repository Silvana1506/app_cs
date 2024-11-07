import 'package:flutter/material.dart';

class Myfieldform extends StatelessWidget {
  final String tittle;
  final bool isPassword;

  const Myfieldform({required this.tittle, this.isPassword = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tittle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                  obscureText: isPassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xffa9a9a9),
                      filled: true))),
        ],
      ),
    );
  }
}
