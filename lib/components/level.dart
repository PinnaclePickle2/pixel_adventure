import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/Saw.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/collectable.dart';
import 'package:pixel_adventure/components/collectable_dropped.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  Level(
      {required this.levelName,
      required this.player}); //Конструктор класса 'Уровень', нужно название уровня и игрок
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  //макс предметов на уровне
  int maxCherries =
      0; //gameRef.children.whereType<Level>().first.level.tileMap.getLayer("Background")?.properties.getValue('finalCherries');
  int maxKiwis =
      0; //gameRef.children.whereType<Level>().first.level.tileMap.getLayer("Background")?.properties.getValue('finalKiwis');
  int maxApples =
      0; //gameRef.children.whereType<Level>().first.level.tileMap.getLayer("Background")?.properties.getValue('finalApples');

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
        '$levelName.tmx', Vector2.all(16)); // Инициализация уровня
    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    const tileSize = 64;
    final numTilesX = (game.size.x / tileSize).floor();
    final numTilesY = (game.size.y / tileSize).floor();

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('Background_Color');

      for (double x = 0; x < numTilesX; x++) {
        for (double y = 0; y < game.size.y / numTilesY; y++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ??
                'Blue', // ?? - это сокращённый вариант  backgroundColor != null ? backgroundColor : 'Blue'
            position: Vector2(x * tileSize - tileSize, y * tileSize - tileSize),
          );

          add(backgroundTile);
        }
      }
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'GameCollectable':
            final collectable = GameCollectable(
              player: player,
              collectable: spawnPoint.name,
              position: Vector2(spawnPoint.x - 12, spawnPoint.y - 18),
              size: Vector2(24, 24), //хардкод размера collectable на уровне
            );
            add(collectable);

            if (spawnPoint.name == "Apple") maxApples += 1;
            if (spawnPoint.name == "Kiwi") maxKiwis += 1;
            if (spawnPoint.name == "Cherries") maxCherries += 1;

            break;

          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final minPosOffset = spawnPoint.properties.getValue('minPosOffset');
            final maxPosOffset = spawnPoint.properties.getValue('maxPosOffset');
            final saw = Saw(
                isVertical: isVertical,
                minPosOffset: minPosOffset,
                maxPosOffset: maxPosOffset,
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(saw);
            break;

          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
              isDebugModeOn: gameRef.isDebugModeOn,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;

          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isDebugModeOn: gameRef.isDebugModeOn,
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }

  void spawnDropCollectableObject(DroppedCollectable droppedCollectable) {
    add(droppedCollectable);
  }
}
