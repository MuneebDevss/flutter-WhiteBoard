import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
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
import 'package:white_board/Feature/MainPage/Domain/Entities/tool.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';
import '../../../Core/Enitity/shape.dart';

class MainPageController {
  //Properties
  late AnimationController controller;
  late Animation<Offset> animation;
  Offset translation = const Offset(0, 0);
  Offset translationClick = const Offset(0, 0);
  late Offset clickedPositioned;
  int selectedShape = -1;
  int id = 0;
  int selectedContainerIndex = -1;
  Widget? image;
  SystemMouseCursor cursor = SystemMouseCursors.click;
  final List<MyStack> stack = [];
  final List<MyStack> redoStack = [];
  List<Shapes> shapes = [];
  //ToolBar
  final List<ToolBarItem> selectedContainer = [
    ToolBarItem(
      button: Image.asset(
        'assets/Icon/rectangle.png',
        fit: BoxFit.contain,
      ),
    ),
    ToolBarItem(
      button: const Icon(Icons.circle_outlined),
    ),
    ToolBarItem(
      button: Image.asset(
        'assets/Icon/arrow.png',
        fit: BoxFit.contain,
      ),
    ),
    ToolBarItem(
      button: Image.asset(
        'assets/Icon/grab.png',
        fit: BoxFit.contain,
        height: 20,
      ),
    ),
    ToolBarItem(
      button: Image.asset('assets/Icon/textfield.png'),
    ),
    ToolBarItem(
      button: Image.asset('assets/Icon/bursh.png'),
    ),
    ToolBarItem(
      button: const Icon(Iconsax.eraser),
    ),
    ToolBarItem(
      button: Image.asset('assets/Icon/gallery.png'),
    ),
    ToolBarItem(
      button: const Icon(Icons.delete_forever),
    ),
  ];
  //Grabbing and Reshaping Properties
  bool shiftPressed = false;
  bool grabingLine = false;
  bool grabbingLineStart = false;
  bool grabbingLineEnd = false;
  bool resizingLeft = false;
  bool resizingTop = false;
  bool resizingBottom = false;
  bool resizingRight = false;
  bool isDrawing = false;
  double currentScale = 1;
  ScreenshotController screenShotController = ScreenshotController();

