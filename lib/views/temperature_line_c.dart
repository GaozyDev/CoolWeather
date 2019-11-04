import 'dart:ui';

import 'package:coolweather/views/temperature_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 气温折线图
class TemperatureLineC extends StatelessWidget {
  final double itemWidth;
  final List<Temp> tempList;

  TemperatureLineC(this.itemWidth, this.tempList);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(0, 140),
        painter: TemperatureLinePainter(itemWidth, tempList));
  }
}

Paint maxLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white70
  ..strokeWidth = 1;

Paint minLinePaint = new Paint()
  ..style = PaintingStyle.stroke
  ..color = Colors.white38
  ..strokeWidth = 1;

Paint dotPaint = new Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white;

Gradient gradient = new LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Colors.white30,
    Colors.transparent,
  ],
);

Rect arcRect = Rect.fromLTRB(0, 0, 0, 140);

Paint bgPaint = new Paint()
  ..style = PaintingStyle.fill
  ..shader = gradient.createShader(arcRect);

class TemperatureLinePainter extends CustomPainter {
  double itemWidth;
  List<Temp> tempList;

  TemperatureLinePainter(this.itemWidth, this.tempList);

  int margin = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height / 2);

    double total = 0;
    tempList.forEach((temp) {
      total += (temp.max + temp.min);
    });
    double average = total / (tempList.length * 2);

    List<Temp> drawList = List();

    tempList.forEach((temp) {
      drawList.add(Temp((average - temp.max) * 8, (average - temp.min) * 8));
    });

    double distance = itemWidth;

    // 画线
    drawLine(drawList, distance, canvas);

    // 画点和文字
    drawDotText(drawList, distance, canvas);

    // 画背景颜色
    drawBg(drawList, distance, distance * 15, canvas);
  }

  void drawLine(List<Temp> dots, double distance, Canvas canvas) {
    for (int i = 0; i < dots.length - 1; i++) {
      double x = distance * i + distance / 2;

      canvas.drawLine(Offset(x, dots.elementAt(i).max),
          Offset(x + distance, dots.elementAt(i + 1).max), maxLinePaint);

      canvas.drawLine(
          Offset(x, dots.elementAt(i).min + margin),
          Offset(x + distance, dots.elementAt(i + 1).min + margin),
          minLinePaint);

      if (i == 0) {
        canvas.drawLine(Offset(0, dots.elementAt(i).max),
            Offset(x, dots.elementAt(i).max), maxLinePaint);

        canvas.drawLine(Offset(0, dots.elementAt(i).min + margin),
            Offset(x, dots.elementAt(i).min + margin), minLinePaint);
      } else if (i == dots.length - 2) {
        canvas.drawLine(
            Offset(x + distance, dots.elementAt(i + 1).max),
            Offset(x + distance + distance / 2, dots.elementAt(i + 1).max),
            maxLinePaint);

        canvas.drawLine(
            Offset(x + distance, dots.elementAt(i + 1).min + margin),
            Offset(x + distance + distance / 2,
                dots.elementAt(i + 1).min + margin),
            minLinePaint);
      }
    }
  }

  void drawDotText(List<Temp> dots, double distance, Canvas canvas) {
    for (int i = 0; i < dots.length; i++) {
      double x = distance * i + distance / 2;

      // 画点
      canvas.drawCircle(Offset(x, dots.elementAt(i).max), 2, dotPaint);
      canvas.drawCircle(Offset(x, dots.elementAt(i).min + margin), 2, dotPaint);

      // 画文字
      TextPainter tpMax =
          getTextPainter('${(tempList.elementAt(i).max + 0.5).toInt()}' + '°');
      tpMax.paint(
          canvas, Offset(x - tpMax.width / 2, dots.elementAt(i).max - 15));

      TextPainter tpMin =
          getTextPainter('${(tempList.elementAt(i).min + 0.5).toInt()}' + '°');
      tpMin.paint(canvas,
          Offset(x - tpMin.width / 2, dots.elementAt(i).min + margin + 5));
    }
  }

  // 画文字
  TextPainter getTextPainter(String text) {
    return TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 10,
        ),
      ),
    )..layout();
  }

  void drawBg(List<Temp> dots, double distance, double width, Canvas canvas) {
    Path path = new Path();
    path.moveTo(0, dots.elementAt(0).max);
    for (int i = 0; i < dots.length; i++) {
      double x = distance * i + distance / 2;
      path.lineTo(x, dots.elementAt(i).max);
    }

    path.lineTo(width, dots.elementAt(5).max);
    path.lineTo(width, dots.elementAt(5).min + margin);

    for (int i = 0; i < dots.length; i++) {
      double x = distance * (14 - i) + distance / 2;
      path.lineTo(x, dots.elementAt(14 - i).min + margin);
    }

    path.lineTo(0, dots.elementAt(0).min + margin);
    path.close();
    canvas.drawPath(path, bgPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
