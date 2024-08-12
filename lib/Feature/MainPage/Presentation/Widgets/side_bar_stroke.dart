

  import 'package:flutter/material.dart';

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