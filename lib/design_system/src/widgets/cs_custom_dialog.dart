import 'package:flutter/material.dart';

class CSCustomDialog extends StatefulWidget {
  final Animation<double> animation;
  final String title;
  final String content;
  final VoidCallback onCloseTap;

  const CSCustomDialog({
    super.key,
    required this.animation,
    required this.title,
    required this.content,
    required this.onCloseTap,
  });

  @override
  State<CSCustomDialog> createState() => _CSCustomDialogState();
}

class _CSCustomDialogState extends State<CSCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.animation,
      child: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCCF3DD),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(6, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          height: 0.7,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                          decorationColor: Colors.transparent,
                          decorationThickness: 0.01,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.2,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                          decorationColor: Colors.transparent,
                          decorationThickness: 0.01,
                          // fontFamily: FontFamily.oi,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 24,
              child: _AlertCloseButton(
                onTap: widget.onCloseTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertCloseButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AlertCloseButton({required this.onTap});

  @override
  State<_AlertCloseButton> createState() => _AlertCloseButtonState();
}

class _AlertCloseButtonState extends State<_AlertCloseButton> {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.8 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFCCF3DD),
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF000000),
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Text(
              'X',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                height: 0.7,
                color: Colors.black,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationThickness: 0.01,
                // fontFamily: FontFamily.oi,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
