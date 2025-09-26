import 'package:audioplayers/audioplayers.dart';

class Sound {
  static final Map<int, List<AudioPlayer>> _playerPools = {};
  static const int playersPerNote = 4;

  // Crear el pool para una nota específica si no existe
  static Future<void> _createPoolIfNeeded(int note) async {
    if (_playerPools.containsKey(note)) return; // Ya existe

    _playerPools[note] = [];

    for (int i = 0; i < playersPerNote; i++) {
      final player = AudioPlayer();
      await player.setPlayerMode(PlayerMode.lowLatency);
      await player.setVolume(1.0);
      // Precarga el asset para este player
      await player.setSource(AssetSource('audio/note$note.wav'));
      _playerPools[note]!.add(player);
    }
  }

  static void playSound(int option) async {
    try {
      // Crear pool para esta nota si no existe
      await _createPoolIfNeeded(option);

      // Buscar un player que no esté reproduciendo
      for (var player in _playerPools[option]!) {
        if (player.state != PlayerState.playing) {
          await player.play(AssetSource('audio/note$option.wav'));
          return; // Encontramos uno disponible, terminamos aquí
        }
      }

      // Si llegamos aquí, todos están ocupados
      // Usar el primero y detenerlo
      final firstPlayer = _playerPools[option]!.first;
      await firstPlayer.stop();
      await firstPlayer.play(AssetSource('audio/note$option.wav'));
    } catch (e) {
      print('Error reproduciendo nota $option: $e');
    }
  }

  // Cambiar volumen de todos los players
  static void setVolume(double volume) {
    for (var players in _playerPools.values) {
      for (var player in players) {
        player.setVolume(volume);
      }
    }
  }

  // Detener todos los sonidos
  static void stopAll() {
    for (var players in _playerPools.values) {
      for (var player in players) {
        player.stop();
      }
    }
  }

  // Limpiar todo (opcional)
  static void dispose() {
    for (var players in _playerPools.values) {
      for (var player in players) {
        player.dispose();
      }
    }
    _playerPools.clear();
  }
}
