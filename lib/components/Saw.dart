import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  final bool isVertical;
  final double minPosOffset;
  final double maxPosOffset;

  Saw({
    this.isVertical = false,
    this.minPosOffset = 0,
    this.maxPosOffset = 0,
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  static const double stepTime = 0.03; //скорость вращения пилы
  static const moveSpeed = 50; //скорость перемещения пилы
  static const tileSize = 16; // размер пилы
  double moveDirection = 1; // направление движения
  Vector2 range = Vector2.zero(); //

  //для обновления частоты кадров
  double accumulatedTime = 0;
  final double fixedUpdateTime = 1 / 100;

  @override
  FutureOr<void> onLoad() {
    add(CircleHitbox()); //хитбокс пилы, можно кастомизировать
    //DEBUG
    debugMode = gameRef.isDebugModeOn;

    priority = -1;

    if (isVertical) {
      range.x = position.y + minPosOffset * tileSize;
      range.y = position.y - maxPosOffset * tileSize;
    } else {
      range.x = position.x - minPosOffset * tileSize;
      range.y = position.x + maxPosOffset * tileSize;
    }

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Saw/On (38x38).png'),
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: stepTime,
          textureSize: Vector2.all(38),
        ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Accumulate dt
    accumulatedTime += dt;
    // Run multiple fixed updates if necessary (important for low FPS)
    while (accumulatedTime >= fixedUpdateTime) {
      if (isVertical) {
        _moveVertically(fixedUpdateTime);
      } else {
        _moveHorizontally(fixedUpdateTime);
      }

      accumulatedTime -= fixedUpdateTime; // Reduce accumulated time
    }

    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= range.x) {
      moveDirection = -1;
    } else if (position.y <= range.y) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x <= range.x) {
      moveDirection = 1;
    } else if (position.x >= range.y) {
      moveDirection = -1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
