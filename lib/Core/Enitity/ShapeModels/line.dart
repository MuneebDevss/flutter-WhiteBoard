
import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Line extends Shapes {
  Offset? curve;
  Line({
    super.strokeWidth = 4,
    super.stroke,
    super.opacity,
    super.strokeStyle,
    super.lT,
    super.rB,
    required super.id,
    super.rotationAngle, required super.node,
    this.curve
  });
  Line copyWith({
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
    return Line(
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
