import 'enemy_projectile_strategy.dart';
import 'package:my_game/components/enemy/enemy_projectile.dart';
import 'dart:math';

class ZigZagStrategy extends ProjectileStrategy {
  static const double verticalSpeed = 120;
  static const double horizontalAmplitude = 50;
  static const double frequency = 3; // controls speed of zig-zag

  double _time = 0;

  @override
  void update(EnemyProjectile projectile, double dt) {
    _time += dt;
    projectile.position.y += verticalSpeed * dt;
    projectile.position.x += sin(_time * frequency) * horizontalAmplitude * dt;
  }
}
