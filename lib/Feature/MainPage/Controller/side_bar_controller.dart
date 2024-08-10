import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';

class SideBarController {
  List<Color> constantColors = [
    const Color(0xFF1e1e1e),
    const Color(0xFFE03131),
    const Color(0xFF2f93ff),
    const Color(0xFFf08c00),
  ];
  List<Color> backGroundConstantColors = [
    Colors.transparent,
    const Color(0xFFE03131),
    const Color(0xFF2f93ff),
    const Color(0xFFf08c00),
  ];
  
  Color strokeColor;
  Color backgroundColor;
  double strokeWidth;
  StrokeStyle strokeStyle;
  FontStyle fontStyle;
  FontSize fontSize;
  TextAlignment alignment;
  double opacity;
  SideBarController({
    this.fontSize = FontSize.m,
    this.fontStyle = FontStyle.commicShans,
    this.alignment = TextAlignment.center,
    this.backgroundColor = Colors.transparent,
    this.strokeColor = Colors.black,
    this.strokeWidth = 4.0,
    this.strokeStyle = StrokeStyle.solid,
    this.opacity = 1,
  });
}
