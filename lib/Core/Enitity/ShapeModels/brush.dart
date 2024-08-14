import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Brush extends Shapes {
  final List<Offset> points;
  Brush(
      {required this.points,
      super.strokeWidth = 4,
      super.stroke,
      super.opacity,
      super.strokeStyle,
      required super.id});
       Brush copyWith({
    List<Offset>? points,
    double? strokeWidth,
    Color? stroke,
    double? opacity,
    StrokeStyle? strokeStyle,
    int? id,
  }) {
    return Brush(
      points: points ?? this.points,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      stroke: stroke ?? this.stroke,
      opacity: opacity ?? this.opacity,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      id: id ?? this.id,
    );
  }
}
