import 'package:audioplayers/audioplayers.dart';

class Sound {
  static final AudioPlayer player = AudioPlayer();
  static void playSound(int option) {
    AudioCache player = AudioCache(prefix: 'lib/assets/audio/');
    player.play('note$option.wav', mode: PlayerMode.LOW_LATENCY);
    player.clearAll();
  }
}
