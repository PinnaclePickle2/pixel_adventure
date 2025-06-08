import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/main_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseMenu';
  final PixelAdventure game;

  const PauseMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41).withAlpha(100),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5.0,
          children: [
            //Кнопка играть
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  AudioManager.resumeBgm();
                  game.overlays.remove(id);
                  game.resumeEngine();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  backgroundColor: const Color.fromARGB(255, 54, 174, 54),
                ),
                child: const Text(
                  'Продолжить',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 190,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  game.showMainMenuBackground(); // Сначала добавляем фон
                  game.overlays.remove(id);
                  game.resumeEngine();
                  game.removeAll(game.children);
                  game.overlays.add(MainMenu.id);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  'В главное меню',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
