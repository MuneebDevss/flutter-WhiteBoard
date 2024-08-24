import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/ShapeModels/text_field_rect.dart';
import 'package:white_board/Core/Enitity/shape.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';

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
  FontFamily fontStyle;
  FontSize fontSize;
  Color textcolor;
  TextAlignment alignment;
  double opacity;
  SideBarController({
    this.textcolor = const Color(0xFFf08c00),
    this.fontSize = FontSize.m,
    this.fontStyle = FontFamily.commicShans,
    this.alignment = TextAlignment.center,
    this.backgroundColor = Colors.transparent,
    this.strokeColor = Colors.black,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.opacity = 1,
  });

  void convertTextToTextField(
      int index, TextFieldRect rect, MainPageController controller) {
    //to make sure it is selected in order to convert it into the text from the textfield
    controller.selectedShape = index;
    //select all the text
    // (controller.shapes[index] as TextFieldRect).controller.selection =
    //     TextSelection(
    //         baseOffset: 0,
    //         extentOffset: (controller.shapes[index] as TextFieldRect)
    //             .controller
    //             .value
    //             .text
    //             .length);
    (controller.shapes[index] as TextFieldRect).child = MyTextfield(
      style: TextStyle(
        fontFamily: rect.fontFamily.getString(),
        fontSize: rect.fontSize.getSize(),
        color: rect.textColor,
      ),
      node: FocusNode(),
      controller: rect.controller,
      convertTextFieldToText: controller.convertTextFieldIntoText,
    );
    
  }

  double getFontSize() {
    if (fontSize == FontSize.s) {
      return 12;
    } else if (fontSize == FontSize.m) {
      return 14;
    } else if (fontSize == FontSize.l) {
      return 16;
    } else {
      return 18;
    }
  }

  String getFontFamily() {
    if (fontStyle == FontFamily.commicShans) {
      return 'CommicSans';
    } else if (fontStyle == FontFamily.lillitaOne) {
      return 'LilitaOne';
    } else {
      return 'Nunito';
    }
  }

  List<Shapes> moveToBottom(
      List<Shapes> shapes, int selectedShape, MainPageController controller) {
    if (selectedShape != -1) {
      List<Shapes> newShapes = [];
      newShapes.add(shapes[selectedShape]);
      for (int x = 0; x < shapes.length; x++) {
        if (x != selectedShape) {
          newShapes.add(shapes[x]);
        }
      }
      controller.shapes.clear();
      controller.selectedShape = 0;
      return newShapes;
    }
    return shapes;
  }

  List<Shapes> moveDownOneLayer(
      List<Shapes> shapes, int selectedShape, MainPageController controller) {
    if (selectedShape != -1) {
      if (selectedShape - 1 >= 0) {
        Shapes previousShape = shapes[selectedShape - 1];

        shapes[selectedShape - 1] = shapes[selectedShape];

        shapes[selectedShape] = previousShape;

        controller.selectedShape = selectedShape - 1;
      }
    }
    return shapes;
  }

  List<Shapes> moveToTop(
      List<Shapes> shapes, int selectedShape, MainPageController controller) {
    if (selectedShape != -1) {
      List<Shapes> newShapes = [];
      for (int x = 0; x < shapes.length; x++) {
        if (x != selectedShape) {
          newShapes.add(shapes[x]);
        }
      }
      newShapes.add(shapes[selectedShape]);
      controller.shapes.clear();
      controller.selectedShape = newShapes.length - 1;
      return newShapes;
    }
    return shapes;
  }

  List<Shapes> moveUpOneLayer(
      List<Shapes> shapes, int selectedShape, MainPageController controller) {
    if (selectedShape != -1) {
      if (selectedShape + 1 < (shapes.length)) {
        Shapes previousShape = shapes[selectedShape + 1];

        shapes[selectedShape + 1] = shapes[selectedShape];

        shapes[selectedShape] = previousShape;

        controller.selectedShape = selectedShape + 1;
      }
    }
    return shapes;
  }
}
