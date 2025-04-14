import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent {
  Ground(double screenWidth, double screenHeight) {
    size = Vector2(screenWidth, 15);
    position = Vector2(0, screenHeight - size.y);
  }

  @override
  Future<void> render(Canvas canvas) async {
    final paint = Paint()..color = Colors.white;
    canvas.drawRect(size.toRect(), paint);
  }
}