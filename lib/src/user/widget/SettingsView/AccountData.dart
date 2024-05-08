import 'package:flutter/material.dart';
import '../../components/errorView.dart';
import 'package:flutter/services.dart';
import '../../components/GradientBackground.dart';
import '../../components/LoadingIndicator.dart';
//import '../../../../Service/apiAuthenticate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Service/apiUser.dart';

class AccountData extends StatefulWidget {
  const AccountData({Key? key}) : super(key: key);

  @override
  State<AccountData> createState() => _AccountData();
}

class _AccountData extends State<AccountData> {
  String? fullName;
  String? numDocument;
  String? eEmail;
  String? pPhone;
  String? aAdress;
  String? postalCode;
  bool _isSent = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  String _errorMessage = '';

  Future<void> fetchUserData() async {
    final data = await HttpService().getUserData();

    if (data != null) {
      setState(() {
        fullName = data['full_name'] ?? '';
        numDocument = data['num_document'] ?? '';
        eEmail = data['email'] ?? '';
        pPhone = data['phone'] ?? '';
        aAdress = data['address'] ?? '';
        postalCode = data['postal_code'] ?? '';
        // Establecer los valores iniciales de los controladores de texto
        _emailController.text = eEmail!;
        _phoneController.text = pPhone!;
        _addressController.text = aAdress!;
        _postalCodeController.text = postalCode!;
      });
    }
  }
  
  Future<void> _modificarDatos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Limpiar cualquier mensaje de error anterior
    });

    // Obtener los valores de los campos de texto editables
    String updatedEmail = _emailController.text;
    String updatedPhone = _phoneController.text;
    String updatedAddress = _addressController.text;
    String updatedPostalCode = _postalCodeController.text;

    // Llamar a la función updateUserData para actualizar los datos del usuario
    dynamic response = await HttpService().updateUserData(updatedEmail, updatedPhone, updatedAddress, updatedPostalCode);

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
        // Si la actualización fue exitosa, mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Información actualizada correctamente!'),
            backgroundColor: Colors.green, // Color del SnackBar
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
    // Cambiar el estado para indicar que ya se editaron los datos
    setState(() {
      _isSent = true;
    });
  }


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
                      SizedBox(
                          width: 30), // Agrega espacio entre el icono y el texto
                      Text(
                        "Cuenta",
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
                    "Información personal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 35),
                          Text(
                            "Nombre completo",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          TextField(
                            //controller: _codeController1,
                            controller: TextEditingController(text: fullName),
                            enabled: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              //hintText: "$fullName",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Color.fromARGB(255, 37, 40, 46),
                              filled: true,
                              suffixIcon: Icon(Icons.perm_identity, color: Colors.white,),
                            ),
                          ),
                          SizedBox(height: 19),
                          Text(
                            "Documento",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          TextField(
                            //controller: _codeController1,
                            controller: TextEditingController(text: numDocument),
                            enabled: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              //hintText: "$numDocument",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Color.fromARGB(255, 37, 40, 46),
                              filled: true,
                              suffixIcon: Icon(Icons.library_books_outlined, color: Colors.white,),
                            ),
                          ),
                          SizedBox(height: 19),
                          Text(
                            "Correo",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          TextField(
                            controller: _emailController,
                            //enabled: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              //hintText: "$eEmail",
                              hintText: eEmail != null && eEmail!.isNotEmpty ? eEmail : "Ingrese su correo",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Color.fromARGB(255, 37, 40, 46),
                              filled: true,
                              suffixIcon: Icon(Icons.email_outlined, color: Colors.white,),
                            ),
                          ),
                          SizedBox(height: 19),
                          Text(
                            "Teléfono",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          TextField(
                            controller: _phoneController,
                            //enabled: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: pPhone != null && pPhone!.isNotEmpty ? pPhone : "Ingrese su teléfono",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Color.fromARGB(255, 37, 40, 46),
                              filled: true,
                              suffixIcon: Icon(Icons.local_phone_outlined, color: Colors.white,),
                            ),
                          ),
                          SizedBox(height: 19),
                          Text(
                            "Ubicación",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          TextField(
                            controller: _addressController,
                            //enabled: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: aAdress != null && aAdress!.isNotEmpty ? aAdress : "Ingrese su ubicación",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Color.fromARGB(255, 37, 40, 46),
                              filled: true,
                              suffixIcon: Icon(Icons.maps_home_work_outlined, color: Colors.white,),
                            ),
                          ),
                          SizedBox(height: 19),
                          Text(
                            "Código postal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 19),
                          TextField(
                            controller: _postalCodeController,
                            //enabled: false,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: postalCode != null && postalCode!.isNotEmpty ? postalCode : "Ingrese su código postal",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Color.fromARGB(255, 37, 40, 46),
                              filled: true,
                              suffixIcon: Icon(Icons.map_outlined, color: Colors.white,),
                            ),
                          ),
                          SizedBox(height: 19),

                          
                          ElevatedButton(
                            //onPressed: _isLoading ? null : _modificarDatos,
                            onPressed: _isLoading ? null : () {
                              // Verifica si ya se envió un reporte
                              if (_isSent) {
                                // Muestra el mensaje de error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Ya actualizaste tu información'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                // Si no se ha enviado un reporte, llama al método _enviarDatos
                                _modificarDatos();
                              }
                            },
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
                                    'Guardar',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),



                          SizedBox(height: 38),
                        ],
                      ),
                    ),
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
