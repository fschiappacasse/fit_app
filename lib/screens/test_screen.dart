import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:fl_chart/fl_chart.dart';

void vibracion() {
  Vibration.hasVibrator().then((hasVibrator) {
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 100);
    }
  });
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double x = 0, y = 0, z = 0;
  int reps = 0;

  bool cooldown = false;
  DateTime lastRepTime =
      DateTime.now().subtract(const Duration(seconds: 1));

  late StreamSubscription<UserAccelerometerEvent> _subscription;

  final List<double> xData = [];
  final List<double> yData = [];
  final List<double> zData = [];

  @override
  void initState() {
    super.initState();

    _subscription = userAccelerometerEvents.listen((event) {
      if (!mounted) return;

      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        xData.add(x);
        yData.add(y);
        zData.add(z);

        if (xData.length > 500) {
          xData.removeAt(0);
          yData.removeAt(0);
          zData.removeAt(0);
        }

        final now = DateTime.now();

        // cooldown de 1 segundo
        if (now.difference(lastRepTime).inMilliseconds >= 1000) {
          cooldown = false;
        }

        // LÓGICA DE SENTADILLA
        if (!cooldown && (y > 2 || z > 2)) {
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

            const SizedBox(height: 20),

            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    minY: -10,
                    maxY: 10,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false)),
                      topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    lineBarsData: [
                      _line(xData, Colors.red),
                      _line(yData, Colors.green),
                      _line(zData, Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
