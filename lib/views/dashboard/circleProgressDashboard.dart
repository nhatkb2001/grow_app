import 'package:flutter/material.dart';
import 'package:grow_app/constants/colors.dart';
import 'dart:math';

class circleProgressDashboard extends CustomPainter {
  double currentDoneProgress;
  double currentTodoProgress;
  double currentPendingProgress;

  circleProgressDashboard(this.currentDoneProgress, this.currentTodoProgress,
      this.currentPendingProgress);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..strokeWidth = 12
      ..color = doneColor
      ..style = PaintingStyle.stroke;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 80;
    // canvas.drawCircle(center, radius, paint);
    //draw animation with paint
    Paint paintAnimationArcDone = Paint()
      ..strokeWidth = 15
      ..color = doneColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint paintAnimationArcTodo = Paint()
      ..strokeWidth = 15
      ..color = todoColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint paintAnimationArcPending = Paint()
      ..strokeWidth = 15
      ..color = pendingColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angleDone = 2 * pi * (currentDoneProgress / 100);
    double angleTodo = 2 * pi * (currentTodoProgress / 100);
    double anglePending = 2 * pi * (currentPendingProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi / 2,
        anglePending, false, paintAnimationArcPending);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi / 2,
        angleTodo, false, paintAnimationArcTodo);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi / 2,
        angleDone, false, paintAnimationArcDone);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
