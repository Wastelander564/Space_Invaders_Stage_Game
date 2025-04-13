import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:my_game/space_invader_game.dart';
import 'package:my_game/decorator/tint_decorator.dart';

class LivesDisplay extends PositionComponent with HasGameRef<SpaceInvadersGame> {
  int lives = 3;
  final double screenWidth;
  final List<Component> lifeIcons = [];

  LivesDisplay(this.screenWidth);

  @override
  Future<void> onLoad() async {
    final sprite = await gameRef.loadSprite('heart-DGS.png');
    const double iconSize = 24;
    final double spacing = 8;
    final double startX = screenWidth - (iconSize + spacing) * lives;

    for (int i = 0; i < lives; i++) {
      final icon = SpriteComponent(
        sprite: sprite,
        size: Vector2(iconSize, iconSize),
        position: Vector2.zero(), // Will be offset via the decorator
      );

      final decoratedIcon = TintDecoratorComponent(
        child: icon,
        tintColor: const Color.fromARGB(170, 0, 132, 255), // orange-ish tint
      )
        ..position = Vector2(startX + i * (iconSize + spacing), 10)
        ..size = Vector2(iconSize, iconSize);

      lifeIcons.add(decoratedIcon);
      add(decoratedIcon);
    }
  }

  void loseLife() {
    if (lives > 0) {
      lives--;
      final iconToRemove = lifeIcons.removeLast();
      iconToRemove.removeFromParent();
    }
  }
}
