import 'package:audioplayers/audioplayers.dart';

class Sound {
  static void playSound(int option) async {
    //AudioCache player = AudioCache(prefix: 'lib/assets/audio/');
    //await player.play('note' + option.toString() + '.wav');
    AudioPlayer player = AudioPlayer();
    player.audioCache.prefix = 'lib/assets/audio/';
    player.setPlayerMode(PlayerMode.mediaPlayer);
    await player.play(AssetSource('note$option.wav'));
  }
}
