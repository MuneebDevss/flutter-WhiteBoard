import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final Offset startposition;
  final Offset endPosition;
  LinePainter({required this.startposition, required this.endPosition});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // Draw a line from (0, 0) to (size.width, size.height)
    canvas.drawLine(startposition, endPosition, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
