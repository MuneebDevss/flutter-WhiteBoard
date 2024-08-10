import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';

class Shapes {
  final int id;
  Color stroke;
  double strokeWidth;
  StrokeStyle strokeStyle;
  double opacity;
  Offset lT;
  Offset rB;
  Shapes( {
    required this.id,
    this.stroke = Colors.black,
    this.strokeStyle = StrokeStyle.solid,
    this.strokeWidth = 2,
    this.opacity = 1,
    this.lT = const Offset(10.0, 10.0),
    this.rB = const Offset(10.0, 10.0),
  });
}
