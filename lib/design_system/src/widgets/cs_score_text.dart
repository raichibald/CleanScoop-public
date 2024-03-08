import 'package:clean_scoop/design_system/src/assets/fonts.gen.dart';
import 'package:flutter/material.dart';

class CSScoreText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double strokeWidth;
  final Color strokeColor;
  final Color textColor;
  final double textHeight;
  final List<BoxShadow>? shadows;

  const CSScoreText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.strokeWidth,
    this.textColor = Colors.black,
    this.strokeColor = Colors.white,
    this.textHeight = 0.7,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final textForeground = Paint()
      ..style = PaintingStyle.stroke;

    if (strokeWidth > 0) {
      textForeground.strokeWidth = strokeWidth;
      textForeground.color = strokeColor;
    }

    return Stack(
        children: [
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                height: textHeight,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationThickness: 0.01,
                fontFamily: FontFamily.oi,
                shadows: shadows,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeWidth
                  ..color = strokeColor,
              ),
            ),
          ),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                height: textHeight,
                color: textColor,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationThickness: 0.01,
                fontFamily: FontFamily.oi,
              ),
            ),
          ),
        ],
      );
  }
}
