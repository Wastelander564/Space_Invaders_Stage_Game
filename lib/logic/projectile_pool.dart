// ignore: file_names

import 'package:my_game/components/player/projectile.dart';

class ProjectilePool {
  final List<Projectile> _availableProjectiles = [];
  final List<Projectile> _activeProjectiles = [];

  // Method to get a projectile from the pool
  Projectile getProjectile(double x, double y) {
    // Reuse an existing projectile if available
    if (_availableProjectiles.isNotEmpty) {
      final projectile = _availableProjectiles.removeLast();
      projectile.reset(x, y);  // Reset its position
      _activeProjectiles.add(projectile);
      return projectile;
    } else {
      // Create a new projectile if the pool is empty
      final projectile = Projectile(x, y);
      _activeProjectiles.add(projectile);
      return projectile;
    }
  }

  // Return a projectile to the pool after it's no longer needed
  void returnProjectile(Projectile projectile) {
    _activeProjectiles.remove(projectile);
    _availableProjectiles.add(projectile);
  }

  // Optional: Clear the pool if needed (e.g., when resetting the game)
  void clear() {
    _availableProjectiles.clear();
    _activeProjectiles.clear();
  }
}
