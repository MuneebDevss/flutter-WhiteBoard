import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class TextFieldRect extends Shapes {
  Widget? child;
  TextEditingController controller = TextEditingController();
  TextFieldRect(
      {super.strokeWidth = 4,
      super.stroke,
      super.opacity,
      super.strokeStyle,
      this.child,
      super.lT,
      super.scale,
      super.rB,
      required super.id,
      super.rotationAngle,
      required super.node});
  TextFieldRect copyWith({
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
    return TextFieldRect(
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
