// import 'dart:math';
// import 'package:flutter/material.dart';

// class InventoryManager {
//   final ValueNotifier<Map<String, int>> inventoryNotifier = ValueNotifier({
//     'Cherries': 0,
//     'Apple': 0,
//     'Kiwi': 0,
//   });

//   InventoryManager(); //: inventoryNotifier = ValueNotifier({});

//   /// Adds an item to the inventory
//   void addItem(String itemName) {
//     final updatedInventory = Map<String, int>.from(inventoryNotifier.value);
//     updatedInventory[itemName] = (updatedInventory[itemName] ?? 0) + 1;
//     inventoryNotifier.value = updatedInventory; // Notify listeners
//   }

//   /// Gets random items (1-3) and removes them from inventory
//   List<String>? deleteRandomItems() {
//     Random random = Random();
//     final updatedInventory = Map<String, int>.from(inventoryNotifier.value);

//     List<String> availableItems = [];

//     for (var entry in updatedInventory.entries) {
//       if (entry.value > 0) {
//         for (int i = 0; i < entry.value; i++) {
//           availableItems.add(entry.key);
//         }
//       }
//     }

//     if (availableItems.isEmpty) return null;

//     int itemsDiscartedPossibility = random.nextInt(100) + 1;
//     int itemCount = itemsDiscartedPossibility < 20
//         ? 1
//         : itemsDiscartedPossibility < 50
//             ? 2
//             : 3;
//     List<String> selectedItems = [];

//     for (int i = 0; i < itemCount; i++) {
//       if (availableItems.isEmpty) break;

//       int randomIndex = random.nextInt(availableItems.length);
//       String selectedItem = availableItems[randomIndex];
//       selectedItems.add(selectedItem);

//       // Decrease count in inventory
//       updatedInventory[selectedItem] =
//           (updatedInventory[selectedItem] ?? 0) - 1;

//       // If count reaches 0, remove from available list
//       availableItems.removeWhere((item) => updatedInventory[item] == 0);
//     }

//     inventoryNotifier.value = updatedInventory; // Notify UI
//     return selectedItems;
//   }
// }


// print(availableItems);

//     availableItems = updatedInventory.entries
//         .where((entry) => entry.value > 0)
//         .map((entry) => entry.key)
//         .toList();

//     if (availableItems.isEmpty) return null;

//     int itemCount = min(3, availableItems.length);
//     List<String> selectedItems = [];

//     for (int i = 0; i < itemCount; i++) {
//       if (availableItems.isEmpty) break;

//       int randomIndex = random.nextInt(availableItems.length);
//       String selectedItem = availableItems[randomIndex];
//       selectedItems.add(selectedItem);

//       // Decrease count in inventory
//       updatedInventory[selectedItem] =
//           (updatedInventory[selectedItem] ?? 0) - 1;

//       // If count reaches 0, remove from available list
//       if (updatedInventory[selectedItem] == 0) {
//         availableItems.removeAt(randomIndex);
//       }
//     }

//     inventoryNotifier.value = updatedInventory; // Notify UI





// class InventoryManager {
//   final Map<String, int> inventory = {
//     'Cherries': 0,
//     'Apples': 0,
//     'Kiwis': 0,
//   };

//   InventoryManager();

//   /// Добавляет предмет в инвентарь
//   void addItem(String itemName) {
//     inventory[itemName] = (inventory[itemName] ?? 0) + 1;
//   }

//   /// Получает случайные предметы (1-3 штуки), уменьшая их количество
//   List<String>? getRandomItems() {
//     Random random = Random();

//     // Фильтруем предметы, у которых количество > 0
//     List<String> availableItems = inventory.entries
//         .where((entry) => entry.value > 0)
//         .map((entry) => entry.key)
//         .toList();

//     if (availableItems.isEmpty) return null; // Если нет доступных предметов

//     int itemCount = min(3, availableItems.length);
//     List<String> selectedItems = [];

//     for (int i = 0; i < itemCount; i++) {
//       if (availableItems.isEmpty) break;

//       int randomIndex = random.nextInt(availableItems.length);
//       String selectedItem = availableItems[randomIndex];
//       selectedItems.add(selectedItem);

//       // Уменьшаем количество в инвентаре
//       inventory[selectedItem] = (inventory[selectedItem] ?? 0) - 1;

//       // Если предмет закончился, убираем из списка доступных
//       if (inventory[selectedItem] == 0) {
//         availableItems.removeAt(randomIndex);
//       }
//     }

//     return selectedItems;
//   }
// }
