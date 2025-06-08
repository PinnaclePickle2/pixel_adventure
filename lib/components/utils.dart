import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

//Возвращает true, если персонаж пересекает объекты с коллизией.
//(если коллизия персонажа пересекается с коллизией уровня)
//Поиск DEBUG и debugMode = true; в файлах, чтобы увидеть коллизию рилтайм).
bool checkCollision(player, block) {
  final hitbox = player.hitbox;

  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeigth = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeigth &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}

// Этот класс отвечает за проигрывание всех звуков в игре
class AudioManager {
  static final sfx = ValueNotifier(true);
  static final bgm = ValueNotifier(true);

  static bool _isBgmPlaying = false;
  static String? _currentBgmFile;

  static Future<void> init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'Button_20.wav',
      'Button_21.wav',
      'Button_22.wav',
      'Button_23.wav',
      'Button_24.wav',
      'Button_25.wav',
      'bounce.wav',
      'collect_fruit.wav',
      'disappear.wav',
      'hit.wav',
      'jump.wav',
      'level.wav',
      'level_2.wav',
      'main_menu.wav',
      'Power Synth.wav',
    ]);
  }

  static Future<void> playBgm(String file) async {
    if (!bgm.value) return;

    final state = await FlameAudio.bgm.audioPlayer.state;

    final isSameFile = _currentBgmFile == file;
    final isAlreadyPlaying = state == PlayerState.playing;

    if (isSameFile && isAlreadyPlaying) {
      // не перезапускаем, если уже играет тот же трек
      return;
    }

    await FlameAudio.bgm.play(file);
    _currentBgmFile = file;
    _isBgmPlaying = true;
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
    _isBgmPlaying = false;
  }

  static void resumeBgm() {
    if (bgm.value) {
      FlameAudio.bgm.resume();
      _isBgmPlaying = true;
    }
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
    _currentBgmFile = null;
    _isBgmPlaying = false;
  }

  static bool isBgmPlaying() => _isBgmPlaying;
}
