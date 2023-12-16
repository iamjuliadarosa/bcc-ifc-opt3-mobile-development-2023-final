import 'package:flutter/material.dart';

class TemperatureWidget extends StatelessWidget {
  String content;

  TemperatureWidget({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ));
  }
}
