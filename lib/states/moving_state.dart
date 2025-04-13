import 'player_states.dart';
import 'package:my_game/components/player/player.dart';
import 'idle_state.dart';

class MovingLeftState extends PlayerState {
  @override
  void update(Player player, double dt) {
    player.position.x += player.velocity * dt;
  }

  @override
  void moveLeft(Player player) {
    // Already moving left
  }

  @override
  void moveRight(Player player) {
    player.velocity = Player.speed;
    player.setState(MovingRightState());
  }

  @override
  void stop(Player player) {
    player.velocity = 0;
    player.setState(IdleState());
  }
}

class MovingRightState extends PlayerState {
  @override
  void update(Player player, double dt) {
    player.position.x += player.velocity * dt;
  }

  @override
  void moveLeft(Player player) {
    player.velocity = -Player.speed;
    player.setState(MovingLeftState());
  }

  @override
  void moveRight(Player player) {
    // Already moving right
  }

  @override
  void stop(Player player) {
    player.velocity = 0;
    player.setState(IdleState());
  }
}
