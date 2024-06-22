import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class CustomLoader extends StatelessWidget {
  final Key? key;

  const CustomLoader({this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlareActor(
        'assets/flareFiles/book_loader.flr', // Adjust this path as per your project structure
        alignment: Alignment.center,
        fit: BoxFit.contain, // Ensure the animation fits within the widget
        animation: 'opening_closing', // Specify the animation name
      ),
    );
  }
}
