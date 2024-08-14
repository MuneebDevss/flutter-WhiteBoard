import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Triangle extends Shapes {
  Color backgroundColor;
  Widget? child;
  Triangle({
    super.strokeWidth = 4,
    super.stroke,
    super.opacity,
    super.strokeStyle,
    this.backgroundColor = Colors.transparent,
    this.child,
    super.lT,
    required super.id,
    super.rotationAngle, required super.node,
  });
    Triangle copyWith({
    Color? backgroundColor,
    Widget? child,
    double? strokeWidth,
    Color? stroke,
    double? opacity,
    StrokeStyle? strokeStyle,
    Offset? lT,
    int? id,
    double? rotationAngle,
    FocusNode? node,
  }) {
    return Triangle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      child: child ?? this.child,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      stroke: stroke ?? this.stroke,
      opacity: opacity ?? this.opacity,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      lT: lT ?? this.lT,
      id: id ?? this.id,
      rotationAngle: rotationAngle ?? this.rotationAngle,
      node: node ?? this.node,
    );
  }
}
