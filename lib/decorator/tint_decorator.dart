import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TintDecoratorComponent extends PositionComponent {
  final Component child;
  final Color tintColor;

  TintDecoratorComponent({
    required this.child,
    this.tintColor = const Color.fromARGB(170, 255, 162, 0),
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(child); // Add the wrapped component as a child
  }

  @override
  void render(Canvas canvas) {
    // Use a layer with a color filter to apply the tint
    canvas.saveLayer(
      null,
      Paint()
        ..colorFilter = ColorFilter.mode(tintColor, BlendMode.srcATop),
    );

    super.render(canvas); // Render children (including the wrapped component)

    canvas.restore();
  }
}
