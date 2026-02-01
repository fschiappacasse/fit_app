import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import '../storage/settings.dart';
import '../audio/sounds.dart';
import '../audio/vibration.dart';










class PlankScreen extends StatefulWidget {
  const PlankScreen({super.key});

  @override
  State<PlankScreen> createState() => _PlankScreenState();
}

class _PlankScreenState extends State<PlankScreen> {
  //final AudioPlayer _player = AudioPlayer();
  double x = 0, y = 0, z = 0;
  int time = 0;
  DateTime initialTime = DateTime.now();  
  bool coundown1 = true; // 5 segundos empieza la advertencia
  int timeS = 0;
  bool failed = false; // si failed == true el jugador perdió el equilibrio
  double sensitivity = 0;


  //bool coundown2 = true // x segundos el primer fallo

  late StreamSubscription<UserAccelerometerEvent> _subscription;

  @override
  void initState() {
    super.initState();
    AppSounds.sonido_countdown();

    _subscription = userAccelerometerEvents.listen((event) {
      if (!mounted) return;

    Settings.getSensitivity('squat').then((v) { // sensitivity y cooldown_ms de storage
        setState(() => sensitivity = v);
      });

      final now = DateTime.now();

       if (coundown1){
            // cooldown de 5 segundos
            if (now.difference(initialTime).inMilliseconds >= 4000) { //const  futuro??
                coundown1 = false;
                //vibracion_fuerte();
                initialTime = DateTime.now(); //redefinimos para no contar los primeros 5 segundos 
            }
        return;
       }


      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;



        if( !failed){
            timeS = now.difference(initialTime!).inSeconds;
        }

        // LOGICA FALLA PLANK
        if (!failed && (x + y + z > sensitivity  )) { //const aceleración mínima
            failed = true;
            AppSounds.fail();
            //vibracion_fuerte();
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
              'timeS: $timeS',
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
