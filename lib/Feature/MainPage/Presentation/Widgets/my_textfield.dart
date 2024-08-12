import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key, required this.style, required this.fontSize, required this.node});
  final TextStyle style;
  final FocusNode node;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    node.requestFocus();
    
    return IntrinsicWidth(
      child: TextField(
          autocorrect: true,
          focusNode: node,
          style: style,
          decoration:  InputDecoration(
            hintText: 'Write here...',
            hintStyle: TextStyle(fontSize: fontSize),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          )),
    );

  }
}
