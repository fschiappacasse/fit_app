import 'package:vibration/vibration.dart';

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
