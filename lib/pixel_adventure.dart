import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player_data/player_data.dart';
import 'package:pixel_adventure/components/hud/jump_button_component.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/main_menu_background/main_menu_background.dart';

//Этот класс описывает окно игры и инициализирует данные
class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  //Настройки разработчика (DEBUG)

  @override
  Color backgroundColor() => Color.fromARGB(255, 41, 41, 41);
  bool playSounds = true;

  Component? mainMenuBackground;

  double soundVolume = 1.0;

  bool isDebugModeOn =
      false; //Устанавливаем дебаг, который будет показывать коллизию объектов,
  // но если true то при сборке на виртуальном андроиде с производительностью всё очень плохо.

  bool showControls = Platform.isAndroid ||
      Platform
          .isIOS; //включить или выключить джойстик в зависимости от платформы

  //Создание данных об игроке, чтобы к ним можно было обращаться в любом месте программы (ValueNotifiers)
  PlayerData playerData = PlayerData();

  // Список всех возможных скинов персонажа и номер текущего скина
  List<String> skins = ["Mask Dude", "Ninja Frog", "Pink Man", "Virtual Guy"];
  int currentSkinNum = 0;

  // Список всех уровней и номер текущего уровня
  List<String> levels = [
    "Level-01",
    "Level-02",
    "Level-03",
    "Level-04",
    "Level-05",
    "Level-06",
    "Level-07",
    "Level-08",
  ];
  int currentLevelNum = 0;

  //Фиксированный размер игры
  final fixedGameResolution = Vector2(15000, 15000);
  //Фиксированный размер камеры
  final fixedCamResolution = Vector2(640, 368);

  @override
  Future<void> onLoad() async {
    // Сетап для игры
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    //Загрузить все изображения и звуки в кэш - даёт белый экран!!!
    await images.loadAllImages();
    await AudioManager.init();
  }

  void showMainMenuBackground() {
    if (mainMenuBackground != null) {
      mainMenuBackground!.removeFromParent(); // Убираем старый, если есть
    }
    final bg = MainMenuBackground(this);
    mainMenuBackground = bg;
    add(bg);
  }

  void hideMainMenuBackground() {
    mainMenuBackground?.removeFromParent();
    mainMenuBackground = null;
  }
}
