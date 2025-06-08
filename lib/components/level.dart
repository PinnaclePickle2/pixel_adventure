import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/Saw.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/collectable.dart';
import 'package:pixel_adventure/components/collectable_dropped.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/door.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/pixel_adventure_gameplay.dart';

class Level extends Component
    with HasGameRef<PixelAdventure>, ParentIsA<GamePlay> {
  final String levelName;
  final Player player;
  Level(
      {required this.levelName,
      required this.player}); //Конструктор класса 'Уровень', нужно название уровня и игрок
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
        '$levelName.tmx', Vector2.all(16)); // Инициализация уровня
    await add(level);

    await _scrollingBackground();
    await _spawningObjects();
    await _addCollisions();
    await _playMusic(level);

    return super.onLoad();
  }

  Future<void> _scrollingBackground() async {
    final backgroundLayer = level.tileMap.getLayer('Background');

    const tileSize = 64;
    final numTilesX = (game.fixedGameResolution.x / tileSize).floor();
    final numTilesY = (game.fixedGameResolution.y / tileSize).floor();

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('Background_Color');

      for (double x = 0; x < game.fixedGameResolution.x / numTilesX; x++) {
        for (double y = 0; y < game.fixedGameResolution.y / numTilesY; y++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ??
                'Blue', // ?? - это сокращённый вариант  backgroundColor != null ? backgroundColor : 'Blue'
            position: Vector2(
                (x - 20) * tileSize - tileSize, (y - 50) * tileSize - tileSize),
          );

          add(backgroundTile);
        }
      }
    }
  }

  Future<void> _spawningObjects() async {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            await _setupCamera(level, Vector2(spawnPoint.x, spawnPoint.y));
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
            break;
          case 'LevelExit':
            final door = Door(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(door);
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

  Future<void> _addCollisions() async {
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

  Future<void> _setupCamera(TiledComponent level, Vector2 position) async {
    parent.cam.follow(player, maxSpeed: 1000);
    parent.cam.viewfinder.position = position;
    parent.cam.setBounds(
      Rectangle.fromLTRB(
        -0.5 * game.fixedGameResolution.x,
        0.5 * game.fixedGameResolution.y,
        0.5 * game.fixedGameResolution.x,
        -0.5 * game.fixedGameResolution.y,
      ),
    );
  }

  void spawnDropCollectableObject(DroppedCollectable droppedCollectable) {
    add(droppedCollectable);
  }
}

Future<void> _playMusic(TiledComponent level) async {
  final musicFile =
      level.tileMap.map.properties.getValue<String>('MusicName') ?? 'level.wav';
  AudioManager.playBgm(musicFile);
}
