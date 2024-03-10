import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CSLargeIconButton extends StatefulWidget {
  final String icon;
  final VoidCallback onTap;

  const CSLargeIconButton({super.key, required this.icon, required this.onTap});

  @override
  State<CSLargeIconButton> createState() => _CSLargeIconButtonState();
}

class _CSLargeIconButtonState extends State<CSLargeIconButton> {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.8 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFFCCF3DD),
              border: Border.all(
                width: 3,
                color: const Color(0xFF000000),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF000000),
                  offset: Offset(6, 6),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 56,
            ),
            child: SvgPicture.asset(widget.icon),
          ),
        ),
      ),
    );
  }
}
