import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/ui/jump_button_component.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

//Экраны меню
enum MenuScreen {
  main,
  characterSelect,
  exit,
}

//Возможные персонажи
List<String> characters = [
  "Virtual Guy",
  "Mask Dude",
  "Ninja Frog",
  "Pink Man"
];

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F35);

  MenuScreen currentMenuScreen = MenuScreen.main;

  double camWidth = 640;
  double camHeight = 368;
  late final CameraComponent cam;

  bool playSounds = true;
  double soundVolume = 1.0;

  //Выбранный персонаж
  int selectedCharacterIndex = 0;
  late Player player =
      Player(character: characters[selectedCharacterIndex]); //late??

  //Устанавливаем дебаг, который будет показывать коллизию объектов,
  //но если true то при сборке на виртуальном андроиде с производительностью всё очень плохо.
  bool isDebugModeOn = false;

  late JoystickComponent joystick;
  bool showControls =
      Platform.isAndroid || Platform.isIOS; //включить или выключить джойстик

  //функция, выполняемая при загрузке
  @override
  FutureOr<void> onLoad() async {
    //Загрузить все изображения и звуки в кэш
    await images.loadAllImages();

    //мир (уровень)
    final world = Level(levelName: 'Level-02', player: player);

    //камера
    cam = CameraComponent.withFixedResolution(
        world: world, width: camWidth, height: camHeight);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]); //добавить камеру и уровень

    overlays.add('MainMenu');

    if (showControls) {
      addJoystick();
    }
    return super.onLoad();
  }

  //функция, вызываемая каждый тик
  @override
  void update(double dt) {
    if (showControls) updateJoystick();
    super.update(dt);
  }

  //Функция добавления Джойстика для Android/IOS
  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    joystick.priority = 10;

    cam.viewport.add(joystick);
    cam.viewport.add(JumpButton());
  }

  //обновляем джойстик, и перемещаем персонажа
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
