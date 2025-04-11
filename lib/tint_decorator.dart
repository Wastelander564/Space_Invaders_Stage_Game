import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';


class RenderWithTint {
  final Function(Canvas) renderFunction;

  RenderWithTint(this.renderFunction);

  void call(Canvas canvas, Sprite? sprite, Vector2 position) {
    final Paint paintWithTint = Paint()
      ..colorFilter = ColorFilter.mode(
        const Color.fromARGB(170, 255, 162, 0),
        BlendMode.srcATop,
      );
    renderFunction(canvas);
    // Apply the tint to the sprite image after the original render logic
    if (sprite != null) {
      canvas.drawImage(sprite.image, position.toOffset(), paintWithTint);
    }
  }
}