import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size; // Tamaño del SizedBox
  final double strokeWidth; // Ancho de la línea del CircularProgressIndicator
  final Color color; // Color del CircularProgressIndicator

  const LoadingIndicator({
    Key? key,
    this.size = 20.0,
    this.strokeWidth = 3.0,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
