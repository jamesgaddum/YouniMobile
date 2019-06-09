import 'dart:math';

import 'package:flutter/material.dart';


class TaskLineChart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Painter()
    );
  }
}

class Painter extends CustomPainter {

  final days = 20;
  final points = { 3: 10.0, 5: 10.0, 13: 5.0, 22: 25.0, 38: 10.0 };

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    var dayWidth = size.width / days;
    var pointHeight = size.height / 100;

    var start = [0.0, 0.0];
    var startCoordinates = [dayWidth * start[0], size.height - start[1]];

    var point1 = [15.0, 100.0];
    var point1Coordinates = [dayWidth * point1[0], size.height - pointHeight * point1[1]];

    var control1 = [dayWidth * (point1[0] - 1), startCoordinates[1]]; 
    var control2 = [dayWidth * (point1[0] - 1), size.height - pointHeight * point1[1]];

    var falseEnd1 = [point1[0] + 1, 0.0];
    var falseEnd1Coordinates = [dayWidth * falseEnd1[0], size.height - falseEnd1[1]];

    var control3 = [falseEnd1Coordinates[0], point1Coordinates[1]];
    var control4 = [falseEnd1Coordinates[0] - dayWidth, falseEnd1Coordinates[1]];

    Path path1 = Path();

    path1.moveTo(startCoordinates[0], startCoordinates[1]);
    path1.cubicTo(control1[0], control1[1], control2[0], control2[1], point1Coordinates[0], point1Coordinates[1]);
    path1.cubicTo(control3[0], control3[1], control4[0], control4[1], falseEnd1Coordinates[0], falseEnd1Coordinates[1]);
    
    var point2 = [20.0, 100.0];
    var point2Coordinates = [dayWidth * point2[0], size.height - pointHeight * point2[1]];

    var control5 = [dayWidth * (point2[0] - 1), startCoordinates[1]]; 
    var control6 = [dayWidth * (point2[0] - 1), size.height - pointHeight * point2[1]];

    var falseEnd2 = [point2[0] + 1, 0.0];
    var falseEnd2Coordinates = [dayWidth * falseEnd2[0], size.height - falseEnd2[1]];

    var control7 = [falseEnd2Coordinates[0], point2Coordinates[1]];
    var control8 = [falseEnd2Coordinates[0] - dayWidth, falseEnd2Coordinates[1]];

    Path path2 = Path();
    
    path1.moveTo(startCoordinates[0], startCoordinates[1]);
    path1.cubicTo(control5[0], control5[1], control6[0], control6[1], point2Coordinates[0], point2Coordinates[1]);
    path1.cubicTo(control7[0], control7[1], control8[0], control8[1], falseEnd2Coordinates[0], falseEnd2Coordinates[1]);

    var metrics1 = path1.computeMetrics();
    metrics1.forEach((m) {
      var x = m.extractPath(0, 10.0);
      print(x.contains(Offset(0, 0)));
    });

    var path3 = Path.combine(PathOperation.union, path1, path2);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}