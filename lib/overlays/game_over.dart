import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/player_data/player_data.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/main_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/pixel_adventure_gameplay.dart';

class GameOver extends StatelessWidget {
  static const id = 'GameOver';
  final PixelAdventure game;

  const GameOver({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    AudioManager.playBgm('main_menu.wav');
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
                  game.overlays.remove(id);
                  game.resumeEngine();
                  game.removeAll(game.children);
                  game.add(GamePlay());
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  backgroundColor: const Color.fromARGB(255, 54, 174, 54),
                ),
                child: const Text(
                  'С начала',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 190,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
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
