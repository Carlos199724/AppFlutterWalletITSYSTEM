import 'package:billetera_digital/src/user/components/successView.dart';
import 'package:billetera_digital/src/user/widget/LoginPage.dart';
import 'package:flutter/material.dart';
import '../../../../Service/apiAuthenticate.dart';
import 'package:flutter/services.dart';
import '../../components/errorView.dart';
import '../../components/GradientBackground.dart';
import '../../components/LoadingIndicator.dart';

class RegisterPass extends StatefulWidget {
  final String numeroDocumento;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;
  final String? code; // Nuevo campo

  RegisterPass({
    required this.numeroDocumento,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
    required this.code, // Agrega el nuevo campo al constructor
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPass> createState() => _RegisterPassState();
}

class _RegisterPassState extends State<RegisterPass> {
  bool obscureText1 = false;
  bool obscureText2 = false;
  bool passwordsMatch = true;
  bool isPasswordEmpty = false;
  bool _isLoading = false;
  final TextEditingController controllerPass = TextEditingController();
  TextEditingController controllerRepeatPass = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';

  bool comparePasswords() {
    return controllerPass.text == controllerRepeatPass.text;
  }

  bool isPasswordValid() {
    return controllerPass.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(
                  top: 20.0), // Agrega espacio en la parte superior
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined,
                          color: Colors.grey)),
                  SizedBox(
                      width: 10), // Agrega espacio entre el icono y el texto
                  Text(
                    "Paso 3",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Espacio entre los textos
            Center(
              child: Text(
                "Siente inmediatamente la facilidad de realizar transacciones con solo registrarse",
                textAlign: TextAlign.center, // Alinear al centro
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white, // Color del segundo texto
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                        'assets/nextpassword.png'), // Ruta de tu imagen
                  ),
                  // Agrega más widgets al Column según sea necesario
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                "Ingresa tu contraseña por favor",
                textAlign: TextAlign.center, // Alinear al centro
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white, // Color del segundo texto
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: controllerPass,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ingresa Contraseña",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Color.fromARGB(
                          255, 37, 40, 46), // Cambia el color de fondo aquí
                      filled: true,
                      prefixIcon: Icon(Icons.password, color: Colors.white,),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            // Cambia el estado de obscureText para alternar entre mostrar y ocultar la contraseña
                            obscureText1 = !obscureText1;
                          });
                        },
                        icon: Icon(obscureText1
                            ? Icons.visibility
                            : Icons.visibility_off, color: Colors.white),
                      ),
                    ),
                    obscureText: !obscureText1,
                    onChanged: (value) {
                      setState(() {
                        isPasswordEmpty = value.isEmpty;
                      });
                    },
                  ),
                  if (isPasswordEmpty)
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 8.0),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                            218, 243, 56, 56), // Fondo rojo para indicar error
                        borderRadius:
                            BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: Text(
                        "El campo de contraseña no puede estar vacío",
                        style: TextStyle(
                          color: Colors.white, // Texto blanco para contraste
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: controllerRepeatPass,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Repita contraseña",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Color.fromARGB(
                          255, 37, 40, 46), // Cambia el color de fondo aquí
                      filled: true,
                      prefixIcon: Icon(Icons.password, color: Colors.white,),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            // Cambia el estado de obscureText para alternar entre mostrar y ocultar la contraseña
                            obscureText2 = !obscureText2;
                          });
                        },
                        icon: Icon(obscureText2
                            ? Icons.visibility
                            : Icons.visibility_off, color: Colors.white),
                      ),
                    ),
                    obscureText: !obscureText2,
                  ),

                  if (!passwordsMatch)
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 8.0),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                            218, 243, 56, 56), // Fondo rojo para indicar error
                        borderRadius:
                            BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: Text(
                        "Las contraseñas no coinciden",
                        style: TextStyle(
                          color: Colors.white, // Texto blanco para contraste
                        ),
                      ),
                    ),

                  // Agrega más widgets al Column según sea necesario
                ],
              ),
            ),

            SizedBox(height: 19),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        // Verifica si las contraseñas coinciden y si la contraseña es válida
                        if (comparePasswords() && isPasswordValid()) {
                          setState(() {
                            _isLoading =
                                true; // Establecer isLoading en true mientras se carga
                          });
                          // Intenta registrar al usuario
                          final String numeroDocumento = widget.numeroDocumento;
                          final String nombre = widget.nombre;
                          final String apellido = widget.apellido;
                          final String telefono = widget.telefono;
                          final String correo = widget.correo;
                          final String? code = widget.code;

                          bool success;

                          if (code != null) {
                            success = await HttpService().registerUser(
                              numeroDocumento,
                              nombre,
                              apellido,
                              telefono,
                              correo,
                              controllerPass.text,
                              code: code,
                            );
                          } else {
                            success = await HttpService().registerUser(
                              numeroDocumento,
                              nombre,
                              apellido,
                              telefono,
                              correo,
                              controllerPass.text,
                            );
                          }

                          setState(() {
                            _isLoading =
                                false; // Establecer isLoading en false después de cargar
                          });

                          if (success) {
                            setState(() {
                              _isLoading = false;
                              _successMessage =
                                  '¡Tu registro ha sido exitoso!, Inicia Sesión';
                            });
                            SuccessViewSnackBar(context, _successMessage);

                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginUser(), // Reemplaza 'OtraPagina()' con el nombre de la clase de la página a la que deseas redirigir
                                ),
                              );
                            });
                          } else {
                            setState(() {
                              _isLoading = false;
                              _errorMessage =
                                  'El usuario ${widget.numeroDocumento} ya existe.';
                            });
                            ErrorViewSnackBar(context, _errorMessage);
                            return;
                          }
                        } else {
                          // Si las contraseñas no coinciden o la contraseña no es válida, actualiza el estado para mostrar los mensajes de error
                          setState(() {
                            passwordsMatch = comparePasswords();
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D52EC),
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Ajusta el radio del borde aquí
                  ),
                ),
                child:
                    _isLoading // Mostrar un indicador de carga si isLoading es true
                        ? LoadingIndicator()
                        : Text(
                            'Registrarse',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
