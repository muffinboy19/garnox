import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPressed;
  final Color color;
  final bool isSelected;

  NavItem({
    required this.title,
    required this.iconData,
    required this.onPressed,
    this.color = Colors.white,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Color.fromRGBO(128, 128, 128, 0.25) : color,
      ),
      child: ListTile(
        title: Text(title),
        leading: Icon(iconData),
        onTap: onPressed,
      ),
    );
  }
}
