import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Circle extends Shapes {
  Color backgroundColor;
  double borderRadius;
  Widget? child;
  Circle(
      {super.rotationAngle,
      this.child,
      super.stroke,
      this.borderRadius = 50,
      super.strokeWidth = 4,
      super.opacity,
      super.strokeStyle,
      super.lT,
      this.backgroundColor = Colors.transparent,
      super.scale,
      super.rB,
      required super.id, required super.node});
      Circle copyWith({
    Color? backgroundColor,
    double? borderRadius,
    Widget? child,
    double? strokeWidth,
    Color? stroke,
    double? opacity,
    StrokeStyle? strokeStyle,
    Offset? lT,
    Offset? rB,
    int? id,
    double? rotationAngle,
    FocusNode? node,
  }) {
    return Circle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      child: child ?? this.child,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      stroke: stroke ?? this.stroke,
      opacity: opacity ?? this.opacity,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      lT: lT ?? this.lT,
      rB: rB ?? this.rB,
      id: id ?? this.id,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      node: node ?? this.node,
    );
  }
}
