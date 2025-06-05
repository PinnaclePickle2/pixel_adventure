import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/ui/main_menu_overlay.dart';
import 'package:pixel_adventure/components/ui/inventory_overlay.dart';
import 'package:pixel_adventure/components/ui/vertical_progress_bar.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device
      .fullScreen(); //Устанавливает отображение игры на весь экран
  await Flame.device
      .setLandscape(); //Устанавливает горизонтальную ориентацию экрана

  runApp(MaterialApp(
      home: Scaffold(
    body: GameWidget(
      game: PixelAdventure(),
      overlayBuilderMap: {
        'MainMenu': (BuildContext context, PixelAdventure game) {
          return MainMenu(game: game);
        },
        'InventoryOverlay': (BuildContext context, PixelAdventure game) {
          return InventoryOverlay(
            game: game,
          );
        },
        'HealthBar': (BuildContext context, PixelAdventure game) {
          return VerticalProgressBar(
            game: game,
            notifierIndex:
                0, //notifierIndex определяет, какой прогресс-бар (здоровье или стамина)
            color: const Color.fromARGB(255, 255, 0, 0),
            height: game.size.y * 0.65,
            width: game.size.x * 0.018,
            x: game.size.x * 0.013,
            y: game.size.y * 0.31,
          );
        },
        'StaminaBar': (BuildContext context, PixelAdventure game) {
          return VerticalProgressBar(
            game: game,
            notifierIndex:
                1, //notifierIndex определяет, какой прогресс-бар (здоровье или стамина)
            color: const Color.fromARGB(255, 0, 229, 255),
            height: game.size.y * 0.65,
            width: game.size.x * 0.018,
            x: game.size.x * 0.05,
            y: game.size.y * 0.31,
          );
        },
      },
    ),
  )));
}



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Flame.device
//       .fullScreen(); //Устанавливает отображение игры на весь экран
//   await Flame.device
//       .setLandscape(); //Устанавливает горизонтальную ориентацию экрана

//   PixelAdventure game = PixelAdventure();
//   runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));

// }






    // GameWidget<PixelAdventure>.controlled(
    //   gameFactory: PixelAdventure.new,
    //   overlayBuilderMap: {
    //     'MainMenu': (_, game) => MainMenu(game: game),
    //     'InventoryOverlay': (BuildContext context, PixelAdventure game) {
    //       return InventoryOverlay(
    //           game: game,
    //           player: game.player,
    //           inventoryManager: game.inventoryManager);
    //     }
    //   },
    //   initialActiveOverlays: const ['MainMenu'],
    // ),
