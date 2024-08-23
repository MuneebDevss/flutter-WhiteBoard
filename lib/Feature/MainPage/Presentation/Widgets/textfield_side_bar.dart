import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/Constants/Size/sizes.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/Enitity/ShapeModels/text_field_rect.dart';
import 'package:white_board/Core/Enitity/my_stack.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/TextFieldBloc/textfield_bloc.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selection_rectangle.dart';

class TextFieldSideBar extends StatefulWidget {
  const TextFieldSideBar(
      {super.key,
      required this.sideBarController,
      required this.screenWidth,
      required this.controller,
      required this.screenHeight,
      required this.isWeb});
  final SideBarController sideBarController;
  final MainPageController controller;
  final double screenWidth;
  final double screenHeight;
  
  final bool isWeb;
  @override
  State<TextFieldSideBar> createState() => _TextFieldSideBarState();
}

class _TextFieldSideBarState extends State<TextFieldSideBar> {
  
  
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 
    return AnimatedBuilder(
      animation: widget.controller.animation,
      builder: (BuildContext context, Widget? child) {
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
          width: widget.controller.animation.value.dx,
          height: widget.isWeb
              ? widget.screenHeight / 1.4
              : widget.screenHeight / 2,
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
                      : widget.controller.shapes[widget.controller.selectedShape].opacity,
                  onChangeStart: (value) {
                    widget.controller.stack.add(MyStack(
                        opacity: value,
                        shape: ShapeTypes.textField,
                        id: widget.controller.shapes[widget.controller.selectedShape].id));
                  },
                  onChangeEnd: (val) {
                    if (widget.controller.selectedShape != -1) {
                      widget.controller.shapes[widget.controller.selectedShape]
                          .opacity = val;
                      setState(() {});
                      context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                    } else {
                      widget.sideBarController.opacity = val;
                      setState(() {});
                    }
                  },
                  onChanged: (double val) {
                    if (widget.controller.selectedShape != -1) {
                      widget.controller.shapes[widget.controller.selectedShape]
                          .opacity = val;
                      setState(() {});
                      context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                    } else {
                      widget.sideBarController.opacity = val;
                      setState(() {});
                    }
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
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .fontFamily = FontFamily.commicShans;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            } else {
                              widget.sideBarController.fontStyle =
                                  FontFamily.commicShans;
                              setState(() {});
                            }
                          }
                        },
                        child: MySelectionRectangle(
                            iconData: Image.asset('assets/Icon/CommicSans.png'),
                            isSelected: widget.controller.selectedShape != -1
                                ? FontFamily.commicShans ==
                                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).fontFamily
                                : FontFamily.commicShans ==
                                    widget.sideBarController.fontStyle)),
                    InkWell(
                        onTap: () {
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .fontFamily = FontFamily.lillitaOne;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.fontStyle =
                                FontFamily.lillitaOne;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/Lilita.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? FontFamily.lillitaOne ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).fontFamily
                              : FontFamily.lillitaOne ==
                                  widget.sideBarController.fontStyle,
                        )),
                    InkWell(
                        onTap: () {
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .fontFamily = FontFamily.nunnito;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.fontStyle =
                                FontFamily.nunnito;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/Nunito.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? FontFamily.nunnito ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).fontFamily
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
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .fontSize = FontSize.s;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.fontSize = FontSize.s;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/Small.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? FontSize.s ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).fontSize
                              : FontSize.s == widget.sideBarController.fontSize,
                        )),
                    InkWell(
                        onTap: () {
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .fontSize = FontSize.m;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.fontSize = FontSize.m;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/Medium.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? FontSize.m ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).fontSize
                              : FontSize.m == widget.sideBarController.fontSize,
                        )),
                    InkWell(
                        onTap: () {
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .fontSize = FontSize.l;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.fontSize = FontSize.l;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/Large.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? FontSize.l ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).fontSize
                              : FontSize.l == widget.sideBarController.fontSize,
                        )),
                    InkWell(
                        onTap: () {
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .fontSize = FontSize.xL;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.fontSize = FontSize.xL;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/XLarge.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? FontSize.xL ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).fontSize
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
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .alignment = TextAlignment.left;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.alignment =
                                TextAlignment.left;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/LeftAlign.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? TextAlignment.left ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).alignment
                              : TextAlignment.left ==
                                  widget.sideBarController.alignment,
                        )),
                    InkWell(
                        onTap: () {
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .alignment = TextAlignment.center;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.alignment =
                                TextAlignment.center;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/CenterAlign.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? TextAlignment.center ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).alignment
                              : TextAlignment.center ==
                                  widget.sideBarController.alignment,
                        )),
                    InkWell(
                        onTap: () {
                          if (widget.controller.selectedShape != -1) {
                            if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                              (widget.controller.shapes[widget.controller
                                      .selectedShape] as TextFieldRect)
                                  .alignment = TextAlignment.right;
                              setState(() {});
                              context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                            }
                          } else {
                            widget.sideBarController.alignment =
                                TextAlignment.right;
                            setState(() {});
                          }
                        },
                        child: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/RightAlign.png'),
                          isSelected: widget.controller.selectedShape != -1
                              ? TextAlignment.right ==
                                  (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).alignment
                              : TextAlignment.right ==
                                  widget.sideBarController.alignment,
                        )),
                  ],
                ),
                const SizedBox(
                  height: Sizes.sm,
                ),
                Text(
                  'Layers',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: Sizes.sm,
                ),
                Wrap(
                  spacing: Sizes.spaceBtwItems,
                  runSpacing: Sizes.spaceBtwInputFields,
                  children: [
                    IconButton.filled(
                        onPressed: () {
                          widget.controller.shapes = widget.sideBarController
                              .moveDownOneLayer(widget.controller.shapes,
                                  widget.controller.selectedShape,widget.controller);
                           
                          setState(() {});
                          context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/LayerDown.png'),
                          isSelected: false,
                        )),
                    IconButton.filled(
                        onPressed: () {
                          widget.controller.shapes = widget.sideBarController
                              .moveToBottom(widget.controller.shapes,
                                  widget.controller.selectedShape,widget.controller);
                         
                          
                          setState(() {});
                          context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/BottomLayer.png'),
                          isSelected: false,
                        )),
                    IconButton.filled(
                        onPressed: () {
                          widget.controller.shapes = widget.sideBarController
                              .moveToTop(widget.controller.shapes,
                                  widget.controller.selectedShape,widget.controller);
                          
                          setState(() {});
                          context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/TopLayer.png'),
                          isSelected: false,
                        )),
                    IconButton.filled(
                        onPressed: () {
                          widget.controller.shapes = widget.sideBarController
                              .moveUpOneLayer(widget.controller.shapes,
                                  widget.controller.selectedShape,widget.controller);
                         
                          setState(() {});
                          context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/LayerUp.png'),
                          isSelected: false,
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
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
                if (widget.controller.selectedShape != -1) {
                  
                    if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                      final MyStack stack = MyStack(
                          id: widget.controller.shapes[widget.controller.selectedShape].id,
                          textColor: (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).textColor,
                          shape: ShapeTypes.circle);
                      widget.controller.stack.add(stack);
                      (widget.controller.shapes[widget.controller.selectedShape]
                              as TextFieldRect)
                          .textColor = constantColor;
                      setState(() {});
                      context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                    }
                  
                } else {
                  setState(() {});
                  widget.sideBarController.textcolor = constantColor;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                        color: widget.controller.selectedShape != -1
                            ? constantColor ==
                                    (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).textColor
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
                if (widget.controller.selectedShape != -1) {
                  {
                    if (widget.controller.shapes[widget.controller.selectedShape] is TextFieldRect) {
                      final MyStack stack = MyStack(
                          id: widget.controller.shapes[widget.controller.selectedShape].id,
                          textColor: (widget.controller.shapes[widget.controller.selectedShape] as TextFieldRect).textColor,
                          shape: ShapeTypes.circle);
                      widget.controller.stack.add(stack);
                      (widget.controller.shapes[widget.controller.selectedShape]
                                  as TextFieldRect)
                              .textColor =
                          await showColorPickerDialog(
                              context, widget.sideBarController.textcolor,
                              showColorCode: true);
                      // ignore: use_build_context_synchronously
                      setState(() {});
                      context.read<TextfieldBloc>().add(ChangeEvent(func:  widget.controller.convertTextFieldIntoText));
                    }
                  }
                } else {
                  widget.sideBarController.backgroundColor =
                      await showColorPickerDialog(
                          context, widget.sideBarController.textcolor,
                          showColorCode: true);
                  setState(() {});
                }
              },
              child: Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.only(left: 10, top: 3),
                decoration: BoxDecoration(
                  color: widget.controller.selectedShape == -1
                      ? widget.sideBarController.textcolor
                      : (widget.controller.shapes[widget.controller.selectedShape]
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
