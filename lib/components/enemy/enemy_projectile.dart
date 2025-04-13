import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:my_game/space_invader_game.dart';
import 'package:my_game/strategies/enemy_projectile_strategy.dart';

class EnemyProjectile extends SpriteComponent with HasGameRef<SpaceInvadersGame> {
  ProjectileStrategy strategy;

  EnemyProjectile(double startX, double startY, this.strategy) {
    size = Vector2(10, 20);
    position = Vector2(startX - size.x / 2, startY);
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('DGS-EnemyBullet.png');
    FlameAudio.play('8-bit-laser-151672.mp3', volume: 0.20);
  }

  void reset(double startX, double startY, ProjectileStrategy newStrategy) {
    position = Vector2(startX - size.x / 2, startY);
    strategy = newStrategy;
  }

  @override
  void update(double dt) {
    super.update(dt);
    strategy.update(this, dt);

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }


  Rect get collisionBox =>
      Rect.fromLTWH(position.x, position.y, size.x, size.y);
}