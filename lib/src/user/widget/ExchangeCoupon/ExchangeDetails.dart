import 'package:billetera_digital/src/user/components/MenuPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/GradientBackground.dart';

class DetailsExchange extends StatefulWidget {
  final int points;
  final String date;
  //final String prueba;
  final String couponName;
  final String couponCode;
  final String couponDescription;
  final int couponPoints;
  final String userFullName;
  const DetailsExchange({
    Key? key,
    required this.points,
    required this.couponName,
    required this.date,
    required this.couponCode,
    required this.couponDescription,
    required this.couponPoints,
    required this.userFullName,
  }) : super(key: key);

  @override
  State<DetailsExchange> createState() => _DetailsExchangeState();
}

class _DetailsExchangeState extends State<DetailsExchange> {

  late Map<String, String?> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {

  List<String>? fullNameParts = widget.userFullName?.split(' ');

  String? firstName = fullNameParts != null && fullNameParts.length >= 3
    ? fullNameParts[0] + ' ' + fullNameParts[2]
    : fullNameParts != null && fullNameParts.length >= 2
        ? fullNameParts[0] + ' ' + fullNameParts[1]
        : fullNameParts?.first;

    setState(() {
      userData = {
        'full_name': firstName,
      };
    });
    
  }
  @override
  Widget build(BuildContext context) {
    List<String> dateTimeParts = widget.date.split('T');
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 37, 40, 46),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(50), // Para hacer un círculo
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2D52EC)
                                .withOpacity(0.9), // Color del resplandor azul
                            spreadRadius:
                                5, // El radio de propagación del resplandor
                            blurRadius:
                                10, // El radio de desenfoque del resplandor
                            offset: Offset(0,
                                0), // La posición del resplandor (0, 0) significa que está centrado
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 50,
                        color: Colors.white, // Color del icono (blanco)
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Canjeo exitoso',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D52EC),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tu canjeo ha sido exitoso',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${widget.couponPoints}',
                      style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalle de transacción',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          Divider(
                            // Aquí se agrega el Divider
                            color: Colors
                                .grey, // Puedes ajustar el color de la línea según tus preferencias
                            thickness:
                                1, // Puedes ajustar el grosor de la línea según tus preferencias
                            height:
                                20, // Puedes ajustar la altura entre el texto y la línea según tus preferencias
                          ),
                          SizedBox(height: 10),
                          _buildDetailRow('Fecha', formattedDate),
                          _buildDetailRow('Hora', formattedTime),
                          _buildDetailRow('Cupón', widget.couponName),
                          _buildDetailRow('Código de cupón', widget.couponCode),
                          _buildDetailRow(
                              'Descripción', widget.couponDescription),
                          _buildDetailRow('Canjeado por', '${userData['full_name']}'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => MenuPrincipal()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D52EC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Inicio',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Alinea los elementos al principio y al final de la fila
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFFFFFFFF).withOpacity(0.72),
            ),
            
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
