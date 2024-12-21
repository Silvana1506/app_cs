import 'package:cronosalud/models/menu_item_model.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemModel menuItem;

  const MenuItemWidget({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: menuItem.onPressed,
      child: Card(
        color: const Color.fromARGB(255, 175, 242, 245),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuItem.icon, size: 40, color: Colors.black),
            const SizedBox(height: 10),
            Text(
              menuItem.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
