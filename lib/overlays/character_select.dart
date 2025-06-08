import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/overlays/main_menu.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class CharacterSelect extends StatefulWidget {
  static const id = 'CharacterSelect';
  final PixelAdventure game;

  const CharacterSelect({required this.game, super.key});

  @override
  State<CharacterSelect> createState() => _CharacterSelectState();
}

class _CharacterSelectState extends State<CharacterSelect>
    with TickerProviderStateMixin {
  SpriteAnimation? currentAnimation;
  late SpriteAnimationTicker animationTicker;
  final double stepTime = 0.05;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    final character = widget.game.skins[widget.game.currentSkinNum];
    const state = 'Idle';

    final image = widget.game.images.fromCache(
      'Main Characters/$character/$state (32x32).png',
    );

    final animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 11,
        stepTime: 0.05,
        textureSize: Vector2(32, 32),
      ),
    );

    setState(() {
      currentAnimation = animation;
      animationTicker = SpriteAnimationTicker(animation);
    });
  }

  void _onSelectSkin(int index) {
    setState(() {
      widget.game.currentSkinNum = index;
    });
    _loadAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final currentSkin = widget.game.currentSkinNum;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Левая колонка
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: List.generate(widget.game.skins.length, (index) {
                    final isSelected = currentSkin == index;

                    return SizedBox(
                      width: 75,
                      height: 75,
                      child: ElevatedButton(
                        onPressed: () => _onSelectSkin(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? const Color.fromARGB(255, 109, 195, 92)
                              : const Color.fromARGB(255, 94, 161, 249),
                          side: isSelected
                              ? const BorderSide(
                                  color: Color.fromARGB(255, 210, 210, 210),
                                  width: 4,
                                )
                              : BorderSide.none,
                        ),
                        child: Text(
                          '$index',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.game
                        .showMainMenuBackground(); // Сначала добавляем фон
                    widget.game.overlays.remove(CharacterSelect.id);
                    widget.game.overlays.add(MainMenu.id);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text(
                    'Назад в меню',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 30),

            // Спрайтовая анимация
            currentAnimation != null
                ? SizedBox(
                    width: 100,
                    height: 100,
                    child: SpriteAnimationWidget(
                      animation: currentAnimation!,
                      animationTicker: animationTicker,
                      anchor: Anchor.center,
                    ),
                  )
                : const SizedBox(width: 100, height: 100),
          ],
        ),
      ),
    );
  }
}
