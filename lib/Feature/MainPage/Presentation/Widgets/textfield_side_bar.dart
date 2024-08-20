import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/Constants/Size/sizes.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/ShapeModels/text_field_rect.dart';
import 'package:white_board/Core/Enitity/my_stack.dart';
import 'package:white_board/Core/Enitity/shape.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/TextFieldBloc/textfield_bloc.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selection_rectangle.dart';

class TextFieldSideBar extends StatefulWidget {
  const TextFieldSideBar(
      {super.key,
      required this.sideBarController,
      required this.screenWidth,
      required this.selected,
      required this.controller});
  final SideBarController sideBarController;
  final MainPageController controller;
  final double screenWidth;
  final int selected;
  @override
  State<TextFieldSideBar> createState() => _TextFieldSideBarState();
}

class _TextFieldSideBarState extends State<TextFieldSideBar> {
  Shapes? selectedShape;

  @override
  Widget build(BuildContext context) {
    if (widget.selected != -1) {
      selectedShape = widget.controller.shapes[widget.selected];
    }
    return Container(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: TColors.grey,
            blurStyle: BlurStyle.outer,
            offset: Offset(0, 1),
          )
        ],
      ),
      width: widget.screenWidth / 5,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TextColor', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(
              height: Sizes.sm,
            ),
            textColorPicker(context),
            const SizedBox(
              height: Sizes.md,
            ),
            Text('Opacity', style: Theme.of(context).textTheme.bodySmall),
            Slider(
                  
                  mouseCursor: SystemMouseCursors.grab,
                  activeColor: Colors.blue,
                  value: widget.controller.selectedShape == -1
                      ? widget.sideBarController.opacity
                      : selectedShape!.opacity,
                  onChangeStart: (value) {
                    widget.controller.stack.add(MyStack(
                      opacity: value,
                          shape: widget.controller.getShapeType(selectedShape!),
                          id: selectedShape!.id));
                  },
                  onChangeEnd: (val){
                    if (widget.controller.selectedShape != -1) {
                      
                      widget.controller.shapes[widget.controller.selectedShape].opacity = val;
                      context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                    } else {
                      widget.sideBarController.opacity = val;
                    }
                    setState(() {});
                  }, onChanged: (double val) {
                    if (widget.controller.selectedShape != -1) {
                      widget.controller.shapes[widget.controller.selectedShape].opacity = val;
                    } else {
                      widget.sideBarController.opacity = val;
                    }
                    setState(() {});
                  },
                  ),
            Text(
              'Font Family',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            Wrap(
              spacing: Sizes.sm,
              children: [
                GestureDetector(
                    onTap: () {
                      if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .fontFamily = FontFamily.commicShans;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.fontStyle = FontFamily.commicShans;
                  }
                  setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/CommicSans.png'),
                      isSelected: widget.selected != -1
                            ? FontFamily.commicShans ==
                                    (selectedShape! as TextFieldRect).fontFamily
                            : FontFamily.commicShans ==
                                    widget.sideBarController.fontStyle
                                
                    )),
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .fontFamily = FontFamily.lillitaOne;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.fontStyle = FontFamily.lillitaOne;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/Lilita.png'),
                      isSelected: widget.selected != -1
                            ? FontFamily.lillitaOne ==
                                    (selectedShape! as TextFieldRect).fontFamily
                            : FontFamily.lillitaOne ==
                                    widget.sideBarController.fontStyle,
                    )),
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .fontFamily = FontFamily.nunnito;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.fontStyle = FontFamily.nunnito;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/Nunito.png'),
                      isSelected: widget.selected != -1
                            ? FontFamily.nunnito ==
                                    (selectedShape! as TextFieldRect).fontFamily
                            : FontFamily.nunnito ==
                                    widget.sideBarController.fontStyle,
                    )),
              ],
            ),
            const SizedBox(
              height: Sizes.md,
            ),
            Text(
              'Font Size',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            Wrap(
              spacing: Sizes.sm,
              children: [
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .fontSize = FontSize.s;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.fontSize = FontSize.s;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/Small.png'),
                      isSelected:
                          widget.selected != -1
                            ? FontSize.s ==
                                    (selectedShape! as TextFieldRect).fontSize
                            : FontSize.s ==
                                    widget.sideBarController.fontSize,
                    )),
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .fontSize = FontSize.m;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.fontSize = FontSize.m;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/Medium.png'),
                      isSelected:
                          widget.selected != -1
                            ? FontSize.m ==
                                    (selectedShape! as TextFieldRect).fontSize
                            : FontSize.m ==
                                    widget.sideBarController.fontSize,
                    )),
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .fontSize = FontSize.l;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.fontSize = FontSize.l;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/Large.png'),
                      isSelected:
                          widget.selected != -1
                            ? FontSize.l ==
                                    (selectedShape! as TextFieldRect).fontSize
                            : FontSize.l ==
                                    widget.sideBarController.fontSize,
                    )),
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .fontSize = FontSize.xL;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.fontSize = FontSize.xL;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/XLarge.png'),
                      isSelected:
                          widget.selected != -1
                            ? FontSize.xL ==
                                    (selectedShape! as TextFieldRect).fontSize
                            : FontSize.xL ==
                                    widget.sideBarController.fontSize,
                    )),
              ],
            ),
            const SizedBox(
              height: Sizes.md,
            ),
            Text(
              'Text Alignment',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            Wrap(
              spacing: Sizes.sm,
              children: [
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .alignment = TextAlignment.left;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.alignment = TextAlignment.left;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/LeftAlign.png'),
                      isSelected: widget.selected != -1
                            ? TextAlignment.left ==
                                    (selectedShape! as TextFieldRect).alignment
                            : TextAlignment.left ==
                                    widget.sideBarController.alignment,
                    )),
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .alignment = TextAlignment.center;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.alignment = TextAlignment.center;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/CenterAlign.png'),
                      isSelected: widget.selected != -1
                            ? TextAlignment.center ==
                                    (selectedShape! as TextFieldRect).alignment
                            : TextAlignment.center ==
                                    widget.sideBarController.alignment,
                    )),
                InkWell(
                    onTap: () {
                       if (widget.selected != -1) {
                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect)
                        .alignment = TextAlignment.right;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  } else {
                    widget.sideBarController.alignment = TextAlignment.right;
                  }   
                      setState(() {});
                    },
                    child: MySelectionRectangle(
                      iconData: Image.asset('assets/Icon/RightAlign.png'),
                      isSelected: widget.selected != -1
                            ? TextAlignment.right ==
                                    (selectedShape! as TextFieldRect).alignment
                            : TextAlignment.right ==
                                    widget.sideBarController.alignment,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Wrap textColorPicker(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      spacing: 5,
      children: List.generate(5, (strokeIndex) {
        if (strokeIndex <= 3) {
          Color constantColor =
              widget.sideBarController.constantColors[strokeIndex];
          return InkWell(
              onTap: () {
                if (widget.selected != -1) {
                  if (selectedShape is TextFieldRect) {
                    final MyStack stack = MyStack(
                        id: selectedShape!.id,
                        textColor: (selectedShape as TextFieldRect).textColor,
                        shape: ShapeTypes.circle);
                    widget.controller.stack.add(stack);
                    (widget.controller.shapes[widget.selected] as TextFieldRect)
                        .textColor = constantColor;
                    context
                        .read<TextfieldBloc>()
                        .add(ChangeEvent());
                  }
                } else {
                  widget.sideBarController.textcolor = constantColor;
                }

                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                        color: widget.selected != -1
                            ? constantColor ==
                                    (selectedShape! as TextFieldRect).textColor
                                ? constantColor
                                : Colors.transparent
                            : constantColor ==
                                    widget.sideBarController.textcolor
                                ? constantColor
                                : Colors.transparent)),
                child: Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: constantColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ));
        } else {
          return InkWell(
              onTap: () async {
                if (widget.selected != -1) {
                  if (selectedShape is TextFieldRect) {
                    final MyStack stack = MyStack(
                        id: selectedShape!.id,
                        textColor: (selectedShape as TextFieldRect).textColor,
                        shape: ShapeTypes.circle);
                    widget.controller.stack.add(stack);
                    (widget.controller.shapes[widget.selected] as TextFieldRect)
                            .textColor =
                        await showColorPickerDialog(
                            context, widget.sideBarController.textcolor,
                            showColorCode: true);
                    // ignore: use_build_context_synchronously
                    context.read<TextfieldBloc>().add(ChangeEvent());
                  }
                } else {
                  widget.sideBarController.backgroundColor =
                      await showColorPickerDialog(
                          context, widget.sideBarController.textcolor,
                          showColorCode: true);
                }
                setState(() {});
              },
              child: Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.only(left: 10, top: 3),
                decoration: BoxDecoration(
                  color: widget.selected == -1
                      ? widget.sideBarController.textcolor
                      : (widget.controller.shapes[widget.selected]
                              as TextFieldRect)
                          .textColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ));
        }
      }),
    );
  }
}
