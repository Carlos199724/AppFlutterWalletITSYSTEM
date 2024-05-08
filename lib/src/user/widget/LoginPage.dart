import 'package:billetera_digital/src/user/components/MenuPrincipal.dart';
import 'package:flutter/material.dart';
import '../../../Service/apiAuthenticate.dart';
import '../components/GradientBackground.dart';
import 'Register/RegisterForm.dart';
import '../components/LoadingIndicator.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool isLoading = false;
  bool obscureText = false;
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final String document = _documentController.text;
    final String password = _passwordController.text;

    // Verifica si los campos están vacíos
    if (document.isEmpty || password.isEmpty) {
      // Muestra un mensaje indicando que los campos están vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, ingresa tu usuario y contraseña.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color.fromARGB(255, 211, 71, 61),
        ),
      );

      setState(() {
        isLoading = false;
      });

      return; // Detiene la ejecución de la función si los campos están vacíos
    }

    // Realiza la llamada a la función loginUser de HttpService
    bool success = await HttpService().loginUser(document, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MenuPrincipal(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ups!, Credenciales incorrectas',
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color.fromARGB(255, 211, 71, 61),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GradientBackground(
      child: Scaffold(   
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:<Widget> [
            SizedBox(height: 150), // Espacio superior
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white, // Color que quieres aplicar
                BlendMode.srcIn, // Modo de mezcla para aplicar el color
              ),
              child: Image.asset(
                'assets/iconoLogo.png', // Ruta de la imagen
                width: size.width *
                    0.4, // Ajusta el ancho de la imagen según sea necesario
                height: size.height *
                    0.2, // Ajusta la altura de la imagen según sea necesario
                fit: BoxFit
                    .contain, // Ajusta el ajuste de la imagen según sea necesario
              ),
            ),
            SizedBox(
                height: 20), // Espacio entre la imagen y los campos de entrada
            SizedBox(
              width: 355, // Ancho deseado para los campos de entrada y el botón
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextField(
                      controller: _documentController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Nro. Documento",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(
                            255, 37, 40, 46), // Cambia el color de fondo aquí
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !obscureText,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        fillColor: Color.fromARGB(255, 37, 40, 46),
                        filled: true,
                        prefixIcon: Icon(Icons.password, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(obscureText
                                ? Icons.visibility
                                : Icons.visibility_off, color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF2D52EC), // Color de fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Ajusta el radio del borde aquí
                        ),
                      ),
                      child: isLoading
                          ? LoadingIndicator()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 10.0), // Ajusta el tamaño del botón
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(
                height:
                    20), // Espacio entre los campos de entrada y el botón de registro
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegisterForm(),
                ));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "¿Aún no tienes cuenta? ",
                      style: TextStyle(
                        color: Colors.white, // Color del primer texto
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "Registro",
                      style: TextStyle(
                        color: Color(0xFF2D52EC), // Color del segundo texto
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100), // Espacio inferior
          ],
        ),
      ),)
    ));
  }
}
