import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/main_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Settings extends StatelessWidget {
  static const id = 'Settings';
  final PixelAdventure game;

  const Settings({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: ValueListenableBuilder<bool>(
                valueListenable: AudioManager.bgm,
                builder: (context, bgm, child) => SwitchListTile(
                  title: const Text('Музыка'),
                  value: bgm,
                  onChanged: (value) =>
                      bgAudioChange(value), //AudioManager.bgm.value = value,
                  activeColor: Color.fromARGB(255, 54, 174, 54),
                ),
              ),
            ),
            //Кнопка назад в меню
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  game.showMainMenuBackground(); // Сначала добавляем фон
                  game.overlays.remove(id);
                  game.overlays.add(MainMenu.id);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  'Назад в меню',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void bgAudioChange(bool change) {
    AudioManager.pauseBgm();
    AudioManager.bgm.value = change;
    AudioManager.resumeBgm();
  }
}
