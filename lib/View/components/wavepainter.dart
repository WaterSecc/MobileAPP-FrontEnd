import 'dart:math';
import 'package:flutter/material.dart';

class WaterLevelPainter extends CustomPainter {
  final double waterLevel;
  final Color backgroundColor;
  final Color waterColor;
  final String text;
  final TextStyle textStyle;
  final double strokeWidth;

  WaterLevelPainter({
    required this.waterLevel,
    required this.backgroundColor,
    required this.waterColor,
    required this.text,
    required this.textStyle,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // Draw the background circle
    final framePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, framePaint);

    // Draw the water level
    final waterPaint = Paint()
      ..color = waterColor.withOpacity(waterLevel)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      pi * 2 * waterLevel,
      false,
      waterPaint,
    );

    // Draw the text
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: size.width,
      );
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
