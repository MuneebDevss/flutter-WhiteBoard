  

import 'package:flutter/material.dart';

class Shapes {
  
  double height;
  double width;
  double stroke;
  Color? backgroundColor;
  double? borderRadius;
  Widget? child;
  Offset position;
  Offset mirrorPosition;
  Shapes({
    
    this.height=0,
    this.width=0,
    this.stroke = 5,
    this.position = const Offset(10.0, 10.0),
    this.mirrorPosition = const Offset(10.0, 10.0),
    String? backgroundColor,
    double? borderRadius,
    Widget? child,
  });
}
