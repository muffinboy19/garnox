import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class CustomLoader extends StatelessWidget {
  final Key? key;

  const CustomLoader({this.key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(), // Use the standard CircularProgressIndicator
    );
  }
}
