import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/character_select.dart';
import 'package:pixel_adventure/overlays/level_select.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/overlays/settings.dart';
import 'package:pixel_adventure/overlays/main_menu.dart';
import 'package:pixel_adventure/overlays/pause_menu.dart';
import 'package:pixel_adventure/overlays/game_over.dart';

void main() async {
  runApp(const MyApp());
}

//Инстанс игры чтобы не создавать несколько при каждом билде
final _game = PixelAdventure();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Пиксельное приключение',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget<PixelAdventure>(
          game: _game,
          overlayBuilderMap: {
            MainMenu.id: (context, game) => MainMenu(game: game),
            PauseMenu.id: (context, game) => PauseMenu(game: game),
            GameOver.id: (context, game) => GameOver(game: game),
            LevelSelect.id: (context, game) => LevelSelect(game: game),
            CharacterSelect.id: (context, game) => CharacterSelect(game: game),
            Settings.id: (context, game) => Settings(game: game),
          },
          initialActiveOverlays: const [MainMenu.id],
        ),
      ),
    );
  }
}

//   WidgetsFlutterBinding.ensureInitialized();
//   await Flame.device
//       .fullScreen(); //Устанавливает отображение игры на весь экран
//   await Flame.device
//       .setLandscape(); //Устанавливает горизонтальную ориентацию экрана

//   runApp(MaterialApp(
//       home: Scaffold(
//     body: GameWidget(
//       game: PixelAdventure(),
//       overlayBuilderMap: {
//         'MainMenu': (BuildContext context, PixelAdventure game) {
//           return MainMenu(game: game);
//         },
//         'InventoryOverlay': (BuildContext context, PixelAdventure game) {
//           return InventoryOverlay(
//             game: game,
//           );
//         },
//         'HealthBar': (BuildContext context, PixelAdventure game) {
//           return VerticalProgressBar(
//             game: game,
//             notifierIndex:
//                 0, //notifierIndex определяет, какой прогресс-бар (здоровье или стамина)
//             color: const Color.fromARGB(255, 255, 0, 0),
//             height: game.size.y * 0.65,
//             width: game.size.x * 0.018,
//             x: game.size.x * 0.013,
//             y: game.size.y * 0.31,
//           );
//         },
//         'StaminaBar': (BuildContext context, PixelAdventure game) {
//           return VerticalProgressBar(
//             game: game,
//             notifierIndex:
//                 1, //notifierIndex определяет, какой прогресс-бар (здоровье или стамина)
//             color: const Color.fromARGB(255, 0, 229, 255),
//             height: game.size.y * 0.65,
//             width: game.size.x * 0.018,
//             x: game.size.x * 0.05,
//             y: game.size.y * 0.31,
//           );
//         },
//       },
//     ),
//   )));
// }


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Flame.device
//       .fullScreen(); //Устанавливает отображение игры на весь экран
//   await Flame.device
//       .setLandscape(); //Устанавливает горизонтальную ориентацию экрана

//   runApp(MaterialApp(
//       home: Scaffold(
//     body: GameWidget(
//       game: PixelAdventure(),
//       overlayBuilderMap: {
//         'MainMenu': (BuildContext context, PixelAdventure game) {
//           return MainMenu(game: game);
//         },
//         'InventoryOverlay': (BuildContext context, PixelAdventure game) {
//           return InventoryOverlay(
//             game: game,
//           );
//         },
//         'HealthBar': (BuildContext context, PixelAdventure game) {
//           return VerticalProgressBar(
//             game: game,
//             notifierIndex:
//                 0, //notifierIndex определяет, какой прогресс-бар (здоровье или стамина)
//             color: const Color.fromARGB(255, 255, 0, 0),
//             height: game.size.y * 0.65,
//             width: game.size.x * 0.018,
//             x: game.size.x * 0.013,
//             y: game.size.y * 0.31,
//           );
//         },
//         'StaminaBar': (BuildContext context, PixelAdventure game) {
//           return VerticalProgressBar(
//             game: game,
//             notifierIndex:
//                 1, //notifierIndex определяет, какой прогресс-бар (здоровье или стамина)
//             color: const Color.fromARGB(255, 0, 229, 255),
//             height: game.size.y * 0.65,
//             width: game.size.x * 0.018,
//             x: game.size.x * 0.05,
//             y: game.size.y * 0.31,
//           );
//         },
//       },
//     ),
//   )));
// }