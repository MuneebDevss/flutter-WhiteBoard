import 'package:flutter/material.dart';

class SelectShape extends StatelessWidget {
  const SelectShape({
    super.key,
    required this.screenHeight,
    required this.button,
    required this.isSelected,
  });

  final double screenHeight;
  final Icon button;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(5),
      height: screenHeight - (screenHeight / 1.06),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.5) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 50,
      duration: const Duration(milliseconds: 200),
      child: button,
    );
  }
}
