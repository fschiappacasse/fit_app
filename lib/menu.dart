import 'package:flutter/material.dart';
import 'sensor_screen.dart';
import 'exercise.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _menuButton(context, 'Test', Exercise.test),
            _menuButton(context, 'Squat', Exercise.squat),
            _menuButton(context, 'Plank', Exercise.plank),
            _menuButton(context, 'Jump', Exercise.jump),
            _menuButton(context, 'Balance', Exercise.balance),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text, Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purpleAccent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SensorScreen(exercise: exercise),
            ),
          );
        },
        child: Text(text, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
