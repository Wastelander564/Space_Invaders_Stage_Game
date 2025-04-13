import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:my_game/space_invader_game.dart';
import 'package:my_game/states/player_states.dart';
import 'package:my_game/states/idle_state.dart';
import 'package:my_game/logic/projectile_pool.dart';

class Player extends SpriteAnimationComponent with HasGameRef<SpaceInvadersGame> {
  static const double speed = 200;
  double velocity = 0;
  late PlayerState _state;
  final ProjectilePool projectilePool; // Reference to the pool

  Player(double screenWidth, double screenHeight, SpaceInvadersGame game, this.projectilePool) {
    size = Vector2(48, 16);
    position = Vector2(screenWidth / 2 - size.x / 2, screenHeight - 100);
    _state = IdleState();
  }

  void setState(PlayerState newState) {
    _state = newState;
    _state.enter(this);
  }

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'DGS-Tank.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: 0.2,
        textureSize: Vector2(16, 16),
      ),
    );
  }

  void moveLeft() => _state.moveLeft(this);
  void moveRight() => _state.moveRight(this);
  void stopMoving() => _state.stop(this);

  void shoot() {
    final projectile = projectilePool.getProjectile(position.x + size.x / 2, position.y - 10);  // Get projectile from pool
    gameRef.add(projectile);  // Add projectile to the game
    _applyScaleEffect();
  }

  void _applyScaleEffect() {
    add(ScaleEffect.to(
      Vector2(2, 2),
      EffectController(duration: 0.4),
      onComplete: () {
        add(ScaleEffect.to(
          Vector2(1.0, 1.0),
          EffectController(duration: 0.4),
        ));
      },
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _state.update(this, dt);
    
    // Edge teleportation
    if (position.x < 0) {
      position.x = gameRef.size.x - size.x;  // Teleport to the right edge
    } else if (position.x + size.x > gameRef.size.x) {
      position.x = 0;  // Teleport to the left edge
    }
    
    position.x = position.x.clamp(0, gameRef.size.x - size.x);  // Ensure player stays within screen horizontally
  }

  Rect get collisionBox =>
      Rect.fromLTWH(position.x, position.y, size.x, size.y);
}
