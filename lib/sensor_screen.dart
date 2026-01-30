import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'exercise.dart';
import 'package:vibration/vibration.dart';


void vibracion() {
  print('¡Hola!');
  // Vibrar el teléfono
  Vibration.hasVibrator().then((hasVibrator) {
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 100); // vibra 100 ms
    }
  });
}


class SensorScreen extends StatefulWidget {
  final Exercise exercise;
  SensorScreen({super.key, required this.exercise});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  double x = 0, y = 0, z = 0, reps = 0;
  bool cooldown = false;
  late StreamSubscription<UserAccelerometerEvent> _subscription;
  DateTime lastRepTime = DateTime.now().subtract(Duration(seconds: 1));


  @override
  void initState() { // se llama una vez al inicio
    super.initState();

    _subscription = userAccelerometerEvents.listen((event) {
      if (!mounted) return;

      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        

        DateTime now = DateTime.now();
        // Solo contar si ha pasado 1 segundo desde la última repetición
        if (now.difference(lastRepTime).inMilliseconds >= 1000) {
          lastRepTime = now;
          cooldown = false;
        }

        switch (widget.exercise.name) {
          case 'squat':
            if (!cooldown && (y > 2 || z > 2)){
              reps += 1;
              cooldown = true;
              vibracion();
            }
            break;
          case 'jump':
            // Lógica para flexiones
            break;
          case 'balance':
            // Lógica para sentadillas
            break;
          default:
            // Lógica por defecto
            break;
        }
      });
    });
  }

  @override // cuando se elimina el widget
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) { // dibuja la interfaz del widget
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'X: ${x.toStringAsFixed(2)}\n'
          'Y: ${y.toStringAsFixed(2)}\n'
          'Z: ${z.toStringAsFixed(2)}\n'
          'reps: ${reps.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}


