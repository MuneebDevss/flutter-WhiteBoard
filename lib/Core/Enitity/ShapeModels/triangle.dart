import 'package:flutter/material.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Triangle extends Shapes {
  Color backgroundColor;
  Widget? child;
  Triangle({
    super.strokeWidth = 4,
    super.stroke,
    super.opacity,
    super.strokeStyle,
    this.backgroundColor = Colors.transparent,
    this.child,
    super.lT, required super.id,
  });
}
