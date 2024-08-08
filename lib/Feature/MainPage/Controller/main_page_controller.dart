import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/ShapeModels/brush.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selection_container.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';
import '../../../Core/Enitity/shape.dart';

class MainPageController {
  //Properties
  bool first = false;
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
    SelectedContainer(
      button: const Icon(Icons.delete_forever),
    ),
  ];

  //Behaviors
  void manageTap(int index, Offset details) {
    if (selectedContainerIndex == 8) //Eraser is selected
    {
      if (selectedShape == index) {
        shapes.removeAt(selectedShape);
        if (shapes.isEmpty) {
          shapes = [];
        }
        selectedShape = -1;
      } else if (selectedShape != index) //already not selected
      {
        selectedShape = index;
      }
    } else if (selectedShape != index &&
        (selectedContainerIndex == -1 ||
            selectedContainerIndex == 3)) //already not selected
    {
      selectedShape = index;
    } else if (selectedShape == index &&
        (selectedContainerIndex == -1 || selectedContainerIndex == 3)) {
      selectedShape = -1;
    }
  }

  void storePointerDownPosition(PointerDownEvent offsets, BuildContext context,
      SideBarController controller) {
    final box = context.findRenderObject() as RenderBox;
    final details = box.globalToLocal(offsets.position);
    //if not drawing any shape (deleting or grabing the shape)
    if (selectedContainerIndex == 8 ||
        selectedContainerIndex == 3 ||
        selectedContainerIndex == -1) {
      //tapped on a line

      // tapp position for the grab
      clickedPositioned = details;
      for (int x = 0; x < shapes.length; x++) {
        if (shapes[x] is Line) {
          Shapes line = shapes[x];
          double dx = ((line.lT + line.rB) / 2).dx;
          double dy = ((line.lT + line.rB) / 2).dy;
          if ((dx - 10 <= details.dx && dx + 10 >= details.dx) &&
              (dy - 10 <= details.dy - 100 && dy + 10 >= details.dy - 100)) {
            if (selectedContainerIndex == 8 && selectedShape == x) {
              shapes.removeAt(selectedShape);
            } else if (selectedShape == x) {
              selectedShape = -1;
            } else if (selectedShape != x) {
              selectedShape = x;
            }
          }
        }
      }
    } else if (selectedContainerIndex == 0) {
      Shapes shape = Rectangle(
        lT: Offset(details.dx, details.dy - 100),
        rB: Offset(details.dx, details.dy - 100),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
      );
      shapes.add(shape);
    } else if (selectedContainerIndex == 1) {
      Shapes shape = Circle(
        lT: Offset(details.dx, details.dy - 100),
        rB: Offset(details.dx, details.dy - 100),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
      );
      shapes.add(shape);
    } else if (selectedContainerIndex == 2) {
      Shapes shape = Line(
        lT: Offset(details.dx, details.dy - 100),
        rB: Offset(details.dx, details.dy - 100),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
      );
      shapes.add(shape);
    } else if (selectedContainerIndex == 4) {
      Shapes shape = Rectangle(
          lT: Offset(details.dx, details.dy - 100),
          rB: Offset(details.dx + 50, details.dy - 50),
          stroke: Colors.transparent,
          strokeStyle: StrokeStyle.dashedBorder,
          child: const MyTextfield(
            style: TextStyle(fontSize: 12, color: Colors.black),
            fontSize: 12,
          ));

      shapes.add(shape);
    } else if (selectedContainerIndex == 5) {
      Shapes shape = Brush(
        points: [Offset(details.dx, details.dy - 100)],
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
      );
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
    //end point of the length
    shapes[length].rB = Offset(pos.dx, pos.dy);
  }

  void grab(Offset position) {
    if (selectedShape != -1) {
      Offset lt = shapes[selectedShape].lT;
      Offset rB = shapes[selectedShape].rB;
      //new position of cursor relative to the previos/Clicked position
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
      List<Offset> temp = [];
      if (shape is Brush) {
        //Look for all the points in the brush area
        for (Offset point in shape.points) {
          if (((point.dx - 10) <= position.dx &&
                  (point.dx + 10) >= position.dx) &&
              ((point.dy - 10) <= position.dy &&
                  (point.dy + 10) >= position.dy)) {
            temp.add(point);
          }
          // remove all those points
          for (Offset point in temp) {
            shape.points.remove(point);
          }
        }
        //Remove the brush sketch if it has not point
        if (shape.points.isEmpty) {
          shapes.removeAt(index);
        }
      }
    }
  }
}
