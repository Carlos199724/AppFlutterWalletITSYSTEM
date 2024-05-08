import 'package:flutter/material.dart';
import '../../../Service/apiUser.dart';
import 'ExchangeCoupon/ExchangeCoupon.dart';
import 'SendView/SendView.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../components/GradientBackground.dart';
import 'ViewReceive/ViewReceive.dart';

class DashHomePage extends StatefulWidget {
  const DashHomePage({Key? key});

  @override
  State<DashHomePage> createState() => _DashHomePageState();
}

class _DashHomePageState extends State<DashHomePage> {
  int points = 0;
  List<dynamic> transactions = [];
  int countTransaction = 20;

  @override
  void initState() {
    super.initState();
    fetchPoints();
    fetchTransactions();
  }

  Future<void> fetchPoints() async {
    final data = await HttpService().getUserData();

    if (data != null) {
      setState(() {
        points = data['points'] ?? 0;
      });
    }
  }

  Future<void> fetchTransactions() async {
    final data = await HttpService().getTransactionFilter(countTransaction);

    if (data != null) {
      setState(() {
        transactions = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 50),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 42,
                  backgroundImage: AssetImage('assets/itsys.png'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Mis Puntos",
                textAlign: TextAlign.center, // Alinear al centro
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white, // Color del texto principal
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centrar elementos horizontalmente
                children: [
                  Icon(
                    Icons.monetization_on, // El icono que deseas utilizar
                    color: Colors.white, // Color del icono
                    size: 25, // Tamaño del icono
                  ),
                  SizedBox(width: 8), // Espacio entre el texto y el icono
                  Text(
                    "$points",
                    textAlign: TextAlign.center, // Alinear al centro
                    style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.white, // Color del subtítulo
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SendView(points: points)));
                    },
                    child: _buildDashboardCard(
                      Icons.send,
                      'Enviar',
                      Color(0xFF2D52EC),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecibirView()));
                    },
                    child: _buildDashboardCard(
                      Icons.qr_code,
                      'Recibir',
                      Color(0xFF2D52EC),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExchangeCoupon()));
                    },
                    child: _buildDashboardCard(
                      Icons.local_offer,
                      'Canjear',
                      Color(0xFF2D52EC),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Transacciones",
                    style: TextStyle(
                      color: Color(0xFF2D52EC),
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(), // Espacio flexible que se expandirá para llenar el espacio disponible
                  Text(
                    "Puntos",
                    style: TextStyle(
                      color: Color(0xFF2D52EC),
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (transactions.isEmpty) // Verificar si la lista de transacciones está vacía
                      Center(
                        child: Text(
                          'No hay transacciones',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      for (var transaction in transactions)
                        _buildTransactionItem(transaction),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 40,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(transaction) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

    String description = capitalize(transaction['description']);
    List<String> dateTimeParts = transaction['created_at'].split('T');
    String date = dateTimeParts[0];
    String formattedDate =
        DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    String time = dateTimeParts[1].split('.')[0];
    String formattedTime = DateFormat('hh:mm a')
        .format(DateTime.parse('2024-03-21 $time'))
        .toLowerCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.6, // Ancho deseado
            child: Text(
              '$description',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$formattedDate - $formattedTime',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                "${transaction['points']}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: transaction['points'] > 0 ? Colors.white : Colors.red,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 0.1,
            height: 10,
          ),
        ],
      ),
    );
  }
}
