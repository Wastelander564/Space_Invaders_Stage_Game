import 'dart:math';
import 'package:flame/components.dart';
import 'package:my_game/components/player/projectile.dart';
import 'package:my_game/logic/object_pool.dart';
import 'enemy.dart';
import 'package:my_game/space_invader_game.dart';
import 'enemy_projectile.dart';
import 'package:my_game/strategies/enemy_projectile_strategy.dart';//enemy_projectile_strategy.dart
import 'package:my_game/strategies/zig_zag_strategy.dart';
import 'package:my_game/strategies/straight_down_strategy.dart';

class EnemyGrid extends PositionComponent {
  late List<Enemy> enemies;
  late ObjectPool<EnemyProjectile> projectilePool;

  final int rows = 5;
  final int cols = 11;
  final double spacing = 15.0;
  final double enemyWidth = 50.0;
  final double enemyHeight = 30.0;
  double direction = 1;
  double speed = 30;
  double moveDownDistance = 40;
  double time = 0;

  final double screenWidth;
  final SpaceInvadersGame game;
  final Random random = Random();

  EnemyGrid(this.screenWidth, this.game);

  @override
  Future<void> onLoad() async {
    double totalWidth = cols * (enemyWidth + spacing) - spacing;
    double startX = (screenWidth - totalWidth) / 2;

    enemies = [];
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final double x = startX + col * (enemyWidth + spacing);
        final double y = 50 + row * (enemyHeight + spacing);
        final enemy = Enemy(Vector2(x, y));
        enemies.add(enemy);
        add(enemy);
      }
    }

    // Initialize ObjectPool for EnemyProjectile
    projectilePool = ObjectPool<EnemyProjectile>(
      10, // Max size of the pool
      () => EnemyProjectile(0, 0, StraightDownStrategy()),
    );
  }

  @override
  void update(double dt) {
    time += dt;
    if (time >= 1) {
      time = 0;
      moveEnemies();
    }

    enemyShoot(); // Let enemies shoot projectiles
  }

  void moveEnemies() {
    bool atEdge = false;

    for (var enemy in enemies) {
      enemy.position.x += direction * speed;
    }

    for (var enemy in enemies) {
      if (enemy.position.x + enemyWidth >= screenWidth || enemy.position.x <= 0) {
        atEdge = true;
        break;
      }
    }

    if (atEdge) {
      for (var enemy in enemies) {
        enemy.moveDown(moveDownDistance);
      }
      direction *= -1;
    }
  }

void checkCollisions(List<Projectile> projectiles) {
    List<Enemy> enemiesToRemove = [];
    List<Projectile> projectilesToRemove = [];

    for (var projectile in projectiles) {
      for (var enemy in enemies) {
        if (projectile.collisionBox.overlaps(enemy.collisionBox)) {
          enemiesToRemove.add(enemy);
          projectilesToRemove.add(projectile);
          break;
        }
      }
    }

    for (var enemy in enemiesToRemove) {
      enemy.removeFromParent();
      enemies.remove(enemy);
    }

    for (var projectile in projectilesToRemove) {
      projectile.removeFromParent();
    }

    projectiles.removeWhere((p) => projectilesToRemove.contains(p));
  }

  void enemyShoot() {
    if (enemies.isNotEmpty && random.nextDouble() < 0.01) {
      final shooter = enemies[random.nextInt(enemies.length)];
      
      // List of strategies
      List<ProjectileStrategy> strategies = [
        StraightDownStrategy(),
        ZigZagStrategy(),
        // You can add more strategies here
      ];
      
      // Select a random strategy
      final selectedStrategy = strategies[random.nextInt(strategies.length)];

      final bullet = EnemyProjectile(
        shooter.position.x + shooter.size.x / 2,
        shooter.position.y + shooter.size.y,
        selectedStrategy, // Pass the selected strategy
      );

      game.enemyProjectiles.add(bullet);
      parent?.add(bullet);
    }
  }
}