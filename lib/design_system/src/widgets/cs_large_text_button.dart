import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CSLargeTextButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const CSLargeTextButton(
      {super.key, required this.title, required this.onTap});

  @override
  State<CSLargeTextButton> createState() => _CSLargeTextButtonState();
}

class _CSLargeTextButtonState extends State<CSLargeTextButton> {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.8 : 1,
      duration: const Duration(milliseconds: 150),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 120,
            child: SvgPicture.asset(Assets.icons.icoForest),
          ),
          GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Padding(
              padding: const EdgeInsets.only(top: 56, bottom: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFFF7D75),
                    border: Border.all(
                      width: 3,
                      color: const Color(0xFF000000),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(14),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF000000),
                        offset: Offset(6, 6),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 0.7,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.transparent,
                      decorationThickness: 0.01,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
