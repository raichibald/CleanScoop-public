import 'package:clean_scoop/design_system/src/assets/fonts.gen.dart';
import 'package:flutter/material.dart';

class CSScoreText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double strokeWidth;
  final Color strokeColor;
  final Color textColor;

  const CSScoreText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.strokeWidth,
    this.textColor = Colors.black,
    this.strokeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                height: 0.7,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationThickness: 0.01,
                fontFamily: FontFamily.oi,
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
              style: TextStyle(
                fontSize: fontSize,
                height: 0.7,
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
