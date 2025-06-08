import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/Saw.dart';
import 'package:pixel_adventure/components/collectable.dart';
import 'package:pixel_adventure/components/collectable_dropped.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/door.dart';
import 'package:pixel_adventure/components/inventory.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/pixel_adventure_gameplay.dart';

//enum с состояниями персонажа (стоит, бежит, прыгает, падает)
enum PlayerState { idle, running, jumping, falling, hit }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  Player(
      {position,
      this.character =
          'Ninja Frog'}) //конструктор персонажа (нужна string character - название персонажа из assets/images/Main Characters)
      : super(
            position:
                position); //применение position к position SpriteAnimationGroupComponent

  //для обновления частоты кадров
  double accumulatedTime = 0;
  final double fixedUpdateTime = 1 / 100;

  //передвижение, хитбокс
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  final double stepTime = 0.05;

  final double _gravity = 9.8;
  final double _jumpForce = 300;
  final double _terminalVelocity = 10;
  final double moveSpeedRegular = 100;
  final double moveSpeedSprint = 150;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];
  bool isOnGround = false;
  bool hasJumped = false;
  int jumpCounter = 2;

  CustomHitbox hitbox =
      CustomHitbox(offsetX: 10, offsetY: 4, width: 14, height: 28);

  //здоровье и стамина
  bool canBeHit = true;
  bool gotHit = false;

  bool canSprint = true;
  bool isSprinting = false;

  //функция, вызывается один раз при загрузке персонажа
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    //DEBUG
    debugMode = gameRef.isDebugModeOn;

    //Добавляем хитбокс, но не используем его, это просто визуальный индикатор для Debug
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));

    return super.onLoad();
  }

  //функция, вызываемая каждый кадр
  @override
  void update(double dt) {
    // Accumulate dt
    accumulatedTime += dt;
    // Run multiple fixed updates if necessary (important for low FPS)
    while (accumulatedTime >= fixedUpdateTime) {
      _updatePlayerState();
      _updatePlayerMovement(fixedUpdateTime);
      _checkHorizontalCollisions();
      _applyGravity(fixedUpdateTime);
      _checkVerticalCollisions();

      accumulatedTime -= fixedUpdateTime; // Reduce accumulated time
    }

    super.update(dt);
  }

  //Функция, вызываемая по нажатию кнопки, в ней мы проверяем нажатую кнопку и задаём направление движения персонажа (horizontalMovement)
  //(ф-ия возвращает нажатую кнопку)
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    if (event is KeyUpEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      isSprinting = false;
    }
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.shiftLeft) {
      isSprinting = true;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GameCollectable) {
      other.collidedWithPlayer();
    }
    if (other is DroppedCollectable) {
      other.collidedWithPlayer();
    }
    if (other is Door) {
      other.collidedWithPlayer();
    }
    if (other is Saw && canBeHit) {
      _playerHit();
    }
    super.onCollision(intersectionPoints, other);
  }

  //Приватная функция для прогрузки всех анимаций персонажа из .png изображения с индивидуальными кадрами анимации
  void _loadAllAnimations() {
    // используем функцию _spriteAnimation, чтобы сохранить анимации
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7);

    //Сохраняем анимации в состояния персонажа
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
    };

    //Устанавливаем текущее состояние персонажа (анимацию)
    current = PlayerState.idle;
  }

  //Приватная функция, принимает название анимации персонажа и количество кадров в анимации, возвращает анимацию SpriteAnimation
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2(32, 32)));
  }

  //Функция обновления состояния персонажа, которая меняет анимацию и переворачивает персонажа при разных значениях velocity.
  void _updatePlayerState() {
    //Если персонаж идёт влево и в начале движения был повернут вправо, то перевернуть персонажа.
    //Если персонаж идёт вправо и в начале движения был повернут влево, то перевернуть персонажа.
    if ((velocity.x < 0 && scale.x > 0) || (velocity.x > 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }

    if (!gotHit) {
      PlayerState playerState = PlayerState.idle;

      if (velocity.x != 0) playerState = PlayerState.running;

      if (velocity.y > _gravity * fixedUpdateTime) {
        playerState = PlayerState.falling;
      }

      if (velocity.y < 0) playerState = PlayerState.jumping;

      current = playerState;
    }
  }

  //Приватная функция, перемещающая персонажа в нужном направлении.
  void _updatePlayerMovement(double dt) {
    //Благодаря этому  игрок не может прыгать в воздухе два раза, если он падает и использует прыжки
    //(минус 3) - нужно чтобы у игрока была небольшая фора  и при падении с платформы он ещё мог какое-то время
    //использовать двойной прыжок,  поскольку проверка считает, что он всё ещё на земле  (isOnGround будет = true);
    //Если - 3 убрать то этого эффекта не будет
    if (velocity.y - 3 > _gravity * fixedUpdateTime) {
      isOnGround = false;
      if (jumpCounter == 2) jumpCounter = 1;
    }
    if (hasJumped && jumpCounter != 0) _playerJump(dt);

    if (isSprinting && canSprint && velocity != Vector2.zero()) {
      _playerSprint(dt);
    }
    if (!isSprinting) {
      _playerUpdateSprintBar(dt);
      // Future.delayed(
      //   Duration(milliseconds: 1000),
      //   () => _playerUpdateSprintBar(dt),
      // );
    }

    velocity.x = horizontalMovement * moveSpeed * dt;
    position.x += velocity.x;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity * dt;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y;
  }

  void _playerJump(double dt) {
    //звук
    if (game.playSounds) {
      //FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);
    }
    velocity.y = -_jumpForce * dt;
    position.y += velocity.y;

    hasJumped = false;
    isOnGround = false;

    if (jumpCounter != 0) jumpCounter -= 1;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            jumpCounter = 2;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            jumpCounter = 2;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _playerHit() async {
    //анимация
    const hitDuration = Duration(
        milliseconds:
            350); //считаем, сколько длится анимация нанесения урона по игроку (50*7)
    gotHit = true;
    canBeHit = false;
    current = PlayerState.hit;

    Future.delayed(hitDuration, () {
      gotHit = false;
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      canBeHit = true;
    });

    //уменьшение здоровья
    if (game.playerData.health.value > 0) {
      game.playerData.health.value -= 1;
    }

    //удаление предметов из инвентаря и возврат списка удалённых предметов
    List<String>? dropItemsList = game.playerData.deleteRandomItems();

    //сброс предметов из инвентаря
    if (dropItemsList != null) {
      //убираем несколько предметов (3)
      for (int i = 0; i < dropItemsList.length; i++) {
        final collectableDropped = DroppedCollectable(
            player: this,
            collectable: dropItemsList[i],
            position: isFlippedHorizontally
                ? Vector2(
                    position.x -
                        hitbox.offsetX -
                        (hitbox.width / 2) -
                        11, // 11 - это доп оффсет полученный опытным путём
                    position.y + (hitbox.offsetY / 2))
                : Vector2(
                    position.x +
                        hitbox.offsetX +
                        (hitbox.width / 2) -
                        11, // 11 - это доп оффсет полученный опытным путём
                    position.y + (hitbox.offsetY / 2)),
            size: Vector2(24, 24));

        collectableDropped.collisionBlocks = collisionBlocks;
        final level = gameRef.children.whereType<GamePlay>().first.currentLevel;
        level!.spawnDropCollectableObject(collectableDropped);
      }
    }
  }

  void _playerSprint(double dt) {
    //уменьшение стамины
    if (game.playerData.stamina.value > 0.02) {
      moveSpeed = moveSpeedSprint;
      canSprint = true;
      game.playerData.stamina.value = game.playerData.stamina.value -
          ((game.playerData.stamina.value - 0.01) * dt).clamp(0.0, 1.0);
    } else {
      moveSpeed = moveSpeedRegular;
      canSprint = false;
    }
  }

  void _playerUpdateSprintBar(double dt) {
    if (game.playerData.stamina.value < 1.0) {
      moveSpeed = moveSpeedRegular;
      game.playerData.stamina.value = game.playerData.stamina.value +
          ((game.playerData.stamina.value + 0.01) * dt).clamp(0.0, 1.0);
    }
    if (game.playerData.stamina.value > 0.1 && canSprint == false) {
      canSprint = true;
    }
  }
}
