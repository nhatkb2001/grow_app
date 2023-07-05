import 'package:flutter/material.dart';
import 'package:grow_app/constants/colors.dart';
import 'dart:math';

class circleProgressProject extends CustomPainter {
  double currentProgress;
  circleProgressProject(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..strokeWidth = 3
      ..color = greyLight
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 15;
    canvas.drawCircle(center, radius, paint);

    //draw animation with paint
    Paint paintAnimationArc = Paint()
      ..strokeWidth = 3
      ..color = purpleMain
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi / 2,
        angle, false, paintAnimationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
