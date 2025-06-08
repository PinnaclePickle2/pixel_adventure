import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/character_select.dart';
import 'package:pixel_adventure/overlays/level_select.dart';
import 'package:pixel_adventure/overlays/main_menu_background/main_menu_background.dart';
import 'package:pixel_adventure/overlays/settings.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/pixel_adventure_gameplay.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';
  final PixelAdventure game;

  const MainMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    //Музыка главного меню
    AudioManager.playBgm('main_menu.wav');

    //Добавить бегающих от пилы персонажей на задний план
    game.showMainMenuBackground();

    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 41, 41, 41),
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
                  game.hideMainMenuBackground();
                  game.overlays.remove(id);
                  game.add(GamePlay());
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  backgroundColor: const Color.fromARGB(255, 54, 174, 54),
                ),
                child: const Text(
                  'Играть',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            //Кнопка Настройки
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.overlays.add(Settings.id);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  backgroundColor: Color.fromARGB(255, 94, 161, 249),
                ),
                child: const Text(
                  'Настройки',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            //Кнопка Выбор уровня
            SizedBox(
              width: 180,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.overlays.add(LevelSelect.id);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  backgroundColor: Color.fromARGB(255, 94, 161, 249),
                ),
                child: const Text(
                  'Выбор уровня',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            //Кнопка Выбор скина
            SizedBox(
              width: 160,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.overlays.add(CharacterSelect.id);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  backgroundColor: Color.fromARGB(255, 94, 161, 249),
                ),
                child: const Text(
                  'Выбор скина',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  'Выход',
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
