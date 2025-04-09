import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'space_invader_game.dart';
import 'enemy_projectile_strategy.dart';

class EnemyProjectile extends SpriteComponent with HasGameRef<SpaceInvadersGame> {
  ProjectileStrategy strategy;

  EnemyProjectile(double startX, double startY, this.strategy) {
    size = Vector2(10, 20);
    position = Vector2(startX - size.x / 2, startY);
  }

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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final Paint paintWithTint = Paint()
      ..colorFilter = ColorFilter.mode(
        const Color.fromARGB(170, 255, 162, 0),
        BlendMode.srcATop,
      );
    canvas.drawImage(sprite!.image, position.toOffset(), paintWithTint);
  }

  Rect get collisionBox =>
      Rect.fromLTWH(position.x, position.y, size.x, size.y);
}
