import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:white_board/Feature/MainPage/Entities/selection_container.dart';

import '../../../Core/Enitity/shape.dart';

class MainPageController {
  final List<Shapes> shapes = [];
  int selectedContainerIndex = -1;
  int selectedShape = -1;

  final List<SelectedContainer> selectedContainer = [
    RectangularContainer(
      button: const Icon(Icons.square_outlined),
    ),
    SelectedContainer(
      button: const Icon(Icons.circle_outlined),
    ),
    SelectedContainer(
      button: const Icon(Icons.arrow_forward),
    ),
    SelectedContainer(
      button: const Icon(Iconsax.link),
    ),
    SelectedContainer(
      button: const Icon(Icons.text_format_outlined),
    ),
    SelectedContainer(
      button: const Icon(Iconsax.pen_tool),
    ),
    SelectedContainer(
      button: const Icon(Iconsax.eraser),
    ),
    SelectedContainer(
      button: const Icon(Icons.image),
    ),
  ];
  Shapes makeShape() {
    return Shapes();
  }

  void storeTapDownPosition(TapDownDetails details) {
    //if not drawing any shape
    if (selectedContainerIndex == -1 || selectedContainerIndex == 7) {
      //tapped on a shape
      for (int index = 0; index < shapes.length; index++) {
        if (shapes[index].position == details.globalPosition) {
          if (selectedContainerIndex == 7) //Eraser is selected
          {
          } else if (selectedContainerIndex != index) //already not selected
          {
            selectedContainerIndex = index;
          } else {
            index = -1;
          }
        }
      }
    } else {
      Shapes shape = Shapes();
      shape.position = details.globalPosition;
      shapes.add(shape);
    }
  }

  void storePanUpdatePosition(DragUpdateDetails details) {
    Offset position = details.globalPosition;
    if (selectedShape != -1) {
      Shapes shape = shapes[selectedShape];
      //handling shape size and drag and drop
      handleShapeSizing(shape, position);
    }
    // handling shape making
    else if (selectedContainerIndex != -1) {
      makeRectangle(details);
    }
  }

  void makeRectangle(DragUpdateDetails details) {
    int length = shapes.length;
    print(length);
    if (details.globalPosition.dx - shapes[length].position.dx > 0) {
      shapes[length].width =
          details.globalPosition.dx - shapes[length].position.dx;
    } else {
      shapes[length].width =
          shapes[length].position.dx - details.globalPosition.dx;
      shapes[length].position =
          Offset(details.globalPosition.dx, shapes[length].position.dy);
    }
    if (details.globalPosition.dy - shapes[length].position.dy > 0) {
      shapes[length].width =
          details.globalPosition.dy - shapes[length].position.dy;
    } else {
      shapes[length].width =
          shapes[length].position.dy - details.globalPosition.dy;
      shapes[length].position =
          Offset(details.globalPosition.dy, shapes[length].position.dy);
    }
  }

  void storePanCancel(DragEndDetails details) {}

  void handleShapeSizing(Shapes shape, Offset position) {
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
  }
}
