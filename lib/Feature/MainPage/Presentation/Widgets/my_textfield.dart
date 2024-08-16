import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key, required this.style, required this.node});
  final TextStyle style;
  final FocusNode node;
  @override
  Widget build(BuildContext context) {
    node.requestFocus();
    
    return IntrinsicWidth(
      child: TextField(
          autocorrect: true,
          focusNode: node,
          style: style,
          decoration:  const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          )),
    );
  }
}
