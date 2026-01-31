import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  // KEYS 
  static String _sensitivityKey(String exercise) =>
      'sensitivity_$exercise';

  static String _cooldownKey(String exercise) =>
      'cooldown_$exercise';

  //  DEFAULTS 
  static double defaultSensitivity(String exercise) {
    switch (exercise) {
      case 'squat':
        return 1.5;
      case 'jump':
        return 3.0;
      case 'balance':
        return 1.2;
      default:
        return 2.0;
    }
  }

  static double defaultCooldown(String exercise) {
    switch (exercise) {
      case 'squat':
        return 2000; 
      case 'jump':
        return 2000;
      case 'balance':
        return 2000;
      default:
        return 2000;
    }
  }

  // SENSITIVITY 
  static Future<void> setSensitivity(
      String exercise, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_sensitivityKey(exercise), value);
  }

  static Future<double> getSensitivity(String exercise) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_sensitivityKey(exercise))
        ?? defaultSensitivity(exercise);
  }

  //  COOLDOWN 
  static Future<void> setCooldown(
      String exercise, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_cooldownKey(exercise), value);
  }

  static Future<double> getCooldown(String exercise) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_cooldownKey(exercise))
        ?? defaultCooldown(exercise);
  }
}
