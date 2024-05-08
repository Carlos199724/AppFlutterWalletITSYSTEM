import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Service/apiUser.dart';
import 'ConfirmSend.dart';
import '../../components/errorView.dart';
import '../../components/GradientBackground.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

class SendView extends StatefulWidget {
  final int points;
  const SendView({Key? key, required this.points}) : super(key: key);

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  bool _isLoading = false;
  TextEditingController _keyController = TextEditingController();
  String _errorMessage = '';
  String? scannedResult;

  Future<void> _verificarCodigo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Limpiar cualquier mensaje de error anterior
    });

    String codigo = _keyController.text;

    if (codigo.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ingrese Código';
      });
      ErrorViewSnackBar(context, _errorMessage);
      return;
    }

    // Llamada a la función de verificación de clave pública en HttpService
    dynamic response = await HttpService().verifyPublicKey(codigo);
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
        String fullName = response['full_name'];
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ConfirmSend(
              codigo: codigo, fullName: fullName, points: widget.points),
        ));
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

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      setState(() {
        scannedResult = barcode;
        _keyController.text = scannedResult ?? '';
      });
      print('Scanned Result: $scannedResult');
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Código QR escaneado: $scannedResult'),
          duration: Duration(seconds: 2), // Duración del SnackBar
        ),
      );*/
      _verificarCodigo();
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
                margin: EdgeInsets.only(
                  top: 20.0,
                ),
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
                      "Enviar",
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
                  "Ingrese el código del usuario para que pueda recibir tus puntos de transferencia",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(
                  'assets/points.png',
                  fit: BoxFit.contain,
                  height: 200, // Establece la altura deseada
                  width: 200,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _keyController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Ingrese Código",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color.fromARGB(255, 37, 40, 46),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.contact_emergency_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verificarCodigo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D52EC),
                    fixedSize: Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Enviar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              this._buttonGroup(),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buttonGroup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _scan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          fixedSize: Size(300, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(
          Icons.qr_code_scanner,
          color: Color(0xFF2D52EC), // Color del icono
        ),
        label: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Color(0xFF2D52EC),
                  strokeWidth: 3,
                ),
              )
            : Text(
                'Escanear QR',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF2D52EC),
                ),
              ),
      ),
    );
  }
}
