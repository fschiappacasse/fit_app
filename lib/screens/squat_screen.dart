import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:fl_chart/fl_chart.dart';
import '../storage/settings.dart';

void vibracion() {
  Vibration.hasVibrator().then((hasVibrator) {
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 100);
    }
  });
}

class SquatScreen extends StatefulWidget {
  const SquatScreen({super.key});

  @override
  State<SquatScreen> createState() => _SquatScreenState();
}

class _SquatScreenState extends State<SquatScreen> {
  double x = 0, y = 0, z = 0;
  int reps = 0;
  bool cooldown = false;
  double sensitivity = 0;
  double cooldown_ms = 0;
  DateTime lastRepTime =
      DateTime.now().subtract(const Duration(seconds: 1));

  late StreamSubscription<UserAccelerometerEvent> _subscription;

  @override
  void initState() {
    super.initState();

      Settings.getSensitivity('squat').then((v) { // sensitivity y cooldown_ms de storage
        setState(() => sensitivity = v);
      });

      Settings.getCooldown('squat').then((v) {
        setState(() => cooldown_ms = v);
      });

    _subscription = userAccelerometerEvents.listen((event) {
      if (!mounted) return;

      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        final now = DateTime.now();

        // cooldown de 1 segundo
        if (now.difference(lastRepTime).inMilliseconds >= cooldown_ms) { //const cooldown
          cooldown = false;
        }

        // LÓGICA DE SENTADILLA
        if (!cooldown && (y > sensitivity || z > sensitivity)) { //const aceleración mínima
          reps++;
          cooldown = true;
          lastRepTime = now;
          vibracion();
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'X: ${x.toStringAsFixed(2)}\n'
              'Y: ${y.toStringAsFixed(2)}\n'
              'Z: ${z.toStringAsFixed(2)}\n'
              'Reps: $reps',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ]
        ),
      ),
    );
  }

  LineChartBarData _line(List<double> data, Color color) {
    return LineChartBarData(
      spots: List.generate(
        data.length,
        (i) => FlSpot(i.toDouble(), data[i]),
      ),
      isCurved: true,
      color: color,
      barWidth: 2,
    );
  }
}
