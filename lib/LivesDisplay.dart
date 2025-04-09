import 'package:flame/components.dart';
import 'space_invader_game.dart';

class LivesDisplay extends PositionComponent with HasGameRef<SpaceInvadersGame> {
  int lives = 3;
  final double screenWidth;
  final List<SpriteComponent> lifeIcons = [];

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
        position: Vector2(startX + i * (iconSize + spacing), 10),
      );
      lifeIcons.add(icon);
      add(icon);
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