import 'dart:ffi';
import 'dart:math';

import 'package:flutter/foundation.dart';

class PlayerData {
  final health = ValueNotifier<int>(5);

  final stamina = ValueNotifier<double>(1.0);

  final currentLevel = {};

  final ValueNotifier<Map<String, int>> inventory = ValueNotifier({
    'Cherries': 0,
    'Apple': 0,
    'Kiwi': 0,
  });

  /// Adds an item to the inventory
  void addItem(String itemName) {
    final updatedInventory = Map<String, int>.from(inventory.value);
    updatedInventory[itemName] = (updatedInventory[itemName] ?? 0) + 1;
    inventory.value = updatedInventory; // Notify listeners
  }

  /// Gets random items (1-3) and removes them from inventory
  List<String>? deleteRandomItems() {
    Random random = Random();
    final updatedInventory = Map<String, int>.from(inventory.value);

    List<String> availableItems = [];

    for (var entry in updatedInventory.entries) {
      if (entry.value > 0) {
        for (int i = 0; i < entry.value; i++) {
          availableItems.add(entry.key);
        }
      }
    }

    if (availableItems.isEmpty) return null;

    int itemsDiscartedPossibility = random.nextInt(100) + 1;
    int itemCount = itemsDiscartedPossibility < 20
        ? 1
        : itemsDiscartedPossibility < 50
            ? 2
            : 3;
    List<String> selectedItems = [];

    for (int i = 0; i < itemCount; i++) {
      if (availableItems.isEmpty) break;

      int randomIndex = random.nextInt(availableItems.length);
      String selectedItem = availableItems[randomIndex];
      selectedItems.add(selectedItem);

      // Decrease count in inventory
      updatedInventory[selectedItem] =
          (updatedInventory[selectedItem] ?? 0) - 1;

      // If count reaches 0, remove from available list
      availableItems.removeWhere((item) => updatedInventory[item] == 0);
    }

    inventory.value = updatedInventory; // Notify UI
    return selectedItems;
  }
}
