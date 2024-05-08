import 'package:flutter/material.dart';

void showUpdateDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Trabajando en actualizaciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 20, // Ancho personalizado
              child: CircularProgressIndicator(),
            ), // Indicador de progreso
            SizedBox(height: 20),
            Text(
              'Esta vista está siendo trabajada para futuras actualizaciones.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el BottomSheet
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}
