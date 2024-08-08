import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';

class Shapes {
  Color stroke;
  double strokeWidth;
  StrokeStyle strokeStyle;
  double opacity;
  Color? backgroundColor;
  double? borderRadius;
  Widget? child;
  Offset lT;
  Offset rB;
  Shapes({
    this.stroke = Colors.black,
    this.strokeStyle = StrokeStyle.solid,
    this.strokeWidth = 2,
    this.opacity = 1,
    this.lT = const Offset(10.0, 10.0),
    this.rB = const Offset(10.0, 10.0),
    this.backgroundColor,
    this.borderRadius,
    this.child,
  });
}
