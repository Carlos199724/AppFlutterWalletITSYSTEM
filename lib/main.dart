import 'package:billetera_digital/src/user/widget/LoginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Scaffold(
        backgroundColor: Color(0xFF0C0D0E),
        body: LoginUser(), // Contenido principal de la pantalla
      ),
    );
  }
}
