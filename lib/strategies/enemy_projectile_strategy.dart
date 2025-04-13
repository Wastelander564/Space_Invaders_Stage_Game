import 'package:my_game/components/enemy/enemy_projectile.dart';

abstract class ProjectileStrategy {
  void update(EnemyProjectile projectile, double dt);
}
