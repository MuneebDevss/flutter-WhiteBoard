import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Feature/MainPage/Entities/selection_container.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';
import '../../../Core/Enitity/shape.dart';

class MainPageController {
  List<Shapes> shapes = [];

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

  void storeTap(int index) {
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

  void storeTapDownPosition(TapDownDetails details) {
    //if not drawing any shape
    if (selectedContainerIndex == -1 || selectedContainerIndex == 6) {
      //tapped on a shape
    } else if (selectedContainerIndex == 0) {
      Shapes shape = Rectangle();
      shape.width = 50;
      shape.height = 50;
      shape.backgroundColor = Colors.black;
      shape.position =
          Offset(details.globalPosition.dx, details.globalPosition.dy - 200);
      shapes.add(shape);
    } else if (selectedContainerIndex == 1) {
      Shapes shape = Circle();
      shape.width = 50;
      shape.height = 50;
      shape.borderRadius = 50;
      shape.backgroundColor = Colors.black;
      shape.position =
          Offset(details.globalPosition.dx, details.globalPosition.dy - 200);
      shapes.add(shape);
    } else if (selectedContainerIndex == 2) {
      Shapes shape = Line();

      shape.backgroundColor = Colors.black;
      shape.position = Offset(
          details.globalPosition.dx - 90, details.globalPosition.dy - 270);
      shapes.add(shape);
    } else if (selectedContainerIndex == 4) {
      try {
        Shapes shape = Rectangle();
        shape.width = 100;
        shape.height = 50;
        shape.backgroundColor = Colors.black;
        shape.child = const MyTextfield(
          style: TextStyle(fontSize: 12),
          fontSize: 12,
        );
        shape.position =
            Offset(details.globalPosition.dx, details.globalPosition.dy - 200);
      } catch (e) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void storePointerDownPosition(
      PointerDownEvent offsets, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final details = box.globalToLocal(offsets.position);
    print("${offsets.localPosition}tap");
    //if not drawing any shape
    if (selectedContainerIndex == -1 || selectedContainerIndex == 6) {
      //tapped on a shape
    } else if (selectedContainerIndex == 0) {
      Shapes shape = Rectangle();
      shape.width = 50;
      shape.height = 50;
      shape.backgroundColor = Colors.black;
      shape.position = Offset(details.dx, details.dy-100);
      shapes.add(shape);
    } else if (selectedContainerIndex == 1) {
      Shapes shape = Circle();
      shape.width = 50;
      shape.height = 50;
      shape.borderRadius = 50;
      shape.backgroundColor = Colors.black;
      shape.position = Offset(details.dx, details.dy - 200);
      shapes.add(shape);
    } else if (selectedContainerIndex == 2) {
      Shapes shape = Line();

      shape.position = Offset(details.dx - 90, details.dy - 270);
      shapes.add(shape);
    } else if (selectedContainerIndex == 4) {
      try {
        Shapes shape = Rectangle();
        shape.width = 100;
        shape.height = 50;
        shape.backgroundColor = Colors.black;
        shape.child = const MyTextfield(
          style: TextStyle(fontSize: 12),
          fontSize: 12,
        );
        shape.position = Offset(details.dx, details.dy - 200);
      } catch (e) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    
  }

  void storePanUpdatePosition(DragUpdateDetails details) {
    Offset position = details.globalPosition;
    if (selectedContainerIndex == -1) {
      Shapes shape = shapes[selectedShape];
      //handling shape size and drag and drop
      handleShapeSizing(shape, position);
    }
    // handling shape making
    else if (selectedContainerIndex == 0) {
      makeRectangle(details);
    } else if (selectedContainerIndex == 1) {
      makeCircle(details);
    } else if (selectedContainerIndex == 2) {
      makeLine(details);
    } else if (selectedContainerIndex == 5) {
      try {
        Shapes shape = Circle();
        shape.width = 10;
        shape.height = 10;
        shape.borderRadius = 20;
        shape.backgroundColor = Colors.black;
        shape.position =
            Offset(details.globalPosition.dx, details.globalPosition.dy - 200);
        shapes.add(shape);
      } catch (e) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void makeRectangle(DragUpdateDetails details) {
    int length = shapes.length - 1;

    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    if (dx - shapes[length].position.dx > 0) {
      shapes[length].width = dx - shapes[length].position.dx;
    } else {
      shapes[length].width = -1 * (dx - shapes[length].position.dx);
    }
    if (dy - shapes[length].position.dy + shapes[length].height > 0) {
      shapes[length].height = (dy / 2 - shapes[length].position.dy) > 0
          ? dy / 2 - shapes[length].position.dy
          : dy - shapes[length].position.dy;
    } else {
      shapes[length].height = -1 * (dy / 2 - shapes[length].position.dy) > 0
          ? -1 * (dy / 2 - shapes[length].position.dy)
          : -1 * (dy - shapes[length].position.dy);
    }
  }

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

  void makeCircle(DragUpdateDetails details) {
    int length = shapes.length - 1;

    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    if (dx - shapes[length].position.dx > 0) {
      shapes[length].width = dx - shapes[length].position.dx;
    } else {
      shapes[length].width = -1 * (dx - shapes[length].position.dx);
    }
    if (dy - shapes[length].position.dy + shapes[length].height > 0) {
      shapes[length].height = (dy / 2 - shapes[length].position.dy) > 0
          ? dy / 2 - shapes[length].position.dy
          : dy - shapes[length].position.dy;
      shapes[length].borderRadius = dy / 2;
    } else {
      shapes[length].height = -1 * (dy / 2 - shapes[length].position.dy) > 0
          ? -1 * (dy / 2 - shapes[length].position.dy)
          : -1 * (dy - shapes[length].position.dy);
      shapes[length].borderRadius = -1 * dy / 2;
    }
  }

  void makeLine(DragUpdateDetails details) {
    int length = shapes.length - 1;
    Offset pos = details.globalPosition;
    shapes[length].mirrorPosition = Offset(pos.dx - 170, pos.dy - 350);
  }
}
