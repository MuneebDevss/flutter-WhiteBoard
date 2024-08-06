import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:white_board/Core/Enitity/ShapeModels/brush.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selection_container.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';
import '../../../Core/Enitity/shape.dart';

class MainPageController {
  //Properties
  List<Shapes> shapes = [];
  int selectedShape = -1;
  late Offset clickedPositioned;
  SystemMouseCursor cursor = SystemMouseCursors.click;
  int selectedContainerIndex = -1;
  final List<SelectedContainer> selectedContainer = [
    SelectedContainer(
      button: const Icon(Icons.square_outlined),
    ),
    SelectedContainer(
      button: const Icon(Icons.circle_outlined),
    ),
    SelectedContainer(
      button: const Icon(Icons.arrow_forward),
    ),
    SelectedContainer(
      button: const Icon(Icons.pan_tool_alt_outlined),
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

  //Behaviors
  void manageTap(int index) {
    if (selectedContainerIndex == 6) //Eraser is selected
    {
      if (selectedShape == index) {
        shapes.removeAt(selectedShape);
        if (shapes.isEmpty) {
          shapes = [];
          selectedShape = -1;
        }
      } else if (selectedShape != index) //already not selected
      {
        selectedShape = index;
      } else {
        index = -1;
      }
    } else if (selectedShape != index) //already not selected
    {
      selectedShape = index;
    } else {
      index = -1;
    }
  }

  void storePointerDownPosition(
      PointerDownEvent offsets, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final details = box.globalToLocal(offsets.position);
    //if not drawing any shape
    if (selectedContainerIndex == -1 || selectedContainerIndex == 3) {
      //tapped on a shape
      if (selectedContainerIndex == 3) {
        clickedPositioned = details;
        for (int x = 0; x < shapes.length; x++) {
          if (shapes[x] is Line) {
            Shapes line = shapes[x];
            if (((((line.lT + line.rB) / 2).dx - 10) <= details.dx &&
                    (((line.lT + line.rB) / 2).dx + 10) >= details.dx) &&
                ((((line.lT + line.rB) / 2).dy - 10) <= details.dy - 100 &&
                    (((line.lT + line.rB) / 2).dy + 10) >= details.dy - 100)) {
              selectedShape = x;
            }
          }
        }
      }
    } else if (selectedContainerIndex == 0) {
      Shapes shape = Rectangle();

      shape.lT = Offset(details.dx, details.dy - 100);
      shape.rB = Offset(details.dx, details.dy - 100);
      shapes.add(shape);
    } else if (selectedContainerIndex == 1) {
      Shapes shape = Circle();
      shape.borderRadius = 50;

      shape.lT = Offset(details.dx, details.dy - 100);
      shape.rB = Offset(details.dx, details.dy - 100);

      shapes.add(shape);
    } else if (selectedContainerIndex == 2) {
      Shapes shape = Line();

      shape.lT = Offset(details.dx, details.dy - 100);
      shapes.add(shape);
    } else if (selectedContainerIndex == 4) {
      Shapes shape = Rectangle();

      shape.child = const MyTextfield(
        style: TextStyle(fontSize: 12, color: Colors.black),
        fontSize: 12,
      );
      shape.lT = Offset(details.dx, details.dy - 100);
      shape.rB = Offset(details.dx + 100, details.dy);
      shapes.add(shape);
    } else if (selectedContainerIndex == 5) {
      Shapes shape = Brush(points: [Offset(details.dx, details.dy - 100)]);
      shapes.add(shape);
    }
  }

  void storePointerUpdatePosition(PointerMoveEvent details) {
    Offset position = details.localPosition;
    if (selectedContainerIndex == -1) {
      Shapes shape = shapes[selectedShape];
      //handling shape size and drag and drop
      handleShapeSizing(shape, position);
    }
    // handling shape making
    else if (selectedContainerIndex == 0) {
      makeRectangle(position);
    } else if (selectedContainerIndex == 1) {
      makeCircle(position);
    } else if (selectedContainerIndex == 2) {
      makeLine(position);
    } else if (selectedContainerIndex == 3) {
      grab(Offset(position.dx, position.dy + 100));
    } else if (selectedContainerIndex == 5) {
      paint(position);
    } else if (selectedContainerIndex == 6) {
      eraseBrush(position);
    }
  }

  void makeRectangle(Offset details) {
    int length = shapes.length - 1;
    shapes[length].rB = details;
    // if (dx > shapes[length].position.dx) {
    //   shapes[length].right = dx - shapes[length].position.dx;
    // } else {
    //   shapes[length].right = -1 * (dx - shapes[length].position.dx);
    // }
    // if (dy > shapes[length].position.dy + shapes[length].bottom) {
    //   shapes[length].bottom = (dy / 2 - shapes[length].position.dy) > 0
    //       ? dy / 2 - shapes[length].position.dy
    //       : dy - shapes[length].position.dy;
    // } else {
    //   shapes[length].bottom = -1 * (dy / 2 - shapes[length].position.dy) > 0
    //       ? -1 * (dy / 2 - shapes[length].position.dy)
    //       : -1 * (dy - shapes[length].position.dy);
    // }
  }

  void handleShapeSizing(Shapes shape, Offset position) {
    //tapped on bottom right
    if (shape.lT.dx + shape.rB.dx == position.dx &&
        shape.lT.dy + shape.rB.dy == position.dy) {
      //TODO
    }
    //tapped on bottom left
    else if (shape.lT.dx == position.dx &&
        shape.lT.dy + shape.rB.dy == position.dy) {
      //TODO
    }
    //tapped on top left
    else if (shape.lT.dx == position.dx && shape.lT.dy == position.dy) {
      //TODO
    }
    //tapped on top right
    else if (shape.lT.dx + shape.rB.dx == position.dx &&
        shape.lT.dy == position.dy) {
      //TODO
    }
  }

  void makeCircle(Offset details) {
    int length = shapes.length - 1;
    shapes[length].rB = details;
  }

  void makeLine(Offset details) {
    int length = shapes.length - 1;
    Offset pos = details;
    shapes[length].rB = Offset(pos.dx, pos.dy);
  }

  void grab(Offset position) {
    if (selectedShape != -1) {
      Offset lt = shapes[selectedShape].lT;
      Offset rB = shapes[selectedShape].rB;
      Offset delta = position - clickedPositioned;
      shapes[selectedShape].lT = lt + delta;
      shapes[selectedShape].rB = rB + delta;
      clickedPositioned = position;
    }
  }

  void paint(Offset position) {
    int length = shapes.length - 1;
    final Shapes shape = shapes[length];
    if (shape is Brush) {
      shape.points.add(position);
    }
    shapes[length] = shape;
  }

  void eraseBrush(Offset position) {
    
          
    for (int index = 0; index < shapes.length; index++) {
      final Shapes shape = shapes[index];
      if (shape is Brush) {
        print('${shape.points}\n');
        print('$position\n');
        if (shape.points.contains(position)) {
          int ind = shape.points.indexOf(position);
          // shapes.removeAt(ind);
        }
      }
    }
  }
}
