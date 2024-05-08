import 'package:flutter/material.dart';

void ErrorViewSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    ),
  );
}