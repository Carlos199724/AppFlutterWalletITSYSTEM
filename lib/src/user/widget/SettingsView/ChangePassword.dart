import 'package:flutter/material.dart';
import '../../components/errorView.dart';
import 'package:flutter/services.dart';
import '../../components/GradientBackground.dart';
import '../../components/LoadingIndicator.dart';
import '../../../../Service/apiAuthenticate.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  bool _isLoading = false;
  TextEditingController _codeController1 = TextEditingController();
  TextEditingController _codeController2 = TextEditingController();
  TextEditingController _codeController3 = TextEditingController();
  String _errorMessage = '';

  Future<void> _verificarContrasena() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Limpiar cualquier mensaje de error anterior
    });

    String oldPassword = _codeController1.text;
    String newPassword = _codeController2.text;
    String confirmPassword = _codeController3.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Todos los campos son obligatorios';
      });
      ErrorViewSnackBar(context, _errorMessage);
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Las nuevas contraseñas no coinciden';
      });
      ErrorViewSnackBar(context, _errorMessage);
      return;
    }

    dynamic response = await HttpService().changePassword(oldPassword, newPassword, confirmPassword);
    if (response != null && response is Map<String, dynamic>) {
      // Si la respuesta es un mapa, procede con la lógica de manejo de la respuesta
      if (response.containsKey('error')) {
        // Si hay un error en la respuesta, mostrar el mensaje de error
        setState(() {
          _isLoading = false;
          _errorMessage = response['error'];
        });

        ErrorViewSnackBar(context, _errorMessage);
      } else {
        String contentText = '';
        if (response.containsKey('old_password') && response['old_password'] is List) {
          for (var oldPassword in response['old_password']) {
            contentText += '$oldPassword\n';
          }
        }

        if (response.containsKey('new_password2') && response['new_password2'] is List) {
          for (var newPassword in response['new_password2']) {
            contentText += '$newPassword\n';
          }
        }

        if (response.containsKey('message') && response['message'] is String) {
          contentText += '${response['message']}\n';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(contentText.trim()),              
            backgroundColor: Colors.red, // Color del SnackBar
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Si la respuesta no es un mapa o es nula, muestra un mensaje de error genérico
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ocurrió un error al procesar la respuesta.';
      });
      ErrorViewSnackBar(context, _errorMessage);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          width: 30), // Agrega espacio entre el icono y el texto
                      Text(
                        "Cambiar contraseña",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Text(
                    "¡Ingresa los siguientes datos!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /*
                      Image.asset(
                        'assets/compr.png',
                        height: 180, // Establece la altura deseada
                        width: 180, // Establece el ancho deseado
                      ),*/
                      SizedBox(height: 35),
                      TextField(
                        controller: _codeController1,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Contraseña anterior",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Color.fromARGB(255, 37, 40, 46),
                          filled: true,
                          prefixIcon: Icon(Icons.contact_emergency_outlined, color: Colors.white,),
                        ),
                      ),
                      SizedBox(height: 19),
                      TextField(
                        controller: _codeController2,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Nueva contraseña",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Color.fromARGB(255, 37, 40, 46),
                          filled: true,
                          prefixIcon: Icon(Icons.contact_emergency_outlined, color: Colors.white,),
                        ),
                      ),
                      SizedBox(height: 19),
                      TextField(
                        controller: _codeController3,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Confirmar contraseña",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Color.fromARGB(255, 37, 40, 46),
                          filled: true,
                          prefixIcon: Icon(Icons.contact_emergency_outlined, color: Colors.white,),
                        ),
                      ),
                      SizedBox(height: 19),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _verificarContrasena,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D52EC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20),
                          ),
                          fixedSize: Size(300, 50),
                        ),
                        child: _isLoading
                            ? LoadingIndicator()
                            // Ajusta el tamaño del botón
                              : Text(
                                'Siguiente',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
