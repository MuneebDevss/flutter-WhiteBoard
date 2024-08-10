import 'package:flutter/material.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class TextFieldRect extends Shapes {
  
  Widget? child;
  
  TextFieldRect(
      {super.strokeWidth = 4,
      super.stroke,
      super.opacity,
      super.strokeStyle,
      this.child,
      super.lT,
      super.rB, required super.id});
}
