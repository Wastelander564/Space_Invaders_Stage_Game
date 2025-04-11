import 'enemy_projectile.dart';

abstract class ProjectileStrategy {
  void update(EnemyProjectile projectile, double dt);
}
