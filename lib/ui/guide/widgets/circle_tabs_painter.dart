import 'package:flutter/cupertino.dart';

class CircleTabsPainter extends CustomPainter {
  static const WHITE = Color(0xffffffff);
  int position;
  double radiusLittleCircle = 4;
  double radiusBigCircle = 6;
  double distanceBetweenCircles = 25;

  CircleTabsPainter(this.position);

  var painter = Paint()
    ..style = PaintingStyle.fill
    ..color = WHITE
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    switch (position) {
      case 0:
        canvas.drawCircle(Offset(-distanceBetweenCircles, 0), radiusBigCircle, painter);
        canvas.drawCircle(Offset(0, 0), radiusLittleCircle, painter);
        canvas.drawCircle(Offset(distanceBetweenCircles, 0), radiusLittleCircle, painter);
        break;
      case 1:
        canvas.drawCircle(Offset(-distanceBetweenCircles, 0), radiusLittleCircle, painter);
        canvas.drawCircle(Offset(0, 0), radiusBigCircle, painter);
        canvas.drawCircle(Offset(distanceBetweenCircles, 0), radiusLittleCircle, painter);
        break;
      case 2:
        canvas.drawCircle(Offset(-distanceBetweenCircles, 0), radiusLittleCircle, painter);
        canvas.drawCircle(Offset(0, 0), radiusLittleCircle, painter);
        canvas.drawCircle(Offset(distanceBetweenCircles, 0), radiusBigCircle, painter);
        break;
    }

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CircleTabsPainter oldDelegate) => oldDelegate.position != position;
}