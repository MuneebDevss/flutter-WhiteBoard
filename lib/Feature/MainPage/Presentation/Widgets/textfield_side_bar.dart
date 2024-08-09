import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/Constants/Size/sizes.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/side_bar.dart';

class TextFieldSideBar extends StatefulWidget {
  const TextFieldSideBar(
      {super.key, required this.controller, required this.screenWidth});
  final SideBarController controller;
  final double screenWidth;
  
  @override
  State<TextFieldSideBar> createState() => _TextFieldSideBarState();
}

class _TextFieldSideBarState extends State<TextFieldSideBar> {
  @override
  Widget build(BuildContext context) {
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
            strokeColorPicker(context),
            const SizedBox(
              height: Sizes.md,
            ),
            Text('Opacity', style: Theme.of(context).textTheme.bodySmall),
            
            Slider(
                activeColor: Colors.blue,
                value: widget.controller.opacity,
                mouseCursor: SystemMouseCursors.grab,
                onChanged: (val) {
                  widget.controller.opacity = val;
                  setState(() {});
                }),
            
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
                      widget.controller.fontStyle = FontStyle.commicShans;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:
                          widget.controller.fontStyle == FontStyle.commicShans,
                    )),
                InkWell(
                    onTap: () {
                      widget.controller.fontStyle = FontStyle.lillitaOne;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:widget.controller.fontStyle == FontStyle.lillitaOne,
                    )),
                InkWell(
                    onTap: () {
                      widget.controller.fontStyle = FontStyle.nunnito;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:widget.controller.fontStyle == FontStyle.nunnito,
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
                      widget.controller.fontSize = FontSize.s;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:
                          widget.controller.fontSize == FontSize.s,
                    )),
                InkWell(
                    onTap: () {
                      widget.controller.fontSize = FontSize.m;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:
                          widget.controller.fontSize == FontSize.m,
                    )),
                InkWell(
                    onTap: () {
                      widget.controller.fontSize = FontSize.l;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:
                          widget.controller.fontSize == FontSize.l,
                    )),
                InkWell(
                    onTap: () {
                      widget.controller.fontSize = FontSize.xL;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:
                          widget.controller.fontSize == FontSize.xL,
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
                      widget.controller.alignment = TextAlignment.left;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:widget.controller.alignment == TextAlignment.left,
                    )),
                InkWell(
                    onTap: () {
                      widget.controller.alignment = TextAlignment.center;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:widget.controller.alignment == TextAlignment.center,
                    )),
                InkWell(
                    onTap: () {
                      widget.controller.alignment = TextAlignment.right;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.abc),
                      isSelected:widget.controller.alignment == TextAlignment.right,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
  Wrap strokeColorPicker(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      spacing: 5,
      children: List.generate(5, (strokeIndex) {
        if (strokeIndex <= 3) {
          Color constantColor = widget.controller.constantColors[strokeIndex];
          return InkWell(
              onTap: () {
                widget.controller.strokeColor = constantColor;
                setState(() {});
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: constantColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ));
        } else {
          return InkWell(
              splashColor: widget.controller.strokeColor,
              onTap: () async {
                widget.controller.strokeColor = await showColorPickerDialog(
                    context, widget.controller.strokeColor,
                    showColorCode: true);
                setState(() {});
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: widget.controller.strokeColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ));
        }
      }),
    );
  }
}