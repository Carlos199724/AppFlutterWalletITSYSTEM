import 'package:flutter/material.dart';

class ProcessingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3, // Ajusta el tamaño vertical
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(), // Indicador de carga
            SizedBox(height: 20),
            Text(
              'Procesando...',
              style: TextStyle(color: Colors.black), // Color del texto
            ), // Mensaje de "Procesando"
          ],
        ),
      ),
    );
  }
}
