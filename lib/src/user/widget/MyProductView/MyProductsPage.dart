import 'package:billetera_digital/Service/apiProduct.dart';
import 'package:billetera_digital/src/user/components/GradientBackground.dart';
import 'package:billetera_digital/src/user/widget/MyProductView/MyProductTicket.dart';
import 'package:flutter/material.dart';
import '../../components/LoadingIndicator.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  bool showMoreText = false;
  List<Map<String, dynamic>> buysMyProducts = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Iniciar el temporizador para cambiar automáticamente las imágenes
    _fetchMoreMyProducts();
  }

  void _fetchMoreMyProducts() async {
    final httpService = HttpService();
    final moreproducts = await httpService.getMyProducts();

    setState(() {
      // Verificar si hay productos disponibles
      if (moreproducts != null) {
        // Limpiar la lista de newProducts antes de agregar nuevos productos
        buysMyProducts.clear();

        // Capturar productos a partir del quinto elemento en adelante
        for (int i = 0; i < moreproducts.length; i++) {
          buysMyProducts.add({
            'id': moreproducts[i]['id'],
            'created_at': moreproducts[i]['created_at'],
            'imagen_product': moreproducts[i]['productos']['imagen_product'],
            'name': moreproducts[i]['productos']['name'],
            'code': moreproducts[i]['productos']['code'],
            'price_points': moreproducts[i]['productos']['price_points'],
            'updated_at': moreproducts[i]['updated_at'],
            'status': moreproducts[i]['status'],
          });
        }
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
                  SizedBox(height: 50), // Espacio entre textos
                  Row(
                    children: [
                      Text(
                        'Mis Productos',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          20), // Espacio entre textos y el campo de búsqueda
                  /* TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFC4C4C4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 37, 40, 46)),
                      ),
                      fillColor: Color.fromARGB(
                          255, 37, 40, 46), // Color de fondo del campo de texto
                      filled:
                          true, // Establecer como lleno para que el color de fondo sea visible
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),*/
                  Text(
                    'Mas recientes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC4C4C4), // Color del texto
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? Center(child: LoadingIndicator())
                      : Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                              if (buysMyProducts != null &&
                                  buysMyProducts.isNotEmpty) ...[
                                _buildRectangularCardList(),
                                SizedBox(height: 15),
                              ] else ...[
                                Center(
                                  child: Text(
                                    'Sin productos',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ]

                              // Lista de cartas rectangulares
                            ])))
                ],
              ))),
    ));
  }

  Widget _buildRectangularCardList() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (int i = 0; i < buysMyProducts.length; i++)
                  _buildRectangularCard(
                    buysMyProducts[i]['id'],
                    buysMyProducts[i]['created_at'],
                    buysMyProducts[i]['imagen_product'],
                    buysMyProducts[i]['name'],
                    buysMyProducts[i]['code'],
                    buysMyProducts[i]['price_points'],
                    buysMyProducts[i]['status'],
                    buysMyProducts[i]['updated_at'],
                  ),
              ],
            ),
          ],
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

  Widget _buildRectangularCard(
      int id,
      String created_at,
      String imagen_product,
      String name,
      String code,
      int price_points,
      String status,
      String updated_at) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MyProductTicket(
                id, created_at, name, code, price_points, status)));
      },
      child: Container(
        width: 200, // Ancho de la carta rectangular
        margin: EdgeInsets.symmetric(
            vertical: 10), // Margen horizontal entre las cartas
        decoration: BoxDecoration(
          color: Color(0xFF232327), // Color de fondo de la carta
          borderRadius:
              BorderRadius.circular(10), // Borde redondeado de la carta
        ),
        child: Padding(
  padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen y título de la carta
            Row(
              children: [
                // Imagen de la carta
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    'https:/$imagen_product',
                    width: MediaQuery.of(context).size.width /
                        2.5, // Ancho de la imagen
                    height: 110, // Altura de la imagen
                    fit: BoxFit.cover, // Ajuste de la imagen
                  ),
                ),
                SizedBox(width: 10),
                // Título y descripción de la carta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título de la carta
                      Padding(
                        padding: const EdgeInsets.only(top: 17.0),
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'Código:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            code,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                      // Enlace "Ver más" o "Ver menos"
                      Row(

                        children: [
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2D52EC),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              _buildIconWithText(
                                  Icons.monetization_on, '', Color(0xFFFFFFFF)),
                              Text(
                                '${price_points}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFC4C4C4),
                                ),
                              ),

                              SizedBox(height: 10),
                           
                            ],
                          ),
                          //_buildIconWithText(Icons.monetization_on, '', Color(0xFFFFFFFF)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
