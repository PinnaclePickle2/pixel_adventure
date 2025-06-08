import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class MainMenu extends StatelessWidget {
  // Reference to parent game.
  final PixelAdventure game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: game.size.y,
          width: game.size.x,
          decoration: const BoxDecoration(
            color: blackTextColor,
            // borderRadius: const BorderRadius.all(
            //   Radius.circular(20),
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'МЕДВЕДЬ ЗАСТАВИЛ ТЕБЯ СОБИРАТЬ ДЛЯ НЕГО ЯГОДЫ И ФРУКТЫ',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('MainMenu');

                    game.overlays.add('InventoryOverlay');
                    game.overlays.add('HealthBar');
                    game.overlays.add('StaminaBar');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                '''Используй WASD и ПРОБЕЛ на пк или
кнопки-контроллеры на телефоне 
для перемещения.
Собери все фрукты и избегай опасностей!''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
