import 'enemy_projectile_strategy.dart';
import 'package:my_game/components/enemy/enemy_projectile.dart';

class StraightDownStrategy extends ProjectileStrategy {
  static const double speed = 150;

  @override
  void update(EnemyProjectile projectile, double dt) {
    projectile.position.y += speed * dt;
  }
}
