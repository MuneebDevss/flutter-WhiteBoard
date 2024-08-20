import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key, required this.style, required this.node, required this.controller});
  final TextStyle style;
  final FocusNode node;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    node.requestFocus();

    return TextField(
        controller: controller,
        autocorrect: true,
        focusNode: node,
        style: style,
        decoration: const InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ));
  }
}
