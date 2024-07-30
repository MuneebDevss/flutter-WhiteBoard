import 'package:flutter/material.dart';

import '../../../Core/Enitity/shape.dart';

class MainPageController {
  final List<Shapes> shapes = [];

  void _storeTapDownPosition(TapDownDetails details, int index) {
    shapes[index].isSelected = !shapes[index].isSelected;
  }

  void _storePanUpdatePosition(DragUpdateDetails details, int index) {
    Shapes shape = shapes[index];
    Offset position = details.globalPosition;
    //if the shape is selected
    if(shape.isSelected)
    {
    
    //tapped on bottom right
    if (shape.position.dx + shape.width == position.dx &&
        shape.position.dy + shape.height == position.dy) {
      //TODO
    }
    //tapped on bottom left
    else if (shape.position.dx == position.dx &&
        shape.position.dy + shape.height == position.dy) {
      //TODO
    }
    //tapped on top left
    else if (shape.position.dx == position.dx &&
        shape.position.dy == position.dy) {
      //TODO
    }
    //tapped on top right
    else if (shape.position.dx + shape.width == position.dx &&
        shape.position.dy == position.dy) {
      //TODO
    }
  }}
}
