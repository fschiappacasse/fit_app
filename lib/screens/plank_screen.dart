import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:fl_chart/fl_chart.dart';
import '../storage/settings.dart';
import 'package:audioplayers/audioplayers.dart';



void vibracion() {
  Vibration.hasVibrator().then((hasVibrator) {
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 100);
    }
  });
}

void vibracion_fuerte() {
  Vibration.hasVibrator().then((hasVibrator) {
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 1000);
    }
  });
}

void vibracion_coundown_5() async {
  if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(
            pattern: [0, 200, 800, 200, 800, 200, 800, 200, 800, 200]
    );
  }
}


Future<void> sonido_countdown(AudioPlayer player) async {
  for (int i = 0; i < 3; i++) {
    await player.play(
      AssetSource('sounds/bip.mp3'),
      volume: 0.8,
    );
    await Future.delayed(const Duration(seconds: 1));
  }

  // bip final más fuerte
  await player.play(
    AssetSource('sounds/bip.mp3'),
    volume: 1.0,
  );
  await Future.delayed(const Duration(milliseconds: 200));
  await player.play(
    AssetSource('sounds/bip.mp3'),
    volume: 1.0,
  );
}




class PlankScreen extends StatefulWidget {
  const PlankScreen({super.key});

  @override
  State<PlankScreen> createState() => _PlankScreenState();
}

class _PlankScreenState extends State<PlankScreen> {
  final AudioPlayer _player = AudioPlayer();
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
    sonido_countdown(_player);

    _subscription = userAccelerometerEvents.listen((event) {
      if (!mounted) return;

    Settings.getSensitivity('squat').then((v) { // sensitivity y cooldown_ms de storage
        setState(() => sensitivity = v);
      });

      final now = DateTime.now();

       if (coundown1){
            // cooldown de 5 segundos
            if (now.difference(initialTime).inMilliseconds >= 5000) { //const  futuro??
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
            vibracion_fuerte();
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
