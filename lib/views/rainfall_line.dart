import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 降雨趋势图
class RainfallLine extends StatelessWidget {
  final double width;
  final List<double> precipitation2h;

  RainfallLine(this.width, this.precipitation2h);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
          size: Size(width, 100),
          painter: RainfallLinePainter(precipitation2h)),
      decoration: BoxDecoration(color: Colors.transparent),
    );
  }
}

class RainfallLinePainter extends CustomPainter {
  List<double> precipitation2h;

  RainfallLinePainter(this.precipitation2h);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    canvas.translate(0, height);

    Paint bottomLinePaint = new Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white38
      ..strokeWidth = 1;

    Paint auxiliaryLinePaint = new Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white12
      ..strokeWidth = 1;

    Paint trendLinePaint = new Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white60
      ..strokeWidth = 1.2;

    double distance = width / precipitation2h.length;
    drawLine(precipitation2h, distance, canvas, trendLinePaint);

    canvas.drawLine(Offset(0, 0), Offset(width, 0), bottomLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 1), Offset(width, -height / 3 * 1),
        auxiliaryLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 2), Offset(width, -height / 3 * 2),
        auxiliaryLinePaint);

    canvas.drawLine(Offset(0, -height / 3 * 3), Offset(width, -height / 3 * 3),
        auxiliaryLinePaint);

    TextPainter tpCurrent = getTextPainter('现在');
    tpCurrent.paint(canvas, Offset(0, 0));

    TextPainter tpOneHour = getTextPainter('1小时');
    tpOneHour.paint(canvas, Offset((width - tpOneHour.width) / 2, 0));

    TextPainter tpTwoHour = getTextPainter('2小时');
    tpTwoHour.paint(canvas, Offset(width - tpTwoHour.width, 0));
  }

  // 画文字
  TextPainter getTextPainter(String text) {
    return TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 10,
        ),
      ),
    )..layout();
  }

  // 画文字,无法计算绘制文字的实际宽高，暂时未使用，有时间研究下
  void drawText(Canvas canvas, String text, Offset offset) {
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        fontSize: 12));
    pb.pushStyle(ui.TextStyle(color: Colors.white70));
    ParagraphConstraints pc = ParagraphConstraints(width: 40);
    pb.addText(text);
    Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, offset);
  }

  void drawLine(List<double> precipitation2h, double distance, Canvas canvas, Paint trendLinePaint) {
    for (int i = 0; i < precipitation2h.length - 1; i++) {
      double x = distance * i + distance / 2;
      int multiple = 200;

      canvas.drawLine(
          Offset(x, -precipitation2h.elementAt(i) * multiple),
          Offset(x + distance, -precipitation2h.elementAt(i + 1) * multiple),
          trendLinePaint);

      if (i == 0) {
        canvas.drawLine(
            Offset(0, -precipitation2h.elementAt(0) * multiple),
            Offset(distance / 2, -precipitation2h.elementAt(0) * multiple),
            trendLinePaint);
      } else if (i == precipitation2h.length - 2) {
        canvas.drawLine(
            Offset(x + distance,
                -precipitation2h.elementAt(precipitation2h.length - 1) * multiple),
            Offset(x + distance + distance / 2,
                -precipitation2h.elementAt(precipitation2h.length - 1) * multiple),
            trendLinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
