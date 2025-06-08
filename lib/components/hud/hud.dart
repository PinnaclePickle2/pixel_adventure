import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/hud/vertical_progress_bar.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/overlays/game_over.dart';
import 'package:pixel_adventure/overlays/pause_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

final Map<String, String> itemNames = {
  'Apple': 'Яблоко',
  'Cherries': 'Вишня',
  'Kiwi': 'Киви',
};

class Hud extends Component with HasGameReference<PixelAdventure> {
  late final TextComponent healthTextComponent;
  late final TextComponent inventoryComponent;

  Hud({super.children, super.priority});

  @override
  Future<void> onLoad() async {
    //отображение здоровья
    healthTextComponent = TextComponent(
        text: '❤️x5',
        scale: Vector2(2, 2),
        anchor: Anchor.topRight,
        position: Vector2(game.fixedCamResolution.x - 10, 74),
        textRenderer: TextPaint(
            style: const TextStyle(
          color: Color.fromARGB(255, 30, 118, 37),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )));
    await add(healthTextComponent);

    //отображение инвентаря
    inventoryComponent = TextComponent(
      text: buildInventoryText(game.playerData.inventory.value),
      anchor: Anchor.topLeft,
      position: Vector2(10, 10),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 30, 118, 37),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    await add(inventoryComponent);

    //отображение стамины
    final staminaBar = StaminaBarComponent(
      position: Vector2(10,
          game.fixedCamResolution.y - 175), // Позиция на экране (слева сверху)
      barHeight: 100,
      barWidth: 12,
      fillColor: Colors.green,
    );
    await add(staminaBar);

    game.playerData.stamina.addListener(onStaminaChange);
    game.playerData.health.addListener(onHealthChange);
    game.playerData.inventory.addListener(onInventoryChange);

    final pauseButton = SpriteButtonComponent(
      onPressed: () {
        AudioManager.pauseBgm();
        game.pauseEngine();
        game.overlays.add(PauseMenu.id);
      },
      button: Sprite(
        game.images.fromCache('HUD/PauseButton.png'),
      ),
      size: Vector2.all(64),
      anchor: Anchor.topRight,
      position: Vector2(game.fixedCamResolution.x - 10, 10),
    );
    await add(pauseButton);
  }

  String buildInventoryText(Map<String, int> inventory) {
    if (inventory.isEmpty) return 'Инвентарь: пуст';

    return inventory.entries.map((e) {
      final itemName = itemNames[e.key] ?? e.key; // fallback если нет имени
      return '$itemName: ${e.value}';
    }).join('\n');
  }

  void onInventoryChange() {
    inventoryComponent.text =
        buildInventoryText(game.playerData.inventory.value);
  }

  @override
  void onRemove() {
    game.playerData.health.removeListener(onHealthChange);
    game.playerData.inventory.removeListener(onInventoryChange);
    game.playerData.stamina.removeListener(onStaminaChange);
    super.onRemove();
  }

  // Updates health text on hud.
  void onHealthChange() {
    healthTextComponent.text = '💔x${game.playerData.health.value}';

    // Load game over overlay if health is zero.
    if (game.playerData.health.value == 0) {
      AudioManager.stopBgm();
      game.pauseEngine();
      game.overlays.add(GameOver.id);
    }
  }

  // Updates health text on hud.
  void onStaminaChange() {
    if (game.playerData.stamina.value == 0) {}
  }
}
