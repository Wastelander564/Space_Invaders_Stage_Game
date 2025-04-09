import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'space_invader_game.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef<SpaceInvadersGame> {
  static const double speed = 50;
  final Vector2 startPos;

  Enemy(this.startPos) {
    size = Vector2(32, 16); // 2 frames * 16px
    position = startPos.clone();
  }

  @override
  Future<void> onLoad() async {
    animation = await gameRef.loadSpriteAnimation(
      'SpaceInvaderCrab.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.5,
        textureSize: Vector2(16, 16),
      ),
    );
  }

  // Method to move the enemy down
  void moveDown(double distance) {
    position.y += distance;
  }

  // Method to get the collision box for the enemy
  Rect get collisionBox =>
      Rect.fromLTWH(position.x, position.y, size.x, size.y);
}