import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class VerticalProgressBar extends StatelessWidget {
  final PixelAdventure game;

  final double width;
  final double height;
  final Color color;
  final Color backgroundColor;
  final double x;
  final double y;
  final int notifierIndex;

  const VerticalProgressBar({
    super.key,
    required this.game,
    required this.notifierIndex,
    this.width = 20.0,
    this.height = 200.0,
    this.x = 300,
    this.y = 700,
    this.color = const Color.fromARGB(255, 0, 0, 0),
    this.backgroundColor = Colors.black26,
  });

  @override
  Widget build(BuildContext context) {
    //print('ребилд виджета');
    return Positioned(
      left: x, // Размещение по горизонтали
      top: y, // Размещение по вертикали
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ValueListenableBuilder<List<double>>(
          valueListenable: game.player.notifiers,
          builder: (context, value, child) {
            return Stack(
              alignment: Alignment.bottomCenter, // Заполняется снизу вверх
              children: [
                Container(
                  width: width,
                  height: height * value[notifierIndex], // Прогресс от 0 до 1
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        (color.a * 255).toInt().clamp(0, 255),
                        (value[notifierIndex] * 255 + 50).toInt().clamp(0, 255),
                        (color.g * 255).toInt().clamp(0, 255),
                        (color.b * 255).toInt().clamp(0, 255)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
