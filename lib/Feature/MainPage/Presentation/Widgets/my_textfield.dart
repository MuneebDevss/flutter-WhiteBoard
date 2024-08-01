import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({super.key, required this.style});
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: style,
      decoration: const InputDecoration(
        
        border: OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        )
      );
    
  }
  }   