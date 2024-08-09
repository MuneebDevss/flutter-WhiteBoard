import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  const MyTextfield({super.key, required this.style, required this.fontSize, required this.node});
  final TextStyle style;
  final FocusNode node;
  final double fontSize;

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  
  
  @override
  Widget build(BuildContext context) {
    widget.node.requestFocus();
    return TextField(
        autocorrect: true,
        focusNode: widget.node,
        style: widget.style,
        decoration:  InputDecoration(
          hintText: 'Write here...',
          hintStyle: TextStyle(fontSize: widget.fontSize),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ));

  }
}
