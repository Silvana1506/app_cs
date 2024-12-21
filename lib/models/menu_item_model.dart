import 'package:flutter/material.dart';

class MenuItemModel {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  MenuItemModel({
    required this.icon,
    required this.title,
    required this.onPressed,
  });
}
