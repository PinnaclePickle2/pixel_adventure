import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class CollisionBlock extends PositionComponent with HasGameRef<PixelAdventure> {
  bool isPlatform;
  bool isDebugModeOn;

  // super передаёт position и size в PositionComponent (то есть тому, от чего наследуем)
  CollisionBlock(
      {position, size, this.isPlatform = false, this.isDebugModeOn = false})
      : super(
          position: position,
          size: size,
        ) {
    //DEBUG
    debugMode = isDebugModeOn;
  }
}
