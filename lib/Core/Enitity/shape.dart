import 'package:flutter/material.dart';

class Shapes {
  double stroke;
  Color? backgroundColor;
  double? borderRadius;
  Widget? child;
  Offset lT;
  Offset rB;
  Shapes({
    this.stroke = 5,
    this.lT = const Offset(10.0, 10.0),
    this.rB = const Offset(10.0, 10.0),
    String? backgroundColor,
    double? borderRadius,
    Widget? child,
  });
}
