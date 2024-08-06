import 'package:flutter/material.dart';

class SelectedContainer {
  final Icon button;
  Offset tapPositon;
  double width, height;
  SelectedContainer({required this.button,this.tapPositon=const Offset(0, 0),  this.height=0,  this.width=0});
}