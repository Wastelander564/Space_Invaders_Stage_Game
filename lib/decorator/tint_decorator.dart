import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TintDecoratorComponent extends PositionComponent {
  final SpriteComponent _child;
  final Color _tintColor;

  TintDecoratorComponent({
    required SpriteComponent child,
    Color tintColor = const Color.fromARGB(255, 0, 30, 255),
  })  : _child = child,
        _tintColor = tintColor;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paintWithTint = Paint()
      ..colorFilter = ColorFilter.mode(_tintColor, BlendMode.srcATop);

    if (_child.sprite case final sprite?) {
      sprite.render(
        canvas,
        position: Vector2.zero(),
        size: _child.size,
        overridePaint: paintWithTint,
      );
    }
  }
}
