import 'player.dart';

abstract class PlayerState {
  void enter(Player player) {}
  void update(Player player, double dt);
  void moveLeft(Player player);
  void moveRight(Player player);
  void stop(Player player);
}
