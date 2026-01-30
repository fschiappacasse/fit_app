import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'exercise.dart';
import 'package:vibration/vibration.dart';
import 'package:fl_chart/fl_chart.dart';


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
  double x = 0, y = 0, z = 0;
  int reps = 0;
  bool cooldown = false;
  late StreamSubscription<UserAccelerometerEvent> _subscription;
  DateTime lastRepTime = DateTime.now().subtract(Duration(seconds: 1));
  List<double> xData = [];
  List<double> yData = [];
  List<double> zData = [];


  @override
  void initState() { // se llama una vez al inicio
    super.initState();

    _subscription = userAccelerometerEvents.listen((event) {
      if (!mounted) return;

      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        xData.add(event.x);
        yData.add(event.y);
        zData.add(event.z);

        // Limitar la longitud de la lista para no crecer infinito
        if (xData.length > 500) {
          xData.removeAt(0);
          yData.removeAt(0);
          zData.removeAt(0);
        }


        

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Texto de valores
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

            // Gráfico con altura limitada
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 300, // Ajusta la altura como quieras
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
                      bottomTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                            xData.length, (i) => FlSpot(i.toDouble(), xData[i])),
                        isCurved: true,
                        color: Colors.red,
                      ),
                      LineChartBarData(
                        spots: List.generate(
                            yData.length, (i) => FlSpot(i.toDouble(), yData[i])),
                        isCurved: true,
                        color: Colors.green,
                      ),
                      LineChartBarData(
                        spots: List.generate(
                            zData.length, (i) => FlSpot(i.toDouble(), zData[i])),
                        isCurved: true,
                        color: Colors.blue,
                      ),
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
}