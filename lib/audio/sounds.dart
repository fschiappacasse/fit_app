// lib/audio/sounds.dart
import 'package:audioplayers/audioplayers.dart';

class AppSounds {
  // Un solo player reutilizable
  static final AudioPlayer _player = AudioPlayer();


  static Future<void> bip() async {
    await _player.play(
      AssetSource('sounds/bip.mp3'),
      volume: 1,
    );
  }

  static Future<void> bipAgudo() async {
    await _player.play(
      AssetSource('sounds/bip_agudo.mp3'),
      volume: 1,
    );
  }

    static Future<void> fail() async {
    await _player.play(
      AssetSource('sounds/fail.mp3'),
      volume: 1,
    );
  }

  static Future<void> sonido_countdown() async {
    for (int i = 0; i < 3; i++) {
      await bip();
      await Future.delayed(const Duration(seconds: 1));
    }

    bipAgudo();
  }

  

  static void dispose() {
    _player.dispose();
  }
}
