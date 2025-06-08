import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/main_menu.dart';
import 'package:pixel_adventure/overlays/settings.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/pixel_adventure_gameplay.dart';

class LevelSelect extends StatefulWidget {
  static const id = 'LevelSelect';
  final PixelAdventure game;

  const LevelSelect({required this.game, super.key});

  @override
  State<LevelSelect> createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: List.generate(8, (index) {
                final levelNum = index;
                final isSelected = widget.game.currentLevelNum == levelNum;
                final levelNumPlus1 = index + 1;

                return SizedBox(
                  width: 75,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.game.currentLevelNum = levelNum;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? const Color.fromARGB(255, 109, 195, 92)
                          : const Color.fromARGB(255, 94, 161, 249),
                      side: isSelected
                          ? const BorderSide(
                              color: Color.fromARGB(255, 210, 210, 210),
                              width: 4)
                          : BorderSide.none,
                    ),
                    child: Text(
                      '$levelNumPlus1',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  widget.game.showMainMenuBackground(); // Сначала добавляем фон
                  widget.game.overlays.remove(LevelSelect.id);
                  widget.game.overlays.add(MainMenu.id);
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
}
