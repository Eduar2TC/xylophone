import 'package:audioplayers/audioplayers.dart';

class Sound {
  static void playSound(int option) {
    AudioCache player = AudioCache(prefix: 'lib/assets/audio/');
    player.play('note' + option.toString() + '.wav');
  }
}
