import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/ShapeModels/brush.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/text_field_rect.dart';
import 'package:white_board/Core/Enitity/my_stack.dart';
import 'package:white_board/Core/HelpingFunctions/image_picker.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selection_container.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';
import '../../../Core/Enitity/shape.dart';

class MainPageController {
  //Properties

  bool first = false;
  // double zoom = 1;
  // Offset startPosition = const Offset(0, 0);
  // Offset zoomtranslatePosition = const Offset(0, 0);
  // Offset previousZoomPositiion = const Offset(0, 0);
  late Offset clickedPositioned;
  int selectedShape = -1;
  int selectedContainerIndex = -1;
  Widget? image;
  SystemMouseCursor cursor = SystemMouseCursors.click;
  List<MyStack> stack = [];
  List<Shapes> shapes = [];
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
        addToStack(shapes[index]);
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

  // void zoomIn() {
  //   zoom += 0.1;
  // }

  // void zoomOut() {
  //   if (zoom > 1) {
  //     zoom -= 0.1;
  //   }
  // }

  void storePointerDownPosition(DragStartDetails offsets, BuildContext context,
      SideBarController controller) {
    final box = context.findRenderObject() as RenderBox;
    final details = box.globalToLocal(offsets.localPosition);
    int length = shapes.length;
    // if (zoom > 1) {
    //   previousZoomPositiion = details;
    // }
    //if not drawing any shape (deleting or grabing the shape)
    if (selectedContainerIndex == 8 ||
        selectedContainerIndex == 3 ||
        selectedContainerIndex == -1) {
      //tapped on a line

      // tap position for the grab
      clickedPositioned = details;
      for (int x = 0; x < shapes.length; x++) {
        if (shapes[x] is Line) {
          Shapes line = shapes[x];
          double dx = ((line.lT + line.rB) / 2).dx;
          double dy = ((line.lT + line.rB) / 2).dy;
          if ((dx - 10 <= details.dx && dx + 10 >= details.dx) &&
              (dy - 10 <= details.dy && dy + 10 >= details.dy)) {
            if (selectedContainerIndex == 8 && selectedShape == x) {
              shapes.removeAt(selectedShape);
              if (shapes.isEmpty) {
                shapes = [];
              }
              selectedShape = -1;
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
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
        id: length,
      );
      shapes.add(shape);
    } else if (selectedContainerIndex == 1) {
      Shapes shape = Circle(
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
        id: length,
      );
      shapes.add(shape);
    } else if (selectedContainerIndex == 2) {
      Shapes shape = Line(
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        id: length,
      );
      shapes.add(shape);
    } else if (selectedContainerIndex == 4) {
      Shapes shape = TextFieldRect(
          lT: Offset(details.dx, details.dy),
          rB: Offset(details.dx + 50, details.dy - 50),
          stroke: Colors.transparent,
          strokeStyle: StrokeStyle.dashedBorder,
          child: MyTextfield(
            style: const TextStyle(fontSize: 12, color: Colors.black),
            fontSize: 12,
            node: FocusNode(),
          ),
          id: length);

      shapes.add(shape);
    } else if (selectedContainerIndex == 5) {
      Shapes shape = Brush(
        points: [Offset(details.dx, details.dy)],
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        id: length,
      );
      shapes.add(shape);
    } else if (selectedContainerIndex == 7) {
      if (image != null) {
        Shapes shape = Rectangle(
            lT: Offset(details.dx, details.dy),
            rB: Offset(details.dx, details.dy),
            stroke: controller.strokeColor,
            strokeStyle: controller.strokeStyle,
            strokeWidth: controller.strokeWidth,
            backgroundColor: controller.backgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image,
            ),
            id: length);
        shapes.add(shape);
      }
    }

    //New Shape gets Selected By default
    if (selectedContainerIndex != 8 &&
        selectedContainerIndex != 6 &&
        selectedContainerIndex != 5 &&
        selectedContainerIndex != 3 &&
        selectedContainerIndex != -1) {
      selectedShape = shapes.length - 1;
    }
  }

  void storePointerUpdatePosition(DragUpdateDetails details) {
    Offset position = details.localPosition;

    // handling shape making
    if (selectedContainerIndex == 0 || selectedContainerIndex == 7) {
      makeRectangle(position);
    } else if (selectedContainerIndex == 1) {
      makeCircle(position);
    } else if (selectedContainerIndex == 2) {
      makeLine(position);
    } else if (selectedContainerIndex == 3) {
      grab(Offset(position.dx, position.dy)); // Shapes resizing
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

  void makeCircle(Offset details) {
    int length = shapes.length - 1;
    shapes[length].rB = details;
    if (details.dx > details.dy) {
      (shapes[length] as Circle).borderRadius = details.dx;
    } else {
      (shapes[length] as Circle).borderRadius = details.dy;
    }
  }

  void makeLine(Offset details) {
    int length = shapes.length - 1;
    Offset pos = details;
    //end point of the length
    shapes[length].rB = Offset(pos.dx, pos.dy);
  }

  void grab(Offset position) {
    if (selectedShape != -1) {
      Offset lT = shapes[selectedShape].lT;
      Offset rB = shapes[selectedShape].rB;

      if (shapes[selectedShape] is Rectangle) {
        //tapped on bottom except corners
        if (lT.dx < position.dx &&
            position.dx < rB.dx &&
            rB.dy - 10 < position.dy &&
            rB.dy + 10 > position.dy) {
          shapes[selectedShape].rB =
              Offset(shapes[selectedShape].rB.dx, position.dy);
        }
        //tapped on bottom except corners
        else if (lT.dx < position.dx &&
            position.dx < rB.dx &&
            lT.dy - 10 < position.dy &&
            lT.dy + 10 > position.dy) {
          shapes[selectedShape].lT =
              Offset(shapes[selectedShape].lT.dx, position.dy);
        }
        //tapped on right except corners
        else if (lT.dy < position.dy &&
            position.dy < rB.dy &&
            rB.dx - 10 < position.dx &&
            rB.dx + 10 > position.dx) {
          shapes[selectedShape].rB =
              Offset(position.dx, shapes[selectedShape].rB.dy);
        }
        //tapped on left except corners
        else if (lT.dy < position.dy &&
            position.dy < rB.dy &&
            lT.dx - 10 < position.dx &&
            lT.dx + 10 > position.dx) {
          shapes[selectedShape].lT =
              Offset(position.dx, shapes[selectedShape].lT.dy);
        }
        //tapped on bottom right
        else if (lT.dx + rB.dx == position.dx && rB.dy == position.dy) {
        }
        //tapped on bottom left
        else if (lT.dx == position.dx && rB.dy == position.dy) {
          shapes[selectedShape].lT = Offset(position.dx, lT.dy);
          shapes[selectedShape].rB = Offset(rB.dx, position.dy);
        }
        //tapped on top left
        else if (lT.dx == position.dx && lT.dy == position.dy) {
          //TODO
        }
        //tapped on top right
        else if (lT.dx + rB.dx == position.dx && lT.dy == position.dy) {
          //TODO
        }
        //new position of cursor relative to the previos/Clicked position
        else {
          Offset delta = position - clickedPositioned;
          shapes[selectedShape].lT = lT + delta;
          shapes[selectedShape].rB = rB + delta;
          clickedPositioned = position;
        }
      } else if (shapes[selectedShape] is Circle) {
        //tapped on bottom except corners
        if (lT.dx < position.dx &&
            position.dx < rB.dx &&
            rB.dy - 10 < position.dy &&
            rB.dy + 10 > position.dy) {
          shapes[selectedShape].rB =
              Offset(shapes[selectedShape].rB.dx, position.dy);
        }
        //tapped on bottom except corners
        else if (lT.dx < position.dx &&
            position.dx < rB.dx &&
            lT.dy - 10 < position.dy &&
            lT.dy + 10 > position.dy) {
          shapes[selectedShape].lT =
              Offset(shapes[selectedShape].lT.dx, position.dy);
        }
        //tapped on right except corners
        else if (lT.dy < position.dy &&
            position.dy < rB.dy &&
            rB.dx - 10 < position.dx &&
            rB.dx + 10 > position.dx) {
          shapes[selectedShape].rB =
              Offset(position.dx, shapes[selectedShape].rB.dy);
        }
        //tapped on left except corners
        else if (lT.dy < position.dy &&
            position.dy < rB.dy &&
            lT.dx - 10 < position.dx &&
            lT.dx + 10 > position.dx) {
          shapes[selectedShape].lT =
              Offset(position.dx, shapes[selectedShape].lT.dy);
        }
        //tapped on bottom right
        else if (lT.dx + rB.dx == position.dx && rB.dy == position.dy) {
        }
        //tapped on bottom left
        else if (lT.dx == position.dx && rB.dy == position.dy) {
          shapes[selectedShape].lT = Offset(position.dx, lT.dy);
          shapes[selectedShape].rB = Offset(rB.dx, position.dy);
        }
        //tapped on top left
        else if (lT.dx == position.dx && lT.dy == position.dy) {
          //TODO
        }
        //tapped on top right
        else if (lT.dx + rB.dx == position.dx && lT.dy == position.dy) {
          //TODO
        }
        //new position of cursor relative to the previos/Clicked position
        else {
          Offset delta = position - clickedPositioned;
          shapes[selectedShape].lT = lT + delta;
          shapes[selectedShape].rB = rB + delta;
          clickedPositioned = position;
        }
      } else if (shapes[selectedShape] is Line) {
        final Offset mid=(lT+rB)/2;
        //Clicked onstart position
        if (position.dx >= lT.dx - 10 &&
            position.dx <= lT.dx + 10 &&
            position.dy >= lT.dy - 10 &&
            position.dy <= lT.dy + 10) {
          shapes[selectedShape].lT = position;
        }
        //Clicked on end position
        else if (position.dx >= rB.dx - 10 &&
            position.dx <= rB.dx + 10 &&
            position.dy >= rB.dy - 10 &&
            position.dy <= rB.dy + 10) {
          shapes[selectedShape].rB = position;
        }
        //grabing
        else if (position.dx >= mid.dx - 10 &&
            position.dx <= mid.dx + 10 &&
            position.dy >= mid.dy - 10 &&
            position.dy <= mid.dy + 10) {
          Offset delta = position - clickedPositioned;
          shapes[selectedShape].lT = lT + delta;
          shapes[selectedShape].rB = rB + delta;
          clickedPositioned = position;
        }
      }
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
    List<int> temp = [];
    for (int index = 0; index < shapes.length; index++) {
      final Shapes shape = shapes[index];
      if (shape is Brush) {
        // Look for all the points in the brush area
        for (Offset point in shape.points) {
          if (((point.dx - 10) <= position.dx &&
                  (point.dx + 10) >= position.dx) &&
              ((point.dy - 10) <= position.dy &&
                  (point.dy + 10) >= position.dy)) {
            temp.add(index);
            break;
          }
        }
      }
    }

    for (int i = temp.length - 1; i >= 0; i--) {
      shapes.removeAt(temp[i]);
    }
    if (shapes.isEmpty) {
      shapes = [];
    }
  }

  Future<void> pickTheImage(bool isWeb) async {
    if (isWeb) {
      String? pickedImage = await pickWebImage();
      if (pickedImage != null) {
        image = Image.network(
          pickedImage,
          fit: BoxFit.cover,
        );
      }
    } else {
      File? pickedImage = await pickImage();
      if (pickedImage != null) {
        image = Image.file(pickedImage, fit: BoxFit.cover);
      }
    }
  }

  void addToStack(Shapes shape) {
    if (shape is Rectangle) {
      addRectToStack(shape);
    } else if (shape is Circle) {
      addCircleToStack(shape);
    } else if (shape is TextFieldRect) {
      addTextFieldToStack(shape);
    } else if (shape is Line) {
      addLineToStack(shape);
    }
  }

  void addLineToStack(Line shape) {
    return stack.add(MyStack(
      id: shape.id,
      lT: shape.lT,
      rB: shape.rB,
      opacity: shape.opacity,
      stroke: shape.stroke,
      strokeStyle: shape.strokeStyle,
      strokeWidth: shape.strokeWidth,
    ));
  }

  void addTextFieldToStack(TextFieldRect shape) {
    return stack.add(MyStack(
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        opacity: shape.opacity,
        stroke: shape.stroke,
        strokeStyle: shape.strokeStyle,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void addRectToStack(Rectangle shape) {
    return stack.add(MyStack(
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        borderRadius: shape.borderRadius,
        opacity: shape.opacity,
        stroke: shape.stroke,
        strokeStyle: shape.strokeStyle,
        backgroundColor: shape.backgroundColor,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void addCircleToStack(Circle shape) {
    return stack.add(MyStack(
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        borderRadius: shape.borderRadius,
        opacity: shape.opacity,
        stroke: shape.stroke,
        strokeStyle: shape.strokeStyle,
        backgroundColor: shape.backgroundColor,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void setMouseHover(PointerHoverEvent event) {
    Offset position = Offset(event.position.dx, event.position.dy - 100);
    if (selectedShape != -1) {
      Offset lT = shapes[selectedShape].lT;
      Offset rB = shapes[selectedShape].rB;
      //tapped on bottom except corners
      if (lT.dx < position.dx &&
          position.dx < rB.dx &&
          rB.dy - 10 < position.dy &&
          rB.dy + 10 > position.dy) {
        cursor = SystemMouseCursors.resizeUpDown;
      }
      //tapped on top except corners
      else if (lT.dx < position.dx &&
          position.dx < rB.dx &&
          lT.dy - 10 < position.dy &&
          lT.dy + 10 > position.dy) {
        cursor = SystemMouseCursors.resizeUpDown;
      }
      //tapped on right except corners
      else if (lT.dy < position.dy &&
          position.dy < rB.dy &&
          rB.dx - 10 < position.dx &&
          rB.dx + 10 > position.dx) {
        cursor = SystemMouseCursors.resizeLeftRight;
      }
      //tapped on left except corners
      else if (lT.dy < position.dy &&
          position.dy < rB.dy &&
          lT.dx - 10 < position.dx &&
          lT.dx + 10 > position.dx) {
        cursor = SystemMouseCursors.resizeLeftRight;
      }
      //tapped on bottom right
      else if (lT.dx + rB.dx == position.dx && rB.dy == position.dy) {
      }
      //tapped on bottom left
      else if (lT.dx == position.dx && rB.dy == position.dy) {
        cursor = SystemMouseCursors.resizeDownLeft;
      }
      //tapped on top left
      else if (lT.dx == position.dx && lT.dy == position.dy) {
        //TODO
      }
      //tapped on top right
      else if (lT.dx + rB.dx == position.dx && lT.dy == position.dy) {
        //TODO
      }
      //new position of cursor relative to the previos/Clicked position
      else {
        cursor = SystemMouseCursors.grab;
      }
    }
  }
}
