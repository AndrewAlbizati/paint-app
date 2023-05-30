import 'package:flutter/material.dart';

/// A variation of a CustomPainter that can store what the user has drawn
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      // Draw lines between each of these points
      DrawingPoint? current = drawingPoints[i];
      DrawingPoint? next = drawingPoints[i + 1];
      if (current != null && next != null) {
        canvas.drawLine(current.offset, next.offset, current.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// The class used to represent a point on the canvas
class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
