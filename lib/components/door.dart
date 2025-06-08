import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/pixel_adventure_gameplay.dart';

class Door extends SpriteComponent
    with CollisionCallbacks, HasGameRef<PixelAdventure> {
  Door({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  Future<void> onLoad() async {
    // Добавляем hitbox для коллизий
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    priority = -1;
    sprite = Sprite(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/Checkpoint(NoFlag).png'),
    );

    await super.onLoad();
  }

  void collidedWithPlayer() {
    game.currentLevelNum =
        game.currentLevelNum <= 6 ? game.currentLevelNum + 1 : 0;
    game.removeAll(game.children);
    game.add(GamePlay());
  }
}
