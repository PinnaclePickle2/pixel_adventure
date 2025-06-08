import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class GameCollectable extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks, ChangeNotifier {
  final String collectable;

  bool _collected = false;

  final Player player;

  List<CollisionBlock> collisionBlocks = [];

  GameCollectable({
    required this.player,
    this.collectable = 'Nut',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final hitbox = CustomHitbox(offsetX: 5, offsetY: 5, width: 14, height: 14);

  final double stepTime = 0.05;

  //Функция, выполняемая при запуске (загрузке элемента класса)
  @override
  FutureOr<void> onLoad() {
    //DEBUG
    debugMode = gameRef.isDebugModeOn;
    priority = -1; //поместить collectable за персонажем

    //создание анимации для подбираемого объекта
    //_spriteAnimation(collectable);

    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$collectable.png'),
      SpriteAnimationData.sequenced(
        amount: 15,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    return super.onLoad();
  }

  void collidedWithPlayer() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      _collected = true;
      //player.nutsCollectedAmount += 1;
      game.playerData.addItem(collectable);
      Future.delayed(
          const Duration(milliseconds: 500), () => removeFromParent());
    }
  }
}
