import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/ShapeModels/text_field_rect.dart';
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
  FontStyle fontStyle;
  FontSize fontSize;
  Color textcolor;
  TextAlignment alignment;
  double opacity;
  SideBarController({
    this.textcolor = const Color(0xFFf08c00),
    this.fontSize = FontSize.m,
    this.fontStyle = FontStyle.commicShans,
    this.alignment = TextAlignment.center,
    this.backgroundColor = Colors.transparent,
    this.strokeColor = Colors.black,
    this.strokeWidth = 2.0,
    this.strokeStyle = StrokeStyle.solid,
    this.opacity = 1,
  });

  void manageTextFieldTap(
      int index, TextFieldRect rect, MainPageController controller) {
    controller.selectedShape = -1;
    (controller.shapes[index] as TextFieldRect).controller.text =
        (rect.child as Text).data!;
    (controller.shapes[index] as TextFieldRect).child =
        MyTextfield(style: (rect.child as Text).style!, node: rect.node!);
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
  
  getFontFamily() {}
}
