import 'package:flutter/material.dart';
import 'package:white_board/Core/Enitity/shape.dart';

class Brush extends Shapes{
  final List<Offset> points;
  
  

  Brush({required this.points,super.strokeWidth=4,super.stroke,super.opacity,super.strokeStyle});
}
