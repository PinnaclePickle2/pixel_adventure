import 'dart:math';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class MainMenuBackground extends PositionComponent
    with HasGameRef<PixelAdventure> {
  MainMenuBackground(this.game)
      : super(key: ComponentKey.named('main_menu_background'));

  final PixelAdventure game;
  double angle = 0;

  late final SpriteAnimationComponent character;
  late final SpriteAnimationComponent saw;

  @override
  Future<void> onLoad() async {
    // Загружаем персонажа
    character = SpriteAnimationComponent(
      animation: await loadCharacterAnimation(game.currentSkinNum),
      size: Vector2.all(64),
      anchor: Anchor.center,
    );
    add(character);

    // Загружаем пилу
    saw = SpriteAnimationComponent(
      animation: await loadSawAnimation(),
      size: Vector2.all(64),
      anchor: Anchor.center,
    );
    add(saw);
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += dt;

    final center = game.size / 2;
    final radius = 180.0;

    final characterAngle = angle;
    character.position =
        center + Vector2(cos(characterAngle), sin(characterAngle)) * radius;

    // Поворот персонажа влево/вправо
    character.scale.x = sin(characterAngle) >= 0 ? -1 : 1;

    // Пила преследует персонажа (на -pi/6 сзади)
    final sawAngle = angle - pi / 6;
    saw.position = center + Vector2(cos(sawAngle), sin(sawAngle)) * radius;
  }

  Future<SpriteAnimation> loadCharacterAnimation(int index) async {
    final image = await game.images
        .load('Main Characters/${game.skins[index]}/Run (32x32).png');
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
      ),
    );
  }

  Future<SpriteAnimation> loadSawAnimation() async {
    final image = await game.images.load('Traps/Saw/On (38x38).png');
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.05,
        textureSize: Vector2(38, 38),
      ),
    );
  }
}
