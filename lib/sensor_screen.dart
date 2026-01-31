import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'exercise.dart';
import 'package:vibration/vibration.dart';
import 'package:fl_chart/fl_chart.dart';

import 'screens/squat_screen.dart';
import 'screens/test_screen.dart';
import 'screens/plank_screen.dart';

class SensorScreen extends StatelessWidget {
  final Exercise exercise;

  const SensorScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    switch (exercise.name) {
      case 'test':
        return TestScreen();
      case 'squat':
        return SquatScreen();
      case 'plank':
        return PlankScreen();
      case 'jump':
        //return JumpScreen();
      case 'balance':
        //return BalanceScreen();
      default:
        return const Scaffold(
          body: Center(child: Text('Ejercicio no soportado')),
        );
    }
  }
}
