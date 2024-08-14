import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Rectangle extends Shapes {
  Color backgroundColor;
  double borderRadius;
  Widget? child;
  Rectangle({
    super.strokeWidth = 4,
    super.stroke,
    super.opacity,
    super.strokeStyle,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 0,
    this.child,
    super.lT,
    super.rB,
    required super.id,
    super.rotationAngle, required super.node,
  });
  Rectangle copyWith({
    Color? backgroundColor,
    Widget? child,
    double? strokeWidth,
    double? borderRadius,
    Color? stroke,
    double? opacity,
    StrokeStyle? strokeStyle,
    Offset? lT,
    Offset? rB,
    int? id,
    double? rotationAngle,
    FocusNode? node,
  }) {
    return Rectangle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      child: child ?? this.child,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      stroke: stroke ?? this.stroke,
      opacity: opacity ?? this.opacity,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      lT: lT ?? this.lT,
      rB: rB?? this.rB,
      id: id ?? this.id,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      node: node ?? this.node,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
