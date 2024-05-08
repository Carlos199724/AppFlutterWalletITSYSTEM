import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/GradientBackground.dart';
import '../../components/LoadingIndicator.dart';
import '../../../../Service/apiCoupon.dart';

class ExchangeCoupons extends StatefulWidget {
  const ExchangeCoupons({Key? key}) : super(key: key);

  @override
  State<ExchangeCoupons> createState() => _ExchangeCoupons();
}

class _ExchangeCoupons extends State<ExchangeCoupons> {
  List<dynamic> userData = []; // Lista para almacenar los datos de los cupones del usuario
  List<Map<String, dynamic>> data1 = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCouponData();
  }

  Future<void> fetchCouponData() async {
    final data2 = await HttpService().getCoupons();
    setState(() {
      data1.clear();
      for (int i = 0; i < data2.length; i++) {
        data1.add({
          'name':data2[i]['coupons']['name'],
          'coupon_code':data2[i]['coupons']['coupon_code'],
          'expiration_date':data2[i]['coupons']['expiration_date'],
          'description':data2[i]['coupons']['description'],
          'points':data2[i]['coupons']['points'],
        });
      }
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
                        "Cupones canjeados",
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
                Row(
                    children: [
                      Text(
                        'Mis cupones',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Text(
                    'Mas recientes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC4C4C4), // Color del texto
                    ),
                  ),
                SizedBox(height: 10),

                isLoading
                ? Center(child: LoadingIndicator())
                :Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          
                          if(data1.isNotEmpty) ...[
                            for (int i = 0; i < data1.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Card(
                                  //elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Color(0xFF232327),
                                  child: ListTile(
                                    leading: Icon(Icons.local_offer),
                                    title: Text(
                                      '${data1[i]['name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 5),
                                        
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Código: ${data1[i]['coupon_code']}', style: TextStyle(color: Colors.white)),
                                        ),
                                        SizedBox(height: 5),

                                        Row(
                                          children: [
                                            Text(
                                              '${data1[i]['description']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                _buildIconWithText(Icons.monetization_on, '', Color(0xFFFFFFFF)),
                                                Text(
                                                  '${data1[i]['points']}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFFC4C4C4),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //trailing: Icon(Icons.local_offer), // Cambiar a un icono más adecuado
                                    onTap: () {
                                      // Lógica para manejar el tap en el cupón 1
                                    },
                                  ),
                                ),
                              ),
                          ] else ...[
                            Center(
                              child: Text(
                                'Sin cupones',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ]

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

  Widget _buildIconWithText(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color), // Usar el color proporcionado para el icono
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
              color: color), // Usar el color proporcionado para el texto
        ),
      ],
    );
  }
}
