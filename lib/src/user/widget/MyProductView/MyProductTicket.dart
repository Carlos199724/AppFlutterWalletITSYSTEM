import 'dart:io';
import 'package:billetera_digital/src/user/components/GradientBackground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProductTicket extends StatefulWidget {
  final int id;
  final String created_at;
  final String name;
  final String code;
  final int price_points;
  final String status;
  MyProductTicket(this.id, this.created_at, this.name, this.code,
      this.price_points, this.status);

  @override
  State<MyProductTicket> createState() => _MyProductTicketState();
}

class _MyProductTicketState extends State<MyProductTicket> {
  late Map<String, String?> userData = {};

  GlobalKey globalKey = GlobalKey();
  Future<void> _requestPermissions() async {
    // Solicitar permisos de almacenamiento
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('full_name');
    String? numDocument = prefs.getString('num_document');

    setState(() {
      userData = {
        'full_name': fullName,
        'num_document': numDocument,
      };
    });
  }

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      if (boundary == null) {
        print('Error: No se pudo encontrar el RenderRepaintBoundary');
        return null;
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      if (image == null) {
        print('Error: No se pudo capturar la imagen del RenderRepaintBoundary');
        return null;
      }
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
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

  Future<void> _showDownloadSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('¡Descarga Exitosa!')),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/dowload.png', // Ruta de la imagen de éxito
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 10), // Espaciador entre la imagen y el texto
                Center(
                    child: Text(
                        'Descarga completada, revisa tu galeria por favor.')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFF2D52EC),
                ), // Color del texto del botón
                side: MaterialStateProperty.all<BorderSide>(BorderSide(
                  color: Color(0xFF2D52EC),
                )), // Color del borde del botón
              ),
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> dateTimeParts = widget.created_at.split('T');
    String date = dateTimeParts[0]; // Obtener la fecha
    String formattedDate =
        DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    String time = dateTimeParts[1].split('.')[0];
    String formattedTime = DateFormat('hh:mm a')
        .format(DateTime.parse('2024-03-21 $time'))
        .toLowerCase();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    key: globalKey,
                    child: TicketWidget(
  width: MediaQuery.of(context).size.width * 0.9,
  height: 480,
  isCornerRounded: true,
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10), // Agregar espacio al borde izquierdo
                child: Container(
                  width: 120,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFF2D52EC),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Ticket ITS wallet',
                      style: TextStyle(
                        color: Color(0xFF2D52EC),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'ITSYSTEMS',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('assets/its.jpg'),
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 16), // Agregar espacio al borde izquierdo
          child: Text(
            'Datos generales',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 16), // Agregar espacio al borde izquierdo
          child: Text(
            'Nro. Ticket: 00${widget.id}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Text(
            'Cod. Producto: ${widget.code}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              ticketDetailsWidget('Producto', widget.name, '', ''),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 38),
                child: ticketDetailsWidget(
                  'Fecha',
                  formattedDate,
                  'Hora',
                  formattedTime,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 58),
                child: ticketDetailsWidget(
                  'Estado',
                  widget.status,
                  'Monto',
                  '${widget.price_points}',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 0),
                child: ticketDetailsWidget(
                  'Nombre',
                  userData['full_name'] ?? '',
                  'Nro Documento',
                  userData['num_document'] ?? '',
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
                ],
              ),
            ),
          ),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //padding: const EdgeInsets.only(bottom: 150.0),//
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Color(0xFF2D52EC), width: 3.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      minimumSize: Size(175.0, 0),
                      backgroundColor: Color(0xFF2D52EC),
                    ),
                    onPressed: () async {
                      // Solicitar permisos antes de intentar guardar la imagen
                      await _requestPermissions();
                  
                      Uint8List? pngBytes = await _capturePng();
                      if (pngBytes != null) {
                        final directory = await getExternalStorageDirectory();
                        if (directory != null) {
                          String filePath = '${directory.path}/ticket_widget.png';
                          File imgFile = File(filePath);
                          await imgFile.writeAsBytes(pngBytes);
                          await ImageGallerySaver.saveFile(filePath);
                          print('TicketWidget imagen guardada en la galería.');
                          _showDownloadSuccessDialog(context);
                        } else {
                          print(
                              'Error: No se pudo obtener el directorio de almacenamiento externo.');
                        }
                      } else {
                        print('Error al capturar la imagen del widget.');
                      }
                    },
                    child: Text(
                      'Descargar',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10), // Espaciador entre los botones
      Expanded(
        child: Container(
          margin: EdgeInsets.only(right: 20.0), // Añade espacio entre el botón y el borde izquierdo
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color(0xFF2D52EC), width: 3.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0), // Ajusta el padding vertical
              backgroundColor: Color(0xFFFFFFFF),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Volver',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D52EC),
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget ticketDetailsWidget(
  String firstTitle, 
  String formattedDate, 
  String secondTitle, 
  String secondDesc
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              secondTitle,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                secondDesc,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
  }

