import 'dart:collection';

import 'package:my_game/projectile.dart';

class ObjectPool<T> {
  final Queue<T> _pool = Queue<T>();
  final int _maxSize;
  final T Function() _creator;

  ObjectPool(this._maxSize, this._creator);

  // Get an object from the pool, or create one if the pool is empty
  T get() {
    if (_pool.isEmpty) {
      return _creator();
    } else {
      return _pool.removeFirst();
    }
  }

  // Return an object to the pool
  void returnToPool(T object) {
    if (_pool.length < _maxSize) {
      _pool.add(object);
    }
  }

  // Convert the pool to a List
  List<T> toList() {
    return List<T>.from(_pool); // Converts the queue to a list
  }

  void returnProjectile(Projectile projectile) {}
}
