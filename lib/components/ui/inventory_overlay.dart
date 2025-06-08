import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class InventoryOverlay extends StatelessWidget {
  final PixelAdventure game;

  const InventoryOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ValueListenableBuilder<Map<String, int>>(
          valueListenable: game.playerData.inventory,
          builder: (context, inventory, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: inventory.entries.map((entry) {
                return Column(
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      entry.value.toString(),
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}





// class InventoryOverlay extends StatelessWidget {
//   final PixelAdventure game;

//   InventoryOverlay({
//     Key? key,
//     required this.game,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 10,
//       left: 10,
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.black54,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: game.inventoryManager.inventory.entries.map((entry) {
//             return Column(
//               children: [
//                 Text(
//                   entry.key,
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//                 Text(
//                   entry.value.toString(),
//                   style: TextStyle(
//                       color: Colors.yellow,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }







// class HudInventoryWidget extends HudMarginComponent {
//   final Map<String, int> inventory;

//   HudInventoryWidget(this.inventory);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.black54,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: inventory.entries.map((entry) {
//           return Column(
//             children: [
//               Text(
//                 entry.key,
//                 style: TextStyle(color: Colors.white, fontSize: 14),
//               ),
//               Text(
//                 entry.value.toString(),
//                 style: TextStyle(
//                     color: Colors.yellow,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class HudInventoryComponent extends SpriteComponent
//     with HasGameRef<PixelAdventure> {
//   final Map<String, int> inventory = {
//     //Ключ:    Значение
//     "Cherries": 0,
//     "Apples": 0,
//     "Kiwis": 0,
//   };

//   HudInventoryComponent();

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     position = Vector2(10, 10); // Отступ от левого верхнего угла
//     size = Vector2(150, 100); // Примерный размер
//     add(HudInventoryWidget(inventory));
//   }
// }



  // CollectablesInventory();

  // var inventory = {
  // //Ключ:    Значение
  // 'Cherries': 0,
  // 'Apples': 0,
  // 'Kiwis': 0,
  // };

  // @override
  // FutureOr<void> onLoad() {
  //   throw UnimplementedError();
  // }

  // void onCollectablePickup(GameCollectable collectable) {
  //   inventory[collectable.collectable] = inventory[collectable.collectable]! + 1;
  // }

  // List <DroppedCollectable> onCollectableDropped {

  //   return <DroppedCollectable>[];
  // }
