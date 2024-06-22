import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const CustomFlatButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.transparent,
    this.textColor = Colors.black, required ListTile child, required Color splashColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.black),
        ),
      ),
      child: Text(text),
    );
  }
}
