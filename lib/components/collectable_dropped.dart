import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

import 'utils.dart';

class DroppedCollectable extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final String collectable;

  bool _collected = false;
  bool canBeCollected = false;

  final Player player;

  //для падения предмета
  final double _gravity = 9.8;
  final double _terminalVelocity = 200;

  double horizontalMovement = 0;
  double moveSpeed = 400;
  final double _maxJumpSpeed = 400;
  Vector2 velocity = Vector2.zero(); //скорость объекта по x и y
  double friction = 0.01; //трение по горизонтали
  double energyLoseY = 0.98;
  double energLoseX = 0.98;

  //для обновления частоты кадров
  double accumulatedTime = 0;
  final double fixedUpdateTime = 1 / 100;

  List<CollisionBlock> collisionBlocks = [];

  DroppedCollectable({
    required this.player,
    this.collectable = 'Nut',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final hitbox = CustomHitbox(offsetX: 5, offsetY: 5, width: 14, height: 20);

  final double stepTime = 0.05;

  //Функция, выполняемая при запуске (загрузке элемента класса)
  @override
  FutureOr<void> onLoad() {
    //DEBUG
    debugMode = gameRef.isDebugModeOn;
    priority = -1; //поместить collectable за персонажем

    //здесь первое - это генерация случаного направления [-1; 1], в котором будет двигаться предмет,
    //и это число умножаем на начальную скорость его перемещения
    velocity.x = ((Random().nextDouble() * 2) - 1) * moveSpeed;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$collectable.png'),
      SpriteAnimationData.sequenced(
        amount: 15,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    Future.delayed(Duration(milliseconds: 1500), () {
      canBeCollected = true;
    });

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Accumulate dt
    accumulatedTime += dt;
    // Run multiple fixed updates if necessary (important for low FPS)
    if (accumulatedTime >= fixedUpdateTime && velocity.length > 10.0) {
      _updateDropCollectableMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt);
      _checkVerticalCollisions();

      accumulatedTime -= fixedUpdateTime; // Reduce accumulated time
    }

    super.update(dt);
  }

  void collidedWithPlayer() {
    if (!_collected && canBeCollected) {
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
      gameRef.playerData.addItem(collectable);
      Future.delayed(
          const Duration(milliseconds: 500), () => removeFromParent());
    }
  }

  //Функция, перемещающая предмет в нужном направлении.
  void _updateDropCollectableMovement(double dt) {
    //velocity.x = horizontalMovement * moveSpeed;
    velocity.x = velocity.x * (1 - friction);
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            position.x = block.x - hitbox.offsetX - hitbox.width;
          } else if (velocity.x < 0) {
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
          }

          velocity.x = -velocity.x * energLoseX;
          break;
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_maxJumpSpeed, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          //звук

          velocity.y = -velocity.y * energLoseX;
          position.y = block.y - hitbox.height - hitbox.offsetY;
          break;
        }
      } else {
        if (checkCollision(this, block)) {
          velocity.y = -velocity.y * energLoseX;
          position.y = block.y - hitbox.height - hitbox.offsetY;
          break;
        }
      }
    }
  }
}
