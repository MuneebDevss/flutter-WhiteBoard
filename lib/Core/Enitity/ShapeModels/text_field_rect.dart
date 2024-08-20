import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class TextFieldRect extends Shapes {
  Widget? child;
  TextEditingController controller = TextEditingController();
  FontSize fontSize;
  FontFamily fontFamily;
  Color textColor;
  TextAlignment alignment;
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
      required this.fontSize,
      required this.fontFamily,
      required this.textColor,
      required this.alignment,
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
    FontSize? fontSize,
    FontFamily? fontFamily,
    Color? textColor,
    TextAlignment? alignment,
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
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      textColor: textColor ?? this.textColor,
      alignment: alignment ?? this.alignment,
    );
  }
  double getFontSize() {
    if (fontSize == FontSize.s) {
      return 12;
    } else if (fontSize == FontSize.m) {
      return 14;
    } else if (fontSize == FontSize.l) {
      return 16;
    } else {
      return 18;
    }
  }

  String getFontFamily() {
    if (fontFamily == FontFamily.commicShans) {
      return 'CommicSans';
    } else if (fontFamily == FontFamily.lillitaOne) {
      return 'LilitaOne';
    } else {
      return 'Nunito';
    }
  }
}
