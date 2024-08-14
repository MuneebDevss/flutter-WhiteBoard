import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/ShapeModels/brush.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart'
    as rectangle;
import 'package:white_board/Core/Enitity/ShapeModels/text_field_rect.dart';
import 'package:white_board/Core/Enitity/my_stack.dart';
import 'package:white_board/Core/HelpingFunctions/image_picker.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selection_container.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';
import '../../../Core/Enitity/shape.dart';

class MainPageController {
  //Properties

  // double zoom = 1;
  // Offset startPosition = const Offset(0, 0);
  // Offset zoomtranslatePosition = const Offset(0, 0);
  // Offset previousZoomPositiion = const Offset(0, 0);
  late Offset clickedPositioned;
  int selectedShape = -1;
  int id = 0;
  int selectedContainerIndex = -1;
  Widget? image;
  SystemMouseCursor cursor = SystemMouseCursors.click;
  List<MyStack> stack = [];
  List<MyStack> redoStack = [];
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

  bool shiftPressed = false;

  //Behaviors

  void manageTap(int index, Offset details) {
    if (!shapes[index].node!.hasFocus) {
      shapes[index].node!.requestFocus();
    } else {
      shapes[index].node!.unfocus();
    }
    if (selectedContainerIndex == 8) //Eraser is selected
    {
      if (selectedShape == index) {
        addToStack(shapes[index]);
        shapes.removeAt(selectedShape);
        if (shapes.isEmpty) {
          shapes = [];
          stack.clear();
          redoStack.clear();
        }
        selectedShape = -1;
      } else if (selectedShape != index) //already not selected
      {
        selectedShape = index;
      }
    } else if (selectedShape != index &&
        (selectedContainerIndex == -1 ||
            selectedContainerIndex != 3)) //already not selected
    {
      selectedShape = index;
    } else if (selectedShape == index &&
        (selectedContainerIndex == -1 || selectedContainerIndex != 3)) {
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

    //so that id do not collide or overflow

    // if (zoom > 1) {
    //   previousZoomPositiion = details;
    // }
    if (selectedContainerIndex == 3) {
      // tap position for the grab
      clickedPositioned = details;
      if (selectedShape != -1) addToStack(shapes[selectedShape]);
    }
    //if not drawing any shape (deleting or grabing the shape)
    if (selectedContainerIndex == 8 || selectedContainerIndex == -1) {
      //tapped on a line
      for (int x = 0; x < length; x++) {
        if (shapes[x] is Line) {
          Shapes line = shapes[x];
          double dx = ((line.lT + line.rB) / 2).dx;
          double dy = ((line.lT + line.rB) / 2).dy;
          if ((dx - 10 <= details.dx && dx + 10 >= details.dx) &&
              (dy - 10 <= details.dy && dy + 10 >= details.dy)) {
            if (selectedContainerIndex == 8 && selectedShape == x) 
            {
              addToStack(shapes[selectedShape]);
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
      Shapes shape = rectangle.Rectangle(
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
        id: id,
        node: FocusNode(),
      );
      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 1) {
      Shapes shape = Circle(
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
        id: id,
        node: FocusNode(),
      );
      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 2) {
      Shapes shape = Line(
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        id: id,
        node: FocusNode(),
      );
      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 4) {
      Shapes shape = TextFieldRect(
          lT: Offset(details.dx, details.dy),
          rB: Offset(details.dx + 50, details.dy - 50),
          stroke: Colors.transparent,
          strokeStyle: StrokeStyle.dashedBorder,
          child: MyTextfield(
            style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                overflow: TextOverflow.visible),
            fontSize: 12,
            node: FocusNode(),
          ),
          id: id,
          node: FocusNode());

      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 5) {
      Shapes shape = Brush(
        points: [Offset(details.dx, details.dy)],
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        id: id,
      );
      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 7) {
      if (image != null) {
        Shapes shape = rectangle.Rectangle(
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
            id: id,
            node: FocusNode());
        shapes.add(shape);
        id += 1;
      }
    }

    //New Shape gets Selected By default
    if (selectedContainerIndex != 8 &&
        selectedContainerIndex != 6 &&
        selectedContainerIndex != 5 &&
        selectedContainerIndex != 3 &&
        selectedContainerIndex != -1) {
      selectedShape = shapes.length - 1;
      shapes[selectedShape].node!.requestFocus();
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
      handleShapeSizingAndGrabing(
          Offset(position.dx, position.dy)); // Shapes resizing
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

  void handleShapeSizingAndGrabing(Offset position) {
    if (selectedShape != -1) {
      Offset lT = shapes[selectedShape].lT;
      Offset rB = shapes[selectedShape].rB;

      if (shapes[selectedShape] is rectangle.Rectangle) {
        //tapped on bottom except corners
        if (lT.dx < position.dx + shapes[selectedShape].rotationAngle &&
            position.dx + shapes[selectedShape].rotationAngle < rB.dx &&
            rB.dy - 10 < position.dy + shapes[selectedShape].rotationAngle &&
            rB.dy + 10 > position.dy + shapes[selectedShape].rotationAngle) {
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
        final Offset mid = (lT + rB) / 2;
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
      addToStack(shapes[temp[i]]);
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
    if (shape is rectangle.Rectangle) {
      addRectToStack(shape);
    } else if (shape is Circle) {
      addCircleToStack(shape);
    } else if (shape is TextFieldRect) {
      addTextFieldToStack(shape);
    } else if (shape is Line) {
      addLineToStack(shape);
    } else if (shape is Brush) {
      addBrushToStack(shape);
    }
  }

  void addToRedoStack(Shapes shape) {
    if (shape is rectangle.Rectangle) {
      addRectToRedoStack(shape);
    } else if (shape is Circle) {
      addCircleToRedoStack(shape);
    } else if (shape is TextFieldRect) {
      addTextFieldToRedoStack(shape);
    } else if (shape is Line) {
      addLineToRedoStack(shape);
    } else if (shape is Brush) {
      addBrushToRedoStack(shape);
    }
  }

  void addLineToStack(Line shape) {
    stack.add(MyStack(
      shape: ShapeTypes.line,
      rotationAngle: shape.rotationAngle,
      id: shape.id,
      lT: shape.lT,
      rB: shape.rB,
      opacity: shape.opacity,
      stroke: shape.stroke,
      node: shape.node,
      strokeStyle: shape.strokeStyle,
      strokeWidth: shape.strokeWidth,
    ));
  }

  void addBrushToStack(Brush shape) {
    return stack.add(MyStack(
      shape: ShapeTypes.brush,
      points: shape.points,
      id: shape.id,
      opacity: shape.opacity,
      stroke: shape.stroke,
      node: shape.node,
      strokeStyle: shape.strokeStyle,
      strokeWidth: shape.strokeWidth,
    ));
  }

  void addTextFieldToStack(TextFieldRect shape) {
    return stack.add(MyStack(
        shape: ShapeTypes.textField,
        rotationAngle: shape.rotationAngle,
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        opacity: shape.opacity,
        stroke: shape.stroke,
        node: shape.node,
        strokeStyle: shape.strokeStyle,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void addRectToStack(rectangle.Rectangle shape) {
    stack.add(MyStack(
        shape: ShapeTypes.rectangle,
        rotationAngle: shape.rotationAngle,
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        borderRadius: shape.borderRadius,
        opacity: shape.opacity,
        stroke: shape.stroke,
        node: shape.node,
        strokeStyle: shape.strokeStyle,
        backgroundColor: shape.backgroundColor,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void addCircleToStack(Circle shape) {
    stack.add(MyStack(
        shape: ShapeTypes.circle,
        rotationAngle: shape.rotationAngle,
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        borderRadius: shape.borderRadius,
        opacity: shape.opacity,
        stroke: shape.stroke,
        node: shape.node,
        strokeStyle: shape.strokeStyle,
        backgroundColor: shape.backgroundColor,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void addLineToRedoStack(Line shape) {
    redoStack.add(MyStack(
      shape: ShapeTypes.line,
      rotationAngle: shape.rotationAngle,
      id: shape.id,
      lT: shape.lT,
      rB: shape.rB,
      opacity: shape.opacity,
      stroke: shape.stroke,
      node: shape.node,
      strokeStyle: shape.strokeStyle,
      strokeWidth: shape.strokeWidth,
    ));
  }

  void addBrushToRedoStack(Brush shape) {
    redoStack.add(MyStack(
      shape: ShapeTypes.brush,
      points: shape.points,
      id: shape.id,
      opacity: shape.opacity,
      stroke: shape.stroke,
      node: shape.node,
      strokeStyle: shape.strokeStyle,
      strokeWidth: shape.strokeWidth,
    ));
  }

  void addTextFieldToRedoStack(TextFieldRect shape) {
    redoStack.add(MyStack(
        shape: ShapeTypes.textField,
        rotationAngle: shape.rotationAngle,
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        opacity: shape.opacity,
        stroke: shape.stroke,
        node: shape.node,
        strokeStyle: shape.strokeStyle,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void addRectToRedoStack(rectangle.Rectangle shape) {
    redoStack.add(MyStack(
        shape: ShapeTypes.rectangle,
        rotationAngle: shape.rotationAngle,
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        borderRadius: shape.borderRadius,
        opacity: shape.opacity,
        stroke: shape.stroke,
        node: shape.node,
        strokeStyle: shape.strokeStyle,
        backgroundColor: shape.backgroundColor,
        strokeWidth: shape.strokeWidth,
        child: shape.child));
  }

  void addCircleToRedoStack(Circle shape) {
    redoStack.add(MyStack(
        shape: ShapeTypes.circle,
        rotationAngle: shape.rotationAngle,
        id: shape.id,
        lT: shape.lT,
        rB: shape.rB,
        borderRadius: shape.borderRadius,
        opacity: shape.opacity,
        stroke: shape.stroke,
        node: shape.node,
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

  void redo() {
    int shapesLength = shapes.length - 1;

    if (redoStack.isEmpty) {
      return;
    }

    int redoStackLength = redoStack.length - 1;

    int id = redoStack[redoStackLength].id;
    //made changes in new made shape
    if (shapes.isNotEmpty) {
      if (shapes[shapesLength].id == id) {
        addToStack(shapes[shapesLength]);
        if (shapes[shapesLength] is Circle) {
          shapes[shapesLength] = redoCircle(shapesLength, redoStackLength);
        }
        //redo Rectangle
        else if (shapes[shapesLength] is rectangle.Rectangle) {
          shapes[shapesLength] = redoRectangle(shapesLength, redoStackLength);
        } else if (shapes[shapesLength] is Brush) {
          shapes[shapesLength] = redoBrush(shapesLength, redoStackLength);
        } else if (shapes[shapesLength] is TextFieldRect) {
          shapes[shapesLength] = redoTextField(shapesLength, redoStackLength);
        } else if (shapes[shapesLength] is Line) {
          shapes[shapesLength] = redoLine(shapesLength, redoStackLength);
        }
        redoStack.removeLast();
      } else {
        //made changes to random shapes
        for (int x = 0; x < shapes.length; x++) {
          if (shapes[x].id == id) {
            addToStack(shapes[shapesLength]);
            if (shapes[x] is Circle) {
              shapes[x] = redoCircle(x, redoStackLength);
            }
            //redo Rectangle
            else if (shapes[x] is rectangle.Rectangle) {
              shapes[x] = redoRectangle(x, redoStackLength);
            } else if (shapes[x] is Brush) {
              shapes[x] = redoBrush(x, redoStackLength);
            } else if (shapes[x] is TextFieldRect) {
              shapes[x] = redoTextField(x, redoStackLength);
            } else if (shapes[x] is Line) {
              shapes[x] = redoLine(x, redoStackLength);
            }
            redoStack.removeLast();
            return;
          }
        }
        //shape is deleted
        redoDeleted(redoStackLength);
        redoStack.removeLast();
      }
    } else {
      redoDeleted(redoStackLength);
      redoStack.removeLast();
    }
  }

  void handleKeyEvents(KeyDownEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.shiftRight ||
        event.logicalKey == LogicalKeyboardKey.shiftLeft && !shiftPressed) {
      shiftPressed = true;
    } else if (shiftPressed &&
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      shapes[selectedShape].rotationAngle -= math.pi / 4;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      shapes[selectedShape].rotationAngle -= math.pi / 36;
    } else if (shiftPressed &&
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      shapes[selectedShape].rotationAngle += math.pi / 4;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      shapes[selectedShape].rotationAngle += math.pi / 36;
    }
    //arrow up +shift
    else if (shiftPressed && event.logicalKey == LogicalKeyboardKey.arrowUp) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy - 20);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy - 20);
    }
    //arrow up
    else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy - 5);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy - 5);
    }
    //arrow up + shift
    else if (shiftPressed && event.logicalKey == LogicalKeyboardKey.arrowDown) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy + 20);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy + 20);
    }
    //arrow down
    else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy + 5);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy + 5);
    }
  }

  void handleKeyholdEvents(KeyRepeatEvent event) {
    if (shiftPressed && event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      shapes[selectedShape].rotationAngle -= math.pi / 4;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      shapes[selectedShape].rotationAngle -= math.pi / 36;
    } else if (shiftPressed &&
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      shapes[selectedShape].rotationAngle += math.pi / 4;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      shapes[selectedShape].rotationAngle += math.pi / 36;
    }
    //arrow up +shift
    else if (shiftPressed && event.logicalKey == LogicalKeyboardKey.arrowUp) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy - 20);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy - 20);
    }
    //arrow up
    else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy - 5);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy - 5);
    }
    //arrow up + shift
    else if (shiftPressed && event.logicalKey == LogicalKeyboardKey.arrowDown) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy + 20);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy + 20);
    }
    //arrow down
    else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      shapes[selectedShape].rB =
          Offset(shapes[selectedShape].rB.dx, shapes[selectedShape].rB.dy + 5);
      shapes[selectedShape].lT =
          Offset(shapes[selectedShape].lT.dx, shapes[selectedShape].lT.dy + 5);
    }
  }

  void undo() {
    int shapesLength = shapes.length - 1;
    //did not create a new shape

    if (stack.isEmpty) {
      //if undid all the changes to the shapes remove them one by one
      if (shapes.isNotEmpty) {
        addToRedoStack(shapes[shapesLength]);
        selectedShape = -1;
        shapes.removeLast();
      } else {
        //cannot redo after undoing everything
        redoStack.clear();
      }
      return;
    }
    int stackLength = stack.length - 1;
    int id = stack[stackLength].id;
    //made changes in new made shape
    if (shapes.isNotEmpty) {
      if (shapes[shapesLength].id == id) {
        addToRedoStack(shapes[shapesLength]);
        if (shapes[shapesLength] is Circle) {
          shapes[shapesLength] = undoCircle(shapesLength, stackLength);
        }
        //undo Rectangle
        else if (shapes[shapesLength] is rectangle.Rectangle) {
          shapes[shapesLength] = undoRectangle(shapesLength, stackLength);
        } else if (shapes[shapesLength] is Brush) {
          shapes[shapesLength] = undoBrush(shapesLength, stackLength);
        } else if (shapes[shapesLength] is TextFieldRect) {
          shapes[shapesLength] = undoTextField(shapesLength, stackLength);
        } else if (shapes[shapesLength] is Line) {
          shapes[shapesLength] = undoLine(shapesLength, stackLength);
        }
        stack.removeLast();
      } else {
        //made changes to random shapes
        for (int x = 0; x < shapes.length; x++) {
          if (shapes[x].id == id) {
            addToRedoStack(shapes[x]);
            if (shapes[x] is Circle) {
              shapes[x] = undoCircle(x, stackLength);
            }
            //undo Rectangle
            else if (shapes[x] is rectangle.Rectangle) {
              shapes[x] = undoRectangle(x, stackLength);
            } else if (shapes[x] is Brush) {
              shapes[x] = undoBrush(x, stackLength);
            } else if (shapes[x] is TextFieldRect) {
              shapes[x] = undoTextField(x, stackLength);
            } else if (shapes[x] is Line) {
              shapes[x] = undoLine(x, stackLength);
            }
            stack.removeLast();
            return;
          }
        }
        //shape is deleted
        undoDeleted(stackLength);
        stack.removeLast();
      }
    } else {
      undoDeleted(stackLength);
      stack.removeLast();
    }
  }

  void undoDeleted(int stackLength) {
    if (stack[stackLength].shape == ShapeTypes.rectangle) {
      undoDeletedRectangle(stackLength);
      selectedShape = shapes.length - 1;
    } else if (stack[stackLength].shape == ShapeTypes.line) {
      undoDeletedLine(stackLength);
    } else if (stack[stackLength].shape == ShapeTypes.brush) {
      undoDeletedBrush(stackLength);
    } else if (stack[stackLength].shape == ShapeTypes.textField) {
      undoDeletedTextField(stackLength);
    } else if (stack[stackLength].shape == ShapeTypes.circle) {
      undoDeletedCircle(stackLength);
    }
  }

  void undoDeletedCircle(int stackLength) {
    return shapes.add(Circle(
      lT: stack[stackLength].lT!,
      rB: stack[stackLength].rB!,
      stroke: stack[stackLength].stroke!,
      strokeStyle: stack[stackLength].strokeStyle!,
      strokeWidth: stack[stackLength].strokeWidth!,
      backgroundColor: stack[stackLength].backgroundColor!,
      id: stack[stackLength].id,
      node: stack[stackLength].node,
      rotationAngle: stack[stackLength].rotationAngle!,
      borderRadius: stack[stackLength].borderRadius!,
      child: stack[stackLength].child,
      opacity: stack[stackLength].opacity!,
    ));
  }

  void undoDeletedTextField(int stackLength) {
    return shapes.add(TextFieldRect(
      lT: stack[stackLength].lT!,
      rB: stack[stackLength].rB!,
      stroke: stack[stackLength].stroke!,
      strokeStyle: stack[stackLength].strokeStyle!,
      strokeWidth: stack[stackLength].strokeWidth!,
      id: stack[stackLength].id,
      node: stack[stackLength].node,
      rotationAngle: stack[stackLength].rotationAngle!,
      child: stack[stackLength].child,
      opacity: stack[stackLength].opacity!,
    ));
  }

  void undoDeletedBrush(int stackLength) {
    shapes.add(Brush(
      stroke: stack[stackLength].stroke!,
      strokeStyle: stack[stackLength].strokeStyle!,
      strokeWidth: stack[stackLength].strokeWidth!,
      id: stack[stackLength].id,
      opacity: stack[stackLength].opacity!,
      points: stack[stackLength].points!,
    ));
  }

  void undoDeletedLine(int stackLength) {
    return shapes.add(Line(
      lT: stack[stackLength].lT!,
      rB: stack[stackLength].rB!,
      stroke: stack[stackLength].stroke!,
      strokeStyle: stack[stackLength].strokeStyle!,
      strokeWidth: stack[stackLength].strokeWidth!,
      id: stack[stackLength].id,
      node: stack[stackLength].node,
      rotationAngle: stack[stackLength].rotationAngle!,
      opacity: stack[stackLength].opacity!,
    ));
  }

  void undoDeletedRectangle(int stackLength) {
    shapes.add(rectangle.Rectangle(
      lT: stack[stackLength].lT!,
      rB: stack[stackLength].rB!,
      stroke: stack[stackLength].stroke!,
      strokeStyle: stack[stackLength].strokeStyle!,
      strokeWidth: stack[stackLength].strokeWidth!,
      backgroundColor: stack[stackLength].backgroundColor!,
      id: stack[stackLength].id,
      node: stack[stackLength].node,
      rotationAngle: stack[stackLength].rotationAngle!,
      borderRadius: stack[stackLength].borderRadius!,
      child: stack[stackLength].child,
      opacity: stack[stackLength].opacity!,
    ));
  }

  Line undoLine(int shapesLength, int stackLength) {
    return (shapes[shapesLength] as Line).copyWith(
      stroke: stack[stackLength].stroke,
      strokeStyle: stack[stackLength].strokeStyle,
      strokeWidth: stack[stackLength].strokeWidth,
      lT: stack[stackLength].lT,
      rB: stack[stackLength].rB,
      rotationAngle: stack[stackLength].rotationAngle,
      node: stack[stackLength].node,
      opacity: stack[stackLength].opacity,
    );
  }

  TextFieldRect undoTextField(int shapesLength, int stackLength) {
    return (shapes[shapesLength] as TextFieldRect).copyWith(
      child: (stack[stackLength]).child,
      stroke: stack[stackLength].stroke,
      strokeStyle: stack[stackLength].strokeStyle,
      strokeWidth: stack[stackLength].strokeWidth,
      lT: stack[stackLength].lT,
      rB: stack[stackLength].rB,
      rotationAngle: stack[stackLength].rotationAngle,
      node: stack[stackLength].node,
      opacity: stack[stackLength].opacity,
    );
  }

  Brush undoBrush(int shapesLength, int stackLength) {
    return (shapes[shapesLength] as Brush).copyWith(
      id: stack[stackLength].id,
      stroke: stack[stackLength].stroke,
      strokeStyle: stack[stackLength].strokeStyle,
      strokeWidth: stack[stackLength].strokeWidth,
      opacity: stack[stackLength].opacity,
      points: stack[stackLength].points,
    );
  }

  rectangle.Rectangle undoRectangle(int shapesLength, int stackLength) {
    MyStack temporaryStack = stack[stackLength];

    return (shapes[shapesLength] as rectangle.Rectangle).copyWith(
      id: temporaryStack.id,
      backgroundColor: (temporaryStack).backgroundColor,
      child: (temporaryStack).child,
      stroke: temporaryStack.stroke,
      strokeStyle: temporaryStack.strokeStyle,
      strokeWidth: temporaryStack.strokeWidth,
      lT: temporaryStack.lT,
      rB: temporaryStack.rB,
      rotationAngle: temporaryStack.rotationAngle,
      node: temporaryStack.node,
      opacity: temporaryStack.opacity,
      borderRadius: temporaryStack.borderRadius,
    );
  }

  Circle undoCircle(int shapesLength, int stackLength) {
    return (shapes[shapesLength] as Circle).copyWith(
      backgroundColor: (stack[stackLength]).backgroundColor,
      child: (stack[stackLength]).child,
      stroke: stack[stackLength].stroke,
      strokeStyle: stack[stackLength].strokeStyle,
      strokeWidth: stack[stackLength].strokeWidth,
      lT: stack[stackLength].lT,
      rB: stack[stackLength].rB,
      rotationAngle: stack[stackLength].rotationAngle,
      node: stack[stackLength].node,
      opacity: stack[stackLength].opacity,
      borderRadius: stack[stackLength].borderRadius,
    );
  }

  void redoDeleted(int redoStackLength) {
    if (redoStack[redoStackLength].shape == ShapeTypes.rectangle) {
      redoDeletedRectangle(redoStackLength);
      selectedShape = shapes.length - 1;
    } else if (redoStack[redoStackLength].shape == ShapeTypes.line) {
      redoDeletedLine(redoStackLength);
    } else if (redoStack[redoStackLength].shape == ShapeTypes.brush) {
      redoDeletedBrush(redoStackLength);
    } else if (redoStack[redoStackLength].shape == ShapeTypes.textField) {
      redoDeletedTextField(redoStackLength);
    } else if (redoStack[redoStackLength].shape == ShapeTypes.circle) {
      redoDeletedCircle(redoStackLength);
    }
  }

  void redoDeletedCircle(int stackLength) {
    return shapes.add(Circle(
      lT: redoStack[stackLength].lT!,
      rB: redoStack[stackLength].rB!,
      stroke: redoStack[stackLength].stroke!,
      strokeStyle: redoStack[stackLength].strokeStyle!,
      strokeWidth: redoStack[stackLength].strokeWidth!,
      backgroundColor: redoStack[stackLength].backgroundColor!,
      id: redoStack[stackLength].id,
      node: redoStack[stackLength].node,
      rotationAngle: redoStack[stackLength].rotationAngle!,
      borderRadius: redoStack[stackLength].borderRadius!,
      child: redoStack[stackLength].child,
      opacity: redoStack[stackLength].opacity!,
    ));
  }

  void redoDeletedTextField(int redoStackLength) {
    return shapes.add(TextFieldRect(
      lT: redoStack[redoStackLength].lT!,
      rB: redoStack[redoStackLength].rB!,
      stroke: redoStack[redoStackLength].stroke!,
      strokeStyle: redoStack[redoStackLength].strokeStyle!,
      strokeWidth: redoStack[redoStackLength].strokeWidth!,
      id: redoStack[redoStackLength].id,
      node: redoStack[redoStackLength].node,
      rotationAngle: redoStack[redoStackLength].rotationAngle!,
      child: redoStack[redoStackLength].child,
      opacity: redoStack[redoStackLength].opacity!,
    ));
  }

  void redoDeletedBrush(int redoStackLength) {
    shapes.add(Brush(
      stroke: redoStack[redoStackLength].stroke!,
      strokeStyle: redoStack[redoStackLength].strokeStyle!,
      strokeWidth: redoStack[redoStackLength].strokeWidth!,
      id: redoStack[redoStackLength].id,
      opacity: redoStack[redoStackLength].opacity!,
      points: redoStack[redoStackLength].points!,
    ));
  }

  void redoDeletedLine(int redoStackLength) {
    return shapes.add(Line(
      lT: redoStack[redoStackLength].lT!,
      rB: redoStack[redoStackLength].rB!,
      stroke: redoStack[redoStackLength].stroke!,
      strokeStyle: redoStack[redoStackLength].strokeStyle!,
      strokeWidth: redoStack[redoStackLength].strokeWidth!,
      id: redoStack[redoStackLength].id,
      node: redoStack[redoStackLength].node,
      rotationAngle: redoStack[redoStackLength].rotationAngle!,
      opacity: redoStack[redoStackLength].opacity!,
    ));
  }

  void redoDeletedRectangle(int redoStackLength) {
    shapes.add(rectangle.Rectangle(
      lT: redoStack[redoStackLength].lT!,
      rB: redoStack[redoStackLength].rB!,
      stroke: redoStack[redoStackLength].stroke!,
      strokeStyle: redoStack[redoStackLength].strokeStyle!,
      strokeWidth: redoStack[redoStackLength].strokeWidth!,
      backgroundColor: redoStack[redoStackLength].backgroundColor!,
      id: redoStack[redoStackLength].id,
      node: redoStack[redoStackLength].node,
      rotationAngle: redoStack[redoStackLength].rotationAngle!,
      borderRadius: redoStack[redoStackLength].borderRadius!,
      child: redoStack[redoStackLength].child,
      opacity: redoStack[redoStackLength].opacity!,
    ));
  }

  Line redoLine(int shapesLength, int redoStackLength) {
    return (shapes[shapesLength] as Line).copyWith(
      stroke: redoStack[redoStackLength].stroke,
      strokeStyle: redoStack[redoStackLength].strokeStyle,
      strokeWidth: redoStack[redoStackLength].strokeWidth,
      lT: redoStack[redoStackLength].lT,
      rB: redoStack[redoStackLength].rB,
      rotationAngle: redoStack[redoStackLength].rotationAngle,
      node: redoStack[redoStackLength].node,
      opacity: redoStack[redoStackLength].opacity,
    );
  }

  TextFieldRect redoTextField(int shapesLength, int redoStackLength) {
    return (shapes[shapesLength] as TextFieldRect).copyWith(
      child: (redoStack[redoStackLength]).child,
      stroke: redoStack[redoStackLength].stroke,
      strokeStyle: redoStack[redoStackLength].strokeStyle,
      strokeWidth: redoStack[redoStackLength].strokeWidth,
      lT: redoStack[redoStackLength].lT,
      rB: redoStack[redoStackLength].rB,
      rotationAngle: redoStack[redoStackLength].rotationAngle,
      node: redoStack[redoStackLength].node,
      opacity: redoStack[redoStackLength].opacity,
    );
  }

  Brush redoBrush(int shapesLength, int redoStackLength) {
    return (shapes[shapesLength] as Brush).copyWith(
      id: redoStack[redoStackLength].id,
      stroke: redoStack[redoStackLength].stroke,
      strokeStyle: redoStack[redoStackLength].strokeStyle,
      strokeWidth: redoStack[redoStackLength].strokeWidth,
      opacity: redoStack[redoStackLength].opacity,
      points: redoStack[redoStackLength].points,
    );
  }

  rectangle.Rectangle redoRectangle(int shapesLength, int redoStackLength) {
    MyStack temporaryredoStack = redoStack[redoStackLength];

    return (shapes[shapesLength] as rectangle.Rectangle).copyWith(
      id: temporaryredoStack.id,
      backgroundColor: (temporaryredoStack).backgroundColor,
      child: (temporaryredoStack).child,
      stroke: temporaryredoStack.stroke,
      strokeStyle: temporaryredoStack.strokeStyle,
      strokeWidth: temporaryredoStack.strokeWidth,
      lT: temporaryredoStack.lT,
      rB: temporaryredoStack.rB,
      rotationAngle: temporaryredoStack.rotationAngle,
      node: temporaryredoStack.node,
      opacity: temporaryredoStack.opacity,
      borderRadius: temporaryredoStack.borderRadius,
    );
  }

  Circle redoCircle(int shapesLength, int redoStackLength) {
    return (shapes[shapesLength] as Circle).copyWith(
      backgroundColor: (redoStack[redoStackLength]).backgroundColor,
      child: (redoStack[redoStackLength]).child,
      stroke: redoStack[redoStackLength].stroke,
      strokeStyle: redoStack[redoStackLength].strokeStyle,
      strokeWidth: redoStack[redoStackLength].strokeWidth,
      lT: redoStack[redoStackLength].lT,
      rB: redoStack[redoStackLength].rB,
      rotationAngle: redoStack[redoStackLength].rotationAngle,
      node: redoStack[redoStackLength].node,
      opacity: redoStack[redoStackLength].opacity,
      borderRadius: redoStack[redoStackLength].borderRadius,
    );
  }

  ShapeTypes getShapeType(Shapes shapes) {
    if (shapes is rectangle.Rectangle) {
      return ShapeTypes.rectangle;
    } else if (shapes is Line) {
      return ShapeTypes.line;
    } else if (shapes is TextFieldRect) {
      return ShapeTypes.textField;
    } else if (shapes is Circle) {
      return ShapeTypes.circle;
    } else {
      return ShapeTypes.brush;
    }
  }

  void managePanEnd(DragEndDetails det) {
    if (selectedContainerIndex != 5) {
      selectedContainerIndex = -1;
    }
  }
}
