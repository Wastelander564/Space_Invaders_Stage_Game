import 'player_states.dart';
import 'package:my_game/components/player/player.dart';
import 'moving_state.dart';

class IdleState extends PlayerState {
  @override
  void update(Player player, double dt) {
    // No movement
  }

  @override
  void moveLeft(Player player) {
    player.velocity = -Player.speed;
    player.setState(MovingLeftState());
  }

  @override
  void moveRight(Player player) {
    player.velocity = Player.speed;
    player.setState(MovingRightState());
  }

  @override
  void stop(Player player) {
    // Already idle
  }
}
