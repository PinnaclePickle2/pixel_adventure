import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<PixelAdventure> {
  final String color;
  BackgroundTile({this.color = 'Blue', position})
      : super(
            position:
                position); //super применяет position из констора в SpriteComponent

  final double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() {
    priority =
        -1; //указываем что background_tile будет на заднем фоне, за самой игрой
    size = Vector2.all(
        64.4); //64 - это хардкод размера текстуры в images/Background/

    sprite = Sprite(game.images.fromCache('Background/$color.png'));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64; // хардкод
    int scrollheight = ((game.fixedGameResolution.y + 100) / tileSize).floor();

    if (position.y > scrollheight * tileSize) position.y = -tileSize;

    super.update(dt);
  }
}
