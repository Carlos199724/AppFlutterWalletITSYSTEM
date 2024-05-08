import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/GradientBackground.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui'; // Necesario para importar ByteData
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

class RecibirView extends StatefulWidget {
  const RecibirView({super.key});

  @override
  State<RecibirView> createState() => _RecibirViewState();
}

class _RecibirViewState extends State<RecibirView> {
  late Map<String, String?> userData = {};
  bool _isLoading = false;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('full_name');
    String? numDocument = prefs.getString('num_document');
    String? publicKey = prefs.getString('public_key');
    String? qrCodePath = prefs.getString('qr_code_path');
    String? referenceCode = prefs.getString('reference_code');

    // Dividir el nombre completo en una lista de palabras
    List<String>? fullNameParts = fullName?.split(' ');

    // Tomar solo los tres primeros nombres
    String? firstName = fullNameParts != null && fullNameParts.length >= 3
    ? fullNameParts[0] + ' ' + fullNameParts[2]
    : fullNameParts != null && fullNameParts.length >= 2
        ? fullNameParts[0] + ' ' + fullNameParts[1]
        : fullNameParts?.first;

    setState(() {
      userData = {
        'full_name': firstName,
        'num_document': numDocument,
        'public_key': publicKey,
        'qr_code_path': qrCodePath,
        'reference_code': referenceCode,
      };
    });
  }

  Future<void> _compartir() async {
    Uint8List? pngBytes = await _capturePng();
    if (pngBytes != null) {
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/captura.png';
      File(path).writeAsBytesSync(pngBytes);
      await Share.shareFiles([path], subject: 'Captura de pantalla');
    }
  }

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        print('Error: No se pudo convertir la imagen a byte data');
        return null;
      }
      return byteData.buffer.asUint8List();
    } catch (e) {
      print('Error: $e');
      return null;
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
              _buildHeader(),
              SizedBox(height: 40),
              _buildtitleITSYSTEMS(),
              SizedBox(height: 25),
              _buildCardITSYSTEMS(),
              SizedBox(height: 25),
              _buildButtonShare(),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildHeader() {
    return Container(
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
            "Recibir",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildtitleITSYSTEMS() {
    return Center(
      child: Text(
        "¡Escanea el código QR!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCardITSYSTEMS() {
    return RepaintBoundary( // esto es para captura solo el card al compartir
      key: globalKey,  // esto es para captura solo el card al compartir
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromRGBO(37, 40, 47, 1.0),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),

            if (userData['qr_code_path'] != null)
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Color.fromRGBO(37, 40, 47, 1.0), // Color del borde
                      width: 20, // Grosor del borde
                    ),
                    // Colocar la imagen como fondo
                    image: DecorationImage(
                      image: NetworkImage('https://' + userData['qr_code_path']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ),

          SizedBox(height: 25),
          Divider(),
          SizedBox(height: 25),
          _buildInfoRow("Dirección:", userData['public_key'] ?? ''),
          SizedBox(height: 5),
          _buildInfoRow("Usuario:", userData['full_name'] ?? ''),
          SizedBox(height: 5),
          _buildInfoRow("Estado:", "Activo"),
          SizedBox(height: 5),
          _buildInfoRow("Nro Documento:", userData['num_document'] ?? ''),
          SizedBox(height: 5),
          _buildInfoRow("Código de referencia:", userData['reference_code'] ?? ''),
          SizedBox(height: 25),
        ],
      ),
    ),
  );
}

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            
            letterSpacing: 2.0,
          ),
        ),
        Text(
          value ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonShare() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _compartir,
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
              'Compartir',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}
