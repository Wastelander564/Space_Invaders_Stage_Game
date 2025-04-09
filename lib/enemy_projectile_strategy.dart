import 'enemyProjectile.dart';

abstract class ProjectileStrategy {
  void update(EnemyProjectile projectile, double dt);
}
