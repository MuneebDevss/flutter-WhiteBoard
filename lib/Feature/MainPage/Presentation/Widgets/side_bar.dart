import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/Constants/Size/sizes.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
class MySideBar extends StatefulWidget {
  const MySideBar({super.key, required this.controller, required this.screenWidth});
  final SideBarController controller;
  final double screenWidth;
  @override
  State<MySideBar> createState() => _MySideBarState();
}

class _MySideBarState extends State<MySideBar> {
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
            Text('Stroke', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(
              height: Sizes.sm,
            ),
            strokeColorPicker(context),
            const SizedBox(
              height: Sizes.md,
            ),
            Text('Background Color',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(
              height: Sizes.sm,
            ),
            backGroundColorPicker(context),
            const SizedBox(
              height: Sizes.md,
            ),
            Text('Opacity', style: Theme.of(context).textTheme.bodySmall),
            SizedBox(
              width: double.maxFinite,
              child: Slider(
                  label: '${widget.controller.opacity}',
                  mouseCursor: SystemMouseCursors.grab,
                  activeColor: Colors.blue,
                  value: widget.controller.opacity,
                  onChanged: (val) {
                    widget.controller.opacity = val;
                    setState(() {});
                  }),
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            Text('Stroke width', style: Theme.of(context).textTheme.bodySmall),
            Slider(
                activeColor: Colors.blue,
                value: widget.controller.strokeWidth,
                min: 1,
                mouseCursor: SystemMouseCursors.grab,
                max: 30,
                onChanged: (val) {
                  widget.controller.strokeWidth = val;
                  setState(() {});
                }),
            const SizedBox(
              height: Sizes.sm,
            ),
            Text(
              'Stroke Style',
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
                      widget.controller.strokeStyle = StrokeStyle.solid;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Icon(Icons.horizontal_rule),
                      isSelected:
                          widget.controller.strokeStyle == StrokeStyle.solid,
                    )),
                GestureDetector(
                    onTap: () {
                      widget.controller.strokeStyle = StrokeStyle.dashedBorder;
                      setState(() {});
                    },
                    child: MyStrokeStyle(
                      iconData: const Text(
                        ' ---',
                        style: TextStyle(fontSize: Sizes.md),
                      ),
                      isSelected: widget.controller.strokeStyle ==
                          StrokeStyle.dashedBorder,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
  backGroundColorPicker(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      spacing: 5,
      children: List.generate(5, (strokeIndex) {
        if (strokeIndex <= 3) {
          Color constantColor =
              widget.controller.backGroundConstantColors[strokeIndex];
          return InkWell(
              onTap: () {
                widget.controller.backgroundColor = constantColor;
                setState(() {});
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: constantColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: constantColor == Colors.transparent
                          ? Colors.black
                          : constantColor,
                    )),
              ));
        } else {
          return InkWell(
              splashColor: widget.controller.backgroundColor,
              onTap: () async {
                widget.controller.backgroundColor =
                    await showColorPickerDialog(
                        context, widget.controller.backgroundColor,
                        showColorCode: true);
                setState(() {});
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: widget.controller.backgroundColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: widget.controller.backgroundColor ==
                              Colors.transparent
                          ? Colors.black
                          : widget.controller.backgroundColor,
                    )),
              ));
        }
      }),
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
class MyStrokeStyle extends StatelessWidget {
  const MyStrokeStyle(
      {super.key, required this.iconData, required this.isSelected});
  final Widget iconData;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: isSelected ? Colors.blue : null,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.transparent,
          )),
      duration: const Duration(milliseconds: 200),
      child: iconData,
    );
  }
}