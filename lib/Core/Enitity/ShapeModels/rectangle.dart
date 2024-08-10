import 'package:flutter/material.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Rectangle extends Shapes {
  Color backgroundColor;
  double borderRadius;
  Widget? child;
  Rectangle(
      {
        super.strokeWidth = 4,
      super.stroke,
      super.opacity,
      super.strokeStyle,
      this.backgroundColor = Colors.transparent,
      this.borderRadius = 0,
      this.child,
      super.lT,
      super.rB,
      required super.id});
}
