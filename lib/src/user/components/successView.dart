import 'package:flutter/material.dart';

void SuccessViewSnackBar(BuildContext context, String successMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        successMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green,
    ),
  );
}