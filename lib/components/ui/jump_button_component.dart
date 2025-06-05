import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  JumpButton();

  final double margin = 32;
  final double buttonSize = 64;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Загружаем спрайт
    sprite = Sprite(
      gameRef.images.fromCache('HUD/JumpButton.png'),
    );

    position = Vector2(
      game.camWidth - margin - buttonSize,
      game.camHeight - margin - buttonSize,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    sprite = Sprite(gameRef.images.fromCache('HUD/Joystick.png'));
    super.onTapDown(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    sprite = Sprite(gameRef.images.fromCache('HUD/JumpButton.png'));
    game.player.hasJumped = false;
    super.onTapCancel(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    sprite = Sprite(gameRef.images.fromCache('HUD/JumpButton.png'));
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}




// class JumpButton extends PositionComponent with HasGameRef<PixelAdventure> {
//   JumpButton() : super(
//     position: Vector2(20, 20),
//     size: Vector2.all(50),
//   );

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();

//     // Загружаем спрайт
//     Sprite sprite = Sprite(
//       gameRef.images.fromCache('HUD/JumpButton.png'),
//     );

//     add(
//       SpriteComponent(
//         sprite: sprite,
//         size: Vector2.all(50),
//       ),
//     );
//   }

//   @override
//   bool onTapDown(TapDownInfo event) {
//     print('Jump!');
//     return true;
//   }
// }