  bool controlPressed = false;
  //Behaviors
  void manageTap(int index, Offset details) {
    convertTextFieldIntoText();
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
          disposeFocusNodes();
          shapes.clear();
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
            selectedContainerIndex ==
                3)) //already not selected and no tool/grab is selected
    {
      selectedShape = index;
      selectedContainerIndex = 3;
      for (int x = 0; x < shapes.length; x++) {
        if (shapes[x] is TextFieldRect) {
          detectTextField(details, x);
        }
      }
    } else if (selectedShape == index &&
        (selectedContainerIndex == -1 || selectedContainerIndex != 3)) {
      selectedShape = -1;
    }
  }

  void zoomIn() {
    currentScale += 0.1;
  }

  void zoomOut() {
    if (currentScale > 0.1) {
      currentScale -= 0.1;
    }
  }

  void storePanDownPosition(DragStartDetails offsets, BuildContext context,
      SideBarController controller) {
    final box = context.findRenderObject() as RenderBox;
    final details = (box.globalToLocal(offsets.localPosition) - translation);
    clickedPositioned = details;
    translationClick = offsets.localPosition;
    if (selectedContainerIndex == 3) {
      if (selectedShape != -1) addToStack(shapes[selectedShape]);
    }

    if (selectedContainerIndex == 0) {
      Shapes shape = rectangle.Rectangle(
        lT: Offset(details.dx, details.dy),
        scale: currentScale,
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
        id: id,
        opacity: controller.opacity,
        node: FocusNode(),
      );
      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 1) {
      Shapes shape = Circle(
        scale: currentScale,
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        opacity: controller.opacity,
        strokeWidth: controller.strokeWidth,
        backgroundColor: controller.backgroundColor,
        id: id,
        node: FocusNode(),
      );
      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 2) {
      Shapes shape = Line(
        scale: currentScale,
        lT: Offset(details.dx, details.dy),
        rB: Offset(details.dx, details.dy),
        stroke: controller.strokeColor,
        opacity: controller.opacity,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        id: id,
        node: FocusNode(),
      );

      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 5) {
      Shapes shape = Brush(
        scale: currentScale,
        points: [Offset(details.dx, details.dy)],
        stroke: controller.strokeColor,
        strokeStyle: controller.strokeStyle,
        strokeWidth: controller.strokeWidth,
        opacity: controller.opacity,
        id: id,
      );
      shapes.add(shape);
      id += 1;
    } else if (selectedContainerIndex == 7) {
      if (image != null) {
        Shapes shape = rectangle.Rectangle(
            lT: Offset(details.dx, details.dy),
            scale: currentScale,
            rB: Offset(details.dx, details.dy),
            stroke: controller.strokeColor,
            strokeStyle: controller.strokeStyle,
            strokeWidth: controller.strokeWidth,
            opacity: controller.opacity,
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
    if (selectedContainerIndex != 8 &&
        selectedContainerIndex != 6 &&
        selectedContainerIndex != 3) {
      isDrawing = true;
    }
    //New Shape gets Selected By default
    if (selectedContainerIndex != 8 &&
        selectedContainerIndex != 6 &&
        selectedContainerIndex != 5 &&
        selectedContainerIndex != 3 &&
        selectedContainerIndex != -1 &&
        shapes.isNotEmpty) {
      selectedShape = shapes.length - 1;
      shapes[selectedShape].node!.requestFocus();
    }
  }

  void storePointerUpdatePosition(DragUpdateDetails details) {
    Offset position = details.localPosition;

    //Handling line's Curve
    if (selectedContainerIndex == -1) {
      if (selectedShape != -1) {
        if (shapes[selectedShape] is Line) {
          (shapes[selectedShape] as Line).curve = position - translation;
        }
      }
      //manage translations
      else {
        manageTranslation(position);
      }
    }
    // handling shape making
    else if (selectedContainerIndex == 0 || selectedContainerIndex == 7) {
      makeRectangle(position - translation);
    } else if (selectedContainerIndex == 1) {
      makeCircle(position - translation);
    } else if (selectedContainerIndex == 2) {
      makeLine(position - translation);
    } else if (selectedContainerIndex == 3) {
      handleShapeSizingAndGrabing(Offset(position.dx - translation.dx,
          position.dy - translation.dy)); // Shapes resizing
    } else if (selectedContainerIndex == 5) {
      paint(position - translation);
    } else if (selectedContainerIndex == 6) {
      eraseBrush(position - translation);
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
    //end point of the line
    //(slope of line should not be nearly infinity ie line should not be perpendicular to detect gestures)
    if ((pos.dy - shapes[length].lT.dy) / (pos.dx - shapes[length].lT.dx) >
        10) {
      shapes[length].rB = Offset(pos.dx, pos.dy);
      (shapes[length] as Line).curve =
          ((shapes[length].lT + pos) / 2) + const Offset(10, 10);
    } else {
      shapes[length].rB = Offset(pos.dx, pos.dy);
    }
  }

  void handleShapeSizingAndGrabing(Offset position) {
    if (selectedShape != -1) {
      if (grabingLine) {
        Offset delta = position - clickedPositioned;
        shapes[selectedShape].lT += delta;
        shapes[selectedShape].rB += delta;
        (shapes[selectedShape] as Line).curve =
            (shapes[selectedShape] as Line).curve! + delta;
        clickedPositioned = position;
      } else if (grabbingLineStart) {
        shapes[selectedShape].lT = position;
      } else if (grabbingLineEnd) {
        shapes[selectedShape].rB = position;
      } else if (resizingLeft) {
        shapes[selectedShape].lT =
            Offset(position.dx, shapes[selectedShape].lT.dy);
      } else if (resizingRight) {
        shapes[selectedShape].rB =
            Offset(position.dx, shapes[selectedShape].rB.dy);
      } else if (resizingTop) {
        shapes[selectedShape].lT =
            Offset(shapes[selectedShape].lT.dx, position.dy);
      } else if (resizingBottom) {
        shapes[selectedShape].rB =
            Offset(shapes[selectedShape].rB.dx, position.dy);
      } else {
        Offset lT = shapes[selectedShape].lT;
        Offset rB = shapes[selectedShape].rB;
        Shapes selected = shapes[selectedShape];
        if (shapes[selectedShape] is rectangle.Rectangle ||
            shapes[selectedShape] is Circle) {
          //tapped on bottom except corners
          if (lT.dx < position.dx &&
              rB.dx > position.dx &&
              rB.dy - 10 - selected.strokeWidth < position.dy) {
            resizingBottom = true;
            shapes[selectedShape].rB =
                Offset(shapes[selectedShape].rB.dx, position.dy);
          }
          //drag on top except corners
          else if (lT.dx < position.dx &&
              position.dx < rB.dx &&
              lT.dy + 10 + selected.strokeWidth > position.dy) {
            resizingTop = true;
            shapes[selectedShape].lT =
                Offset(shapes[selectedShape].lT.dx, position.dy);
          }
          //tapped on right except corners
          else if (lT.dy < position.dy &&
              position.dy < rB.dy &&
              rB.dx - 10 < position.dx) {
            resizingRight = true;
            shapes[selectedShape].rB =
                Offset(position.dx, shapes[selectedShape].rB.dy);
          }
          //dragged on left except corners
          else if (lT.dy < position.dy &&
              position.dy < rB.dy &&
              lT.dx + 10 > position.dx) {
            resizingLeft = true;
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
          else if (!(resizingLeft ||
              resizingBottom ||
              resizingRight ||
              resizingTop)) {
            grab(position, lT, rB);
          }
        } else if (shapes[selectedShape] is TextFieldRect) {
          grab(position, lT, rB);
        } else if (shapes[selectedShape] is Line) {
          final Offset mid = (shapes[selectedShape] as Line).curve!;
          //Clicked onstart position
          if (position.dx >= lT.dx - 10 &&
              position.dx <= lT.dx + 10 &&
              position.dy >= lT.dy - 10 &&
              position.dy <= lT.dy + 10) {
            shapes[selectedShape].lT = position;
            grabbingLineStart = true;
          }
          //Clicked on end position
          else if (position.dx >= rB.dx - 10 &&
              position.dx <= rB.dx + 10 &&
              position.dy >= rB.dy - 10 &&
              position.dy <= rB.dy + 10) {
            shapes[selectedShape].rB = position;
            grabbingLineEnd = true;
          }
          //grabing
          else if (position.dx >= mid.dx - 10 &&
              position.dx <= mid.dx + 10 &&
              position.dy >= mid.dy - 10 &&
              position.dy <= mid.dy + 10) {
            Offset delta = position - clickedPositioned;
            shapes[selectedShape].lT = lT + delta;
            shapes[selectedShape].rB = rB + delta;
            (shapes[selectedShape] as Line).curve = mid + delta;
            clickedPositioned = position;
            grabingLine = true;
          }
        }
      }
    }
  }

  void grab(Offset position, Offset lT, Offset rB) {
    Offset delta = position - clickedPositioned;
    shapes[selectedShape].lT = lT + delta;
    shapes[selectedShape].rB = rB + delta;
    clickedPositioned = position;
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
      disposeFocusNodes();
      shapes.clear();
      stack.clear();
      redoStack.clear();
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
        alignment: shape.alignment,
        textColor: shape.textColor,
        fontFamily: shape.fontFamily.getString(),
        fontSize: shape.fontSize.getSize(),
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
        alignment: shape.alignment,
        textColor: shape.textColor,
        fontFamily: shape.fontFamily.getString(),
        fontSize: shape.fontSize.getSize(),
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

  void handleKeyEvents(KeyDownEvent event, {Function? func}) {
    if (event.logicalKey == LogicalKeyboardKey.keyD) {
      if (selectedShape != -1) {
        duplicateShape();
        selectedShape = shapes.length - 1;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (func != null) {
        func();
      } else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
        print('w');
        undo();
      }
    } else if (event.logicalKey == LogicalKeyboardKey.shiftRight ||
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
        disposeFocusNodes();
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
      fontSize: stack[stackLength].fontSize!.getFontSize(),
      fontFamily: stack[stackLength].fontFamily!.getFontFamily(),
      textColor: stack[stackLength].textColor!,
      alignment: stack[stackLength].alignment!,
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
        textColor: stack[stackLength].textColor,
        alignment: stack[stackLength].alignment,
        fontFamily: stack[stackLength].fontFamily!.getFontFamily(),
        fontSize: stack[stackLength].fontSize!.getFontSize());
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
        fontFamily: redoStack[redoStackLength].fontFamily!.getFontFamily(),
        fontSize: redoStack[redoStackLength].fontSize!.getFontSize(),
        textColor: redoStack[redoStackLength].textColor!,
        alignment: redoStack[redoStackLength].alignment!));
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
        textColor: redoStack[redoStackLength].textColor,
        alignment: redoStack[redoStackLength].alignment,
        fontFamily: redoStack[redoStackLength].fontFamily!.getFontFamily(),
        fontSize: redoStack[redoStackLength].fontSize!.getFontSize());
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
    resizingLeft = false;
    resizingTop = false;
    resizingBottom = false;
    resizingRight = false;
    grabingLine = false;
    grabbingLineStart = false;
    grabbingLineEnd = false;
    isDrawing = false;
    //Brush selected
    if (selectedContainerIndex != 5 && selectedContainerIndex != 3) {
      if (shapes.isNotEmpty && selectedShape != -1) {
        //just clicked didn't drag while making the shape
        if (shapes[selectedShape].lT.dx - shapes[selectedShape].rB.dx == 0 ||
            shapes[selectedShape].lT.dy - shapes[selectedShape].rB.dy == 0) {
          isDrawing = false;
          shapes.removeLast();
          selectedShape = -1;
        } else if (selectedContainerIndex == 2) {
          (shapes[selectedShape] as Line).curve =
              (shapes[selectedShape].lT + shapes[selectedShape].rB) / 2;
        }
      }
      selectedContainerIndex = -1;
    }
  }

  void manageTranslation(Offset position) {
    Offset delta = position - translationClick;
    translation += delta;
    translationClick = position;
  }

  double scale() {
    return 1;
  }

  void disposeFocusNodes() {
    for (Shapes shape in shapes) {
      shape.node?.dispose();
    }
  }

  void isPointOnLineOrCurve(Offset point) {
    for (int x = 0; x < shapes.length; x++) {
      if (shapes[x] is Line) {
        Line line = shapes[x] as Line;
        Offset lt = line.lT + translation,
            rB = line.rB + translation,
            curve = line.curve! + translation;
        // Check if the line is straight (no curve)
        if (line.curve == (line.lT + line.rB) / 2) {
          double m = (rB.dy - lt.dy) / (rB.dx - lt.dx);
          double c = lt.dy - m * lt.dx;
          double yLine = m * point.dx + c;

          if (point.dy > yLine - 10 - line.strokeWidth &&
              point.dy < yLine + 10 + line.strokeWidth) {
            if (selectedShape == x && selectedContainerIndex == 8) {
              shapes.removeAt(x);
              selectedShape = -1;
            } else if (selectedShape != x) {
              selectedShape = x;
              shapes[x].node!.requestFocus();
            }
            return; // Point found on the straight line
          }
        }
        // Else the line has a curve, we'll approximate the curve using a quadratic equation
        else {
          Offset p0 = lt;
          Offset p1 = curve;
          Offset p2 = rB;

          bool pointOnCurve = false;

          for (double t = 0.0; t <= 1.0; t += 0.001) {
            // Iterating over t to find a match
            double xCurve = (1 - t) * (1 - t) * p0.dx +
                2 * (1 - t) * t * p1.dx +
                t * t * p2.dx;
            double yCurve = (1 - t) * (1 - t) * p0.dy +
                2 * (1 - t) * t * p1.dy +
                t * t * p2.dy;

            // Calculate the distance between the point and the point on the curve
            double distance = (Offset(xCurve, yCurve) - point).distance;

            if (distance <= 30) {
              pointOnCurve = true;
              break;
            }
          }

          if (pointOnCurve) {
            if (selectedShape != x) {
              selectedShape = x;
            } else if (selectedContainerIndex == 8) {
              shapes.removeAt(x);
              selectedShape = -1;
            }
            return; // Point found near the curve
          }
        }
      } else if (shapes[x] is TextFieldRect) {
        detectTextField(point, x);
      }
    }
  }

  void detectTextField(Offset point, int x) {
    point -= translation;
    if (point.dx > shapes[x].lT.dx &&
        point.dx < shapes[x].rB.dx &&
        point.dy > shapes[x].lT.dy &&
        point.dy < shapes[x].rB.dy &&
        x == selectedShape &&
        selectedContainerIndex != 3) {
      TextFieldRect rect = (shapes[x] as TextFieldRect);
      rect.child = MyTextfield(
        style: TextStyle(
          fontFamily: rect.fontFamily.getString(),
          fontSize: rect.fontSize.getSize(),
          color: rect.textColor,
        ),
        node: FocusNode(),
        controller: rect.controller,
        convertTextFieldToText: convertTextFieldIntoText,
      );
    } else if (point.dx > shapes[x].lT.dx &&
        point.dx < shapes[x].rB.dx &&
        point.dy > shapes[x].lT.dy &&
        point.dy < shapes[x].rB.dy) {
      selectedShape = x;
      shapes[x].node!.requestFocus();
    }
  }

  void storeTapDownPosition(TapDownDetails event, BuildContext context,
      SideBarController controller) {
    Offset details = event.localPosition;

    convertTextFieldIntoText();
    if (selectedContainerIndex == 4) {
      TextFieldRect shape = TextFieldRect(
        scale: currentScale,
        lT: details - translation,
        rB: Offset(details.dx + 50, details.dy + 50) - translation,
        stroke: Colors.transparent,
        strokeStyle: StrokeStyle.dashedBorder,
        id: id,
        node: FocusNode(),
        fontSize: controller.fontSize,
        textColor: controller.textcolor,
        fontFamily: controller.fontStyle,
        alignment: controller.alignment,
      );
      (shape).child = MyTextfield(
        style: TextStyle(
            fontSize: controller.getFontSize(),
            color: controller.textcolor.withOpacity(controller.opacity),
            fontFamily: controller.getFontFamily(),
            overflow: TextOverflow.visible),
        node: FocusNode(),
        controller: (shape).controller,
        convertTextFieldToText: convertTextFieldIntoText,
      );
      shapes.add(shape);
      id += 1;
      selectedContainerIndex = -1;
      selectedShape = shapes.length - 1;
    }
    isPointOnLineOrCurve(details);
  }

  //so that the text would be grabable
  void convertTextFieldIntoText() {
    if (selectedShape != -1) {
      if (shapes[selectedShape] is TextFieldRect) {
        if ((shapes[selectedShape] as TextFieldRect)
            .controller
            .text
            .trim()
            .isNotEmpty) {
          TextFieldRect rect = (shapes[selectedShape] as TextFieldRect);

          (shapes[selectedShape] as TextFieldRect).child = Text(
            rect.controller.text,
            textAlign: rect.alignment.textAlign,
            style: TextStyle(
                color: rect.textColor.withOpacity(rect.opacity),
                fontFamily: rect.fontFamily.getString(),
                fontSize: rect.fontSize.getSize()),
          );
          rect.node!.unfocus();
        } else {
          //remvoe the textField if not written anything in it
          shapes.removeAt(selectedShape);
          selectedShape = -1;
        }
      }
    }
  }

  void manageToolBarTaps(int index, isWeb) {
    if (index == 7) {
      pickTheImage(isWeb);
    } else if (selectedShape != -1) {
      if (index != 3 && shapes[selectedShape] is! TextFieldRect) {
        selectedShape = -1;
      }
    }
    convertTextFieldIntoText();

    selectedContainerIndex == index
        ? selectedContainerIndex = -1
        : selectedContainerIndex = index;
  }

  launchRepository() async {
    String url = 'https://github.com/MuneebDevss/flutter-WhiteBoard';
    await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication);
  }

  launchMyGitHub() async {
    String url = 'https://github.com/MuneebDevss';
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  void saveFile(Uint8List bytes, String extension, bool kIsWeb) async {
    if (kIsWeb) {
      html.AnchorElement()
        ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
        ..download =
            'Muneeb\'s WhiteBoard ${DateTime.now().toIso8601String()}.$extension'
        ..style.display = 'none'
        ..click();
    } else {
      // await ImageGallerySaver.saveImage(bytes,
      //     quality: 100, name: 'Muneeb\'s WhiteBoard');
    }
  }

  Future<Uint8List?> getBytes(BuildContext context) async {
    Uint8List? image;
    image = await screenShotController.capture(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);
    return image;
  }

  void duplicateShape() {
    Shapes shape = shapes[selectedShape];
    if (shape is rectangle.Rectangle) {
      Shapes duplicate = rectangle.Rectangle(
        lT: shape.lT + const Offset(20, 20),
        scale: shape.scale,
        rB: shape.rB + const Offset(20, 20),
        stroke: shape.stroke,
        strokeStyle: shape.strokeStyle,
        strokeWidth: shape.strokeWidth,
        rotationAngle: shape.rotationAngle,
        backgroundColor: shape.backgroundColor,
        id: id,
        opacity: shape.opacity,
        node: FocusNode(),
      );
      shapes.add(duplicate);
    } else if (shape is Circle) {
      Shapes duplicate = Circle(
        lT: shape.lT + const Offset(20, 20),
        scale: shape.scale,
        rotationAngle: shape.rotationAngle,
        borderRadius: shape.borderRadius,
        rB: shape.rB + const Offset(20, 20),
        stroke: shape.stroke,
        strokeStyle: shape.strokeStyle,
        strokeWidth: shape.strokeWidth,
        backgroundColor: shape.backgroundColor,
        id: id,
        opacity: shape.opacity,
        node: FocusNode(),
      );
      shapes.add(duplicate);
    } else if (shape is TextFieldRect && shape.child is! MyTextfield) {
      TextFieldRect duplicate = TextFieldRect(
        scale: currentScale,
        lT: shape.lT,
        rB: shape.rB,
        stroke: Colors.transparent,
        strokeStyle: StrokeStyle.dashedBorder,
        id: id,
        node: FocusNode(),
        fontSize: shape.fontSize,
        textColor: shape.textColor,
        fontFamily: shape.fontFamily,
        alignment: shape.alignment,
      );
      duplicate.child = MyTextfield(
        style: TextStyle(
            color: duplicate.textColor.withOpacity(duplicate.opacity),
            fontFamily: duplicate.fontFamily.getString(),
            fontSize: duplicate.fontSize.getSize()),
        node: FocusNode(),
        controller: duplicate.controller,
        convertTextFieldToText: convertTextFieldIntoText,
      );
      duplicate.controller.text = shape.controller.text;
      shapes.add(duplicate);
    } else if (shape is Line) {
      Shapes duplicate = Line(
        lT: shape.lT + const Offset(20, 40),
        scale: shape.scale,
        curve: ((shape.lT + const Offset(20, 40)) +
                (shape.rB + const Offset(20, 40))) /
            2,
        rB: shape.rB + const Offset(20, 50),
        stroke: shape.stroke,
        strokeStyle: shape.strokeStyle,
        strokeWidth: shape.strokeWidth,
        id: id,
        opacity: shape.opacity,
        node: FocusNode(),
      );
      shapes.add(duplicate);
    }
    id += 1;
    selectedContainerIndex = 3;
  }
}
