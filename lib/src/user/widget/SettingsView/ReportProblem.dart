import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/GradientBackground.dart';
import '../../components/LoadingIndicator.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io';
import '../../components/errorView.dart';
import '../../../../Service/apiUser.dart';

class ReportProblem extends StatefulWidget {
  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  String? _selectedProblemType;
  String _description = '';
  bool _isSent = false;
  bool _isLoading = false;
  //File? _imageFile;
  String _errorMessage = '';

  List<String> _problemTypes = [
    'Problema de interfaz',
    'Problema de rendimiento',
    'Problema de conexión',
    'Otro'
  ];

  Future<void> _enviarDatos() async {

    if (_description.isEmpty || _selectedProblemType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todos los campos son obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Limpiar cualquier mensaje de error anterior
    });

    String problem = _selectedProblemType!;
    String description = _description;
    //String evidence = _imageFile!.path;
    String evidence = '_imageFile!.path';

    dynamic response = await HttpService().reportProblem(problem, description, evidence);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
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

    // Cambiar el estado para indicar que el reporte ha sido enviado
    setState(() {
      _isSent = true;
    });
  }

  /*
  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
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
                      SizedBox(width: 30), // Agrega espacio entre el icono y el texto
                      Text(
                        "Informar de un problema",
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

                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Tipo de problema",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _problemTypes.map((type) {
                              return RadioListTile<String>(
                                title: Text(
                                  type,
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: type,
                                groupValue: _selectedProblemType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedProblemType = value;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Descripción del problema",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          TextField(
                            maxLines: 5,
                            maxLength: 150,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                              });
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey, // Color del borde
                                  width: 5.0, // Grosor del borde
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          /*
                          Text(
                            "Sube la evidencia",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  controller: TextEditingController(text: _imageFile != null ? _imageFile!.path.split('/').last : ''),
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey, // Color del borde
                                        width: 5.0, // Grosor del borde
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_file, color: Colors.white),
                                onPressed: _seleccionarImagen,
                              ),
                            ],
                          ),
                          */
                          SizedBox(height: 30.0),
                          ElevatedButton(
                            onPressed: _isLoading ? null : () {
                              // Verifica si ya se envió un reporte
                              if (_isSent) {
                                // Muestra el mensaje de error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Ya enviaste tu reporte'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                // Si no se ha enviado un reporte, llama al método _enviarDatos
                                _enviarDatos();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2D52EC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(300, 50),
                            ),
                            child: _isLoading
                                ? LoadingIndicator()
                                // Ajusta el tamaño del botón
                                  : Text(
                                    'Enviar',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 38),
                        ],
                      )
                    )
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  

}
