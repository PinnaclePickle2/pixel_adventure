import 'dart:ui';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class StaminaBarComponent extends PositionComponent
    with HasGameReference<PixelAdventure> {
  final double barWidth;
  final double barHeight;
  final Color fillColor;
  final Color backgroundColor;

  late final RectangleComponent _background;
  late final RectangleComponent _fill;

  StaminaBarComponent({
    this.barWidth = 16,
    this.barHeight = 100,
    this.fillColor = const Color.fromARGB(255, 100, 255, 100),
    this.backgroundColor = const Color.fromARGB(150, 0, 0, 0),
    Vector2? position,
  }) : super(
          size: Vector2(barWidth, barHeight),
          position: position ?? Vector2(10, 150),
        );

  @override
  Future<void> onLoad() async {
    // Фон — не изменяется
    _background = RectangleComponent(
      size: size.clone(),
      paint: Paint()..color = backgroundColor,
      anchor: Anchor.topLeft,
      position: Vector2.zero(),
    );

    // Заполняемая часть
    _fill = RectangleComponent(
      size: Vector2(barWidth, barHeight),
      paint: Paint()..color = fillColor,
      anchor: Anchor.bottomLeft,
      position: Vector2(0, barHeight), // нижняя точка старта
    );

    // Сначала фон, потом заполнение (внутри вниз вверх)
    await add(_background);
    await add(_fill);

    game.playerData.stamina.addListener(_updateBar);
    _updateBar();
  }

  void _updateBar() {
    final value = game.playerData.stamina.value.clamp(0.0, 1.0);
    _fill.size.y = barHeight * value;
    _fill.position.y = barHeight; // точка привязки снизу
  }

  @override
  void onRemove() {
    game.playerData.stamina.removeListener(_updateBar);
    super.onRemove();
  }
}
