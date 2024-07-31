  

import 'package:flutter/material.dart';

class Shapes {
  double mirrorX;
  double mirrorY;
  double height;
  double width;
  double stroke;
  Color? backgroundColor;
  double? borderRadius;
  Widget? child;
  Offset position;
  Shapes({
    this.mirrorX=0,
    this.mirrorY=0,
    this.height = 12,
    this.width = 15,
    this.stroke = 5,
    this.position = const Offset(10.0, 10.0),
    String? backgroundColor,
    double? borderRadius,
    Widget? child,
  });
}
