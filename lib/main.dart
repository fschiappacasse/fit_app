import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart'; // ACELERÓMETRO

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //app base
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SensorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  double x = 0, y = 0, z = 0;
  int sensitivity_x = 1, sensitivity_y = 1, sensitivity_z = 1;

  @override
  void initState() {
    super.initState();
    userAccelerometerEvents.listen((event) { // ACELERÓMETRO  
      setState(() {
        x = event.x; // izquierda derecha
        y = event.y; // adelante atras
        z = event.z; // arriba abajo
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'X: ${x.toStringAsFixed(2)}\n'
          'Y: ${y.toStringAsFixed(2)}\n'
          'Z: ${z.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
