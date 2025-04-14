import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/effects.dart';

import 'package:my_game/space_invader_game.dart';


class Projectile extends SpriteComponent with HasGameRef<SpaceInvadersGame> {
  static const double speed = 300; // Speed in pixels per second
  final double startX;
  final double startY;

  Projectile(this.startX, this.startY) {
    size = Vector2(10, 20); // This can be updated based on the actual image size
    position = Vector2(startX - size.x / 2, startY - size.y);
  }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('DGS-BulletPlayer.png');
    FlameAudio.play('8-bit-laser-151672.mp3', volume: 0.20);
    _addTrailEffect();
    effectProjectile(); // Apply the color effect when the projectile is created
  }

  void _addTrailEffect() {
    // Create a trail particle effect using an AcceleratedParticle
    gameRef.add(
      ParticleSystemComponent(
        particle: AcceleratedParticle(
          position: position, // Start at the projectile's position
          speed: Vector2(0, -speed), // Direction and speed of the trail
          acceleration: Vector2.zero(), // No additional acceleration
          child: CircleParticle(
            radius: 7.0, // Size of the trail
            paint: Paint()..color = const Color.fromARGB(255, 73, 1, 255), // Trail color
          ),
        ),
      ),
    );
  }

  void effectProjectile() {
    // Apply the color effect (fade in and out with a greenish color)
    add(
      ColorEffect(
        const Color.fromARGB(255, 30, 255, 0), // Green color
        EffectController(duration: 1.5), // Duration of the effect
        opacityFrom: 0.2, // Initial opacity (faint)
        opacityTo: 0.8, // Final opacity (brighter)
      ),
    );
  }

  void reset(double x, double y) {
    position.setFrom(Vector2(x, y));
    // Reset any other necessary attributes (e.g., speed, state, etc.)
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the projectile upwards based on speed
    position.y -= speed * dt; // Decrease Y to move upwards

    // Check if the projectile is off-screen or collides with something
    if (position.y < 0) {
      gameRef.projectilePool.returnProjectile(this); // Return the projectile to the pool
      removeFromParent(); // Remove the projectile from the game
    }
  }

  Rect get collisionBox =>
      Rect.fromLTWH(position.x, position.y, size.x, size.y);
}

