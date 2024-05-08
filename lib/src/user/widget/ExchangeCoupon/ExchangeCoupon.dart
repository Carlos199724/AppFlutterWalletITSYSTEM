import 'package:billetera_digital/src/user/widget/ExchangeCoupon/ExchangeDetails.dart';
import 'package:billetera_digital/src/user/widget/SendView/DetailsSend.dart';
import 'package:flutter/material.dart';
import '../../components/errorView.dart';
import '../../../../Service/apiUser.dart';
import 'package:flutter/services.dart';
import '../../components/GradientBackground.dart';
import '../../components/LoadingIndicator.dart';
import '../../components/ProcessingDialog.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

class ExchangeCoupon extends StatefulWidget {
  const ExchangeCoupon({Key? key}) : super(key: key);

  @override
  State<ExchangeCoupon> createState() => _ExchangeCouponState();
}

class _ExchangeCouponState extends State<ExchangeCoupon> {
  bool _isLoading = false;
  TextEditingController _codeController = TextEditingController();
  String _errorMessage = '';
  String? scannedResult;

  Future<void> _verificarCodigo() async {
    setState(() {
      _errorMessage = ''; // Limpiar cualquier mensaje de error anterior
    });

    showDialog(
      context: context,
      barrierDismissible:
          false, // Para que no se pueda cerrar haciendo clic fuera del diálogo
      builder: (BuildContext context) {
        return ProcessingDialog();
      },
    );

    String codigo = _codeController.text;

    if (codigo.isEmpty) {
      setState(() {
        _errorMessage = 'Se debe proporcionar un código válido';
      });
      ErrorViewSnackBar(context, _errorMessage);
      Navigator.pop(context);
      return;
    }

    // Llamada a la función de verificación de clave pública en HttpService
    dynamic response = await HttpService().exchangeCoupon(codigo);
    if (response != null && response is Map<String, dynamic>) {
      // Si la respuesta es un mapa, procede con la lógica de manejo de la respuesta
      if (response.containsKey('error')) {
        // Si hay un error en la respuesta, mostrar el mensaje de error
        setState(() {
          _errorMessage = response['error'];
        });

        ErrorViewSnackBar(context, _errorMessage);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DetailsExchange(
            points: -10, 
            date: response['created_at'],
            couponName: response['Coupons']['name'],
            couponCode: response['Coupons']['coupon_code'],
            couponDescription: response['Coupons']['description'] ?? "Vacío",
            couponPoints: response['Coupons']['points'],
            userFullName: response['User']['full_name'],
          ),
        ));
      }
    } else {
      // Si la respuesta no es un mapa o es nula, muestra un mensaje de error genérico
      setState(() {
        _errorMessage = 'Ocurrió un error al procesar la respuesta.';
      });
      ErrorViewSnackBar(context, _errorMessage);
      Navigator.pop(context);
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
        _codeController.text = scannedResult ?? '';
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
                      "Canjear cupón",
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
                  "¡Canjea tus cupones para obtener puntos!",
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
                    Image.asset(
                      'assets/compr.png',
                      height: 180, // Establece la altura deseada
                      width: 180, // Establece el ancho deseado
                    ),
                    SizedBox(height: 35),
                    TextField(
                      controller: _codeController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Ingresar Código de cupón",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(255, 37, 40, 46),
                        filled: true,
                        prefixIcon: Icon(Icons.contact_emergency_outlined, color: Colors.white,),
                      ),
                    ),
                    SizedBox(height: 19),
                    ElevatedButton(
                      onPressed: _verificarCodigo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2D52EC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10),
                        ),
                        fixedSize: Size(300, 50),
                      ),
                      child: Text(
                              'Reclamar',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    this._buttonGroup(),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buttonGroup() {
    return ElevatedButton.icon(
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
      );
  }
}
