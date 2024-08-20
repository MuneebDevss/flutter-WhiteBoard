import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';

class MyStack {
  final int id;
  final FocusNode? node;
  final double? rotationAngle;
  final Color? stroke;
  final ShapeTypes shape;
  final double? strokeWidth;
  final List<Offset>? points;
  final StrokeStyle? strokeStyle;
  final double? opacity;
  final Offset? lT;
  final Offset? rB;
  final Color? backgroundColor;
  final double? borderRadius;
  final Widget? child;
  double? fontSize;
  String? fontFamily;
  Color ?textColor;
  TextAlignment? alignment;

  // Constructor
  MyStack( {
    this.fontFamily,
    this.fontSize,
    this.alignment,
    this.textColor,
    
    required this.shape,
    this.node,
    this.rotationAngle,
    required this.id,
    this.points,
    this.stroke,
    this.strokeWidth,
    this.strokeStyle,
    this.opacity,
    this.lT,
    this.rB,
    this.backgroundColor,
    this.borderRadius,
    this.child,
  });
}
