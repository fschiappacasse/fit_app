import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart'; // ACELERÓMETRO
import "menu.dart";

enum Exercise {
  squat,
  jump,
  balance,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //app base
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
