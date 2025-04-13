import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player/player.dart';
import 'components/player/projectile.dart';
import 'components/enemy/enemy_grid.dart';
import 'components/ground.dart';
import 'components/enemy/enemy_projectile.dart';
import 'components/lives_display.dart';
import 'logic/projectile_pool.dart';

import 'logic/game_bloc.dart';
import 'logic/game_event.dart';
import 'logic/game_state.dart';

class SpaceInvadersGame extends FlameGame with KeyboardEvents {
  late Player player;
  late EnemyGrid enemyGrid;
  late Ground ground;
  late LivesDisplay livesDisplay;
  late ProjectilePool projectilePool;

  List<EnemyProjectile> enemyProjectiles = [];
  List<Projectile> projectiles = [];

  bool musicStarted = false;
  late GameBloc gameBloc;

  @override
  Future<void> onLoad() async {
    gameBloc = GameBloc();

    // Listen to game state changes and show overlays
    gameBloc.stream.listen((state) {
      overlays.remove('WinOverlay');
      overlays.remove('LoseOverlay');

      if (state is GameLost) {
        musicStarted = false;
        overlays.add('LoseOverlay');
      } else if (state is GameWon) {
        musicStarted = false;
        overlays.add('WinOverlay');
      } else if (state is GamePlaying) {
        overlays.remove('WinOverlay');
        overlays.remove('LoseOverlay');
      }
    });

    gameBloc.add(StartGame());

    projectilePool = ProjectilePool();
    FlameAudio.bgm.initialize();

    final double screenWidth = size.x;
    final double screenHeight = size.y;

    ground = Ground(screenWidth, screenHeight);
    add(ground);

    livesDisplay = LivesDisplay(screenWidth);
    add(livesDisplay);

    player = Player(screenWidth, screenHeight, this, projectilePool);
    add(player);

    enemyGrid = EnemyGrid(screenWidth, this);
    add(enemyGrid);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameBloc.state is! GamePlaying) return;

    for (var projectile in List.from(projectiles)) {
      projectile.update(dt);
    }

    for (var enemyProjectile in List.from(enemyProjectiles)) {
      enemyProjectile.update(dt);

      if (enemyProjectile.collisionBox.overlaps(player.collisionBox)) {
        enemyProjectile.removeFromParent();
        enemyProjectiles.remove(enemyProjectile);

        livesDisplay.loseLife();

        if (livesDisplay.lives <= 0) {
          player.removeFromParent();
          gameBloc.add(LoseGame());
          return;
        }
        break;
      }
    }

    enemyGrid.checkCollisions(projectiles);
    enemyGrid.enemyShoot();

    if (enemyGrid.enemies.isEmpty) {
      gameBloc.add(WinGame());
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (gameBloc.state is! GamePlaying) return KeyEventResult.handled;

    if (event is KeyDownEvent) {
      if (!musicStarted) {
        FlameAudio.bgm.play('space-invaders-classic-arcade-game-116826.mp3');
        musicStarted = true;
      }

      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.moveLeft();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.moveRight();
      }

      if (keysPressed.contains(LogicalKeyboardKey.space)) {
        _shootProjectile();
      }
    } else if (event is KeyUpEvent) {
      if (!keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
          !keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.stopMoving();
      }
    }

    return KeyEventResult.handled;
  }

  void _shootProjectile() {
    final projectile = projectilePool.getProjectile(player.position.x, player.position.y);
    projectile.position = player.position.clone();
    projectiles.add(projectile);
    add(projectile);
  }

  void resetGame() {
    clearGameObjects();

    final double screenWidth = size.x;
    final double screenHeight = size.y;

    ground = Ground(screenWidth, screenHeight);
    add(ground);

    livesDisplay = LivesDisplay(screenWidth);
    add(livesDisplay);

    player = Player(screenWidth, screenHeight, this, projectilePool);
    add(player);

    enemyGrid = EnemyGrid(screenWidth, this);
    add(enemyGrid);

    gameBloc.add(StartGame());

    if (musicStarted) {
      FlameAudio.bgm.play('space-invaders-classic-arcade-game-116826.mp3');
    }
  }

  void clearGameObjects() {
    projectiles.clear();
    enemyProjectiles.clear();

    for (var child in children) {
      remove(child);
    }
  }
}
