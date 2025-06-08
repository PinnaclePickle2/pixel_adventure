// This component is responsible for the whole game play.
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/hud/hud.dart';
//import 'package:pixel_adventure/components/player_data/player_data.dart';
//import 'package:pixel_adventure/components/ui/jump_button_component.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/hud/jump_button_component.dart';
import 'package:pixel_adventure/components/player_data/player_data.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

//Этот класс описывает игру в процессе геймплея, когда на экране нетт никаких меню (оверлеев main menu, pause menu, settings, game over)
class GamePlay extends World
    with HasGameReference<PixelAdventure>, DragCallbacks {
  // Активный сейчас уровень
  Level? currentLevel;

  final hud = Hud(priority: 1);

  late final CameraComponent cam;
  late final Player player;

  late JoystickComponent joystick;

  //функция, выполняемая при загрузке
  @override
  FutureOr<void> onLoad() async {
    //Персонаж
    String currentSkin = game.skins[game.currentSkinNum];
    player = Player(character: currentSkin);
    game.playerData = PlayerData();

    //Камера
    cam = CameraComponent.withFixedResolution(
      world: this,
      width: game.fixedCamResolution.x,
      height: game.fixedCamResolution.y,
      hudComponents: [hud],
    );
    cam.viewfinder.zoom = 1.4;
    await game.add(cam);

    //Добавить уровень
    loadLevel(game.levels[game.currentLevelNum]);

    if (game.showControls) {
      addJoystick();
    }

    game.playerData.stamina.value = 5;

    return super.onLoad();
  }

  //функция, вызываемая каждый тик
  @override
  void update(double dt) {
    if (game.showControls) updateJoystick();
    super.update(dt);
  }

  //Функция добавления Джойстика для Android/IOS
  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(game.images.fromCache('HUD/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(game.images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      knobRadius: 50.0,
    );
    joystick.priority = 10;

    cam.viewport.add(joystick);
    cam.viewport.add(JumpButton());
  }

  void updateJoystick() {
    final direction = joystick.direction;
    final deltaLength = joystick.relativeDelta.length;

    // Определим порог для спринта (например, от 0.85 до 1.0)
    if (deltaLength >= 0.85) {
      player.isSprinting = true;
    } else {
      player.isSprinting = false;
    }

    switch (direction) {
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

  // Swaps current level with given level
  void loadLevel(String levelName) {
    currentLevel?.removeFromParent();
    currentLevel = Level(levelName: levelName, player: player);
    add(currentLevel!);
  }

  @override
  void onRemove() {
    hud.removeFromParent();
    super.onRemove();
  }
}
