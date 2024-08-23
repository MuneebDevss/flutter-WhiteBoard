import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:white_board/Core/HelpingFunctions/dash_path.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:arrow_path/arrow_path.dart';

class LinePainter extends CustomPainter {
  Offset startPosition;
  Offset? curvePoint;
  final Offset endPosition;
  final MainPageController controller;
  final Color stroke;
  final double strokeWidth, opacity;
  final bool isGrabAble;
  final bool isDashed;
  final int index;
  final BuildContext context;
  final bool hasArrowEnd;
  LinePainter(
      {required this.hasArrowEnd,
      required this.context,
      required this.index,
      required this.controller,
      required this.stroke,
      this.curvePoint,
      required this.isDashed,
      required this.strokeWidth,
      required this.isGrabAble,
      required this.startPosition,
      required this.opacity,
      required this.endPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = stroke.withOpacity(opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final curvedPoint = curvePoint ?? (startPosition + endPosition) / 2;
     Path linePath = Path();
    linePath.moveTo(startPosition.dx, startPosition.dy);
    linePath.quadraticBezierTo(
        curvedPoint.dx, curvedPoint.dy, endPosition.dx, endPosition.dy);
    
    if (!isDashed) {
      linePath=ArrowPath.addTip(linePath);
      canvas.drawPath(linePath, paint);
    } else {
      PathMetrics matrices = linePath.computeMetrics();
      double distance = matrices.first.length;
       Path newPath = dashPath(linePath,
          dashArray: CircularIntervalList([distance / 10, distance / 10]));
          newPath=ArrowPath.addTip(newPath);
      canvas.drawPath(newPath, paint);
    }

    if (isGrabAble) {
      Offset midpoint = curvedPoint;
      Offset midpoint2 = (startPosition);
      Offset midpoint3 = (endPosition);
      Path path = Path();
      path.addOval(Rect.fromCircle(center: midpoint, radius: 10));
      path.addOval(Rect.fromCircle(center: midpoint2, radius: 10));
      path.addOval(Rect.fromCircle(center: midpoint3, radius: 10));

      // Draw the path on the canvas
      canvas.drawPath(path, paint..color = Colors.blue);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BrushClipper extends CustomPainter {
  final List<Offset> points;
  final double strokeWidth, opacity;
  final Color stroke;

  BrushClipper({
    required this.points,
    required this.stroke,
    required this.strokeWidth,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    if (points.length < 2) {
      // If the path only has one line, draw a dot.
      path.addOval(
        Rect.fromCircle(
          center: Offset(points[0].dx, points[0].dy),
          radius: 1,
        ),
      );
    }

    for (int i = 1; i < points.length - 1; ++i) {
      final p0 = points[i];
      final p1 = points[i + 1];
      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    Paint paint = Paint()
      ..color = stroke.withOpacity(opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BrushClipper oldDelegate) {
    return true;
  }
}
