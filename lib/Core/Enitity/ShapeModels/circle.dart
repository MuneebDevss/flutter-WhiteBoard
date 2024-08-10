import 'package:flutter/material.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Circle extends Shapes {
  Color backgroundColor;
  double borderRadius;
  Widget? child;
  Circle(
      {super.stroke,
      this.borderRadius = 50,
      super.strokeWidth = 4,
      super.opacity,
      super.strokeStyle,
      super.lT,
      this.backgroundColor = Colors.transparent,
      super.rB, required super.id});
}
