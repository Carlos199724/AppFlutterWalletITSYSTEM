import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0E1758),
            Color(0xFF0C0D0E),
            Color(0xFF0C0D0E),
            Color(0xFF0C0D0E),
            Color(0xFF0C0D0E),
          ],
          stops: [
            0.1,
            0.4,
            0.6,
            0.5,
            2,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          tileMode: TileMode.repeated,
        ),
      ),
      child: child,
    );
  }
}
