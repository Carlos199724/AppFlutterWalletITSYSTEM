import 'package:flutter/material.dart';
import '../../../../Service/apiAuthenticate.dart';
import 'RegisterPass.dart';
import '../../components/errorView.dart';
import '../../components/GradientBackground.dart';

class RegisterCode extends StatefulWidget {
  final String numeroDocumento;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;

  RegisterCode({
    required this.numeroDocumento,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
  });

  @override
  State<RegisterCode> createState() => _RegisterCodeState();
}

class _RegisterCodeState extends State<RegisterCode> {
  final TextEditingController controllerCode = TextEditingController();
  bool _isLoading = false;
  bool _adShown = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    if (!_adShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAd(context);
        _adShown = true; // Marcar el anuncio como mostrado
      });
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30),
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
                            color: Colors.white)),
                    SizedBox(
                        width: 10), // Agrega espacio entre el icono y el texto
                    Text(
                      "Paso 2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // Espacio entre los textos
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
                          'assets/LogoCodigo.png'), // Ruta de tu imagen
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
                  "¿Cuenta con codigo de referencia?",
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: controllerCode,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Ingrese Código",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Color.fromARGB(
                              255, 37, 40, 46), // Cambia el color de fondo aquí
                          filled: true,
                          prefixIcon: Icon(Icons.contact_emergency_outlined, color: Colors.white,),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF2D52EC)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            fixedSize: MaterialStateProperty.all<Size>(
                              Size(58, 58),
                            ),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15), // Radio del borde
                                        side: BorderSide(
                                          color: Color(
                                              0xFF2D52EC), // Color del borde
                                          width: 2, // Ancho del borde
                                        ))),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 20), // Espacio horizontal
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading =
                                        true; // Activar indicador de carga
                                  });

                                  // Llamar a la función para verificar el código de referencia
                                  final isValid = await HttpService()
                                      .verifyReferenceCode(controllerCode.text);

                                  setState(() {
                                    _isLoading =
                                        false; // Desactivar indicador de carga
                                  });

                                  if (isValid) {
                                    // Si el código es válido, enviar a la siguiente vista con el código y otros datos
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => RegisterPass(
                                        numeroDocumento: widget.numeroDocumento,
                                        nombre: widget.nombre,
                                        apellido: widget.apellido,
                                        telefono: widget.telefono,
                                        correo: widget.correo,
                                        code: controllerCode.text,
                                      ),
                                    ));
                                  } else {
                                    // Si el código no es válido, enviar a la siguiente vista con el código como null
                                    setState(() {
                                      _isLoading = false;
                                      _errorMessage =
                                          'El código no es válido, si desea continua sin código';
                                    });
                                    ErrorViewSnackBar(context, _errorMessage);
                                    return;
                                  }
                                },
                          child: _isLoading
                              ? SizedBox(
                                  // Si está cargando, muestra el indicador de carga
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3, // Ancho de la línea
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white), // Color del indicador
                                  ),
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.find_in_page_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                        width:
                                            1), // Espacio entre el icono y el texto
                                  ],
                                ),
                        ),
                      ),
                    ),

                    // Agrega más widgets al Column según sea necesario
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Align(
                alignment:
                    Alignment.bottomRight, // Alinear hacia abajo y a la derecha
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .end, // Alinear al final (borde derecho)
                    children: [

                      Spacer(),
                      Center(
                        child: IconButton(
                          icon: Icon(Icons.keyboard_control_rounded,
                              color: Color(0xFF2D52EC), size: 40),
                          onPressed: () {},
                        ),
                      ),
                    Spacer(),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded,
                            color: Color(0xFF2D52EC), size: 30),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => RegisterPass(
                              numeroDocumento: widget.numeroDocumento,
                              nombre: widget.nombre,
                              apellido: widget.apellido,
                              telefono: widget.telefono,
                              correo: widget.correo,
                              code: null,
                            ),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Función para mostrar el anuncio
  void _showAd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white, // Fondo blanco para la imagen
                padding: EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/bonus.png', // Ruta de la imagen del anuncio
                  height: 200.0,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '📢¡Anuncio!🎉',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                'Únete con código, y gana puntos extras. ¡Conéctate y multiplica tus beneficios!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el anuncio
                },
                child: Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
