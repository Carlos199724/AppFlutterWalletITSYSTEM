import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../../../Service/apiProduct.dart';
import '../components/GradientBackground.dart';
import '../components/LoadingIndicator.dart';
import 'ProductView/DetailProduct.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool showMoreText = false;
  List<Map<String, dynamic>> newProducts = [];
  List<Map<String, dynamic>> moreProducts = [];
  List<Map<String, dynamic>> offerProducts = [];
  bool isLoading = true;

  late ScrollController _scrollController;
  int _currentPage = 0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Iniciar el temporizador para cambiar automáticamente las imágenes

    _fetchOfferProducts();
    _fetchNewProducts();
    _startAutoScroll();
    _fetchMoreProducts();
  }

  void _fetchOfferProducts() async {
    final httpService = HttpService();
    final products = await httpService.getProducts(1);

    setState(() {
      // Construir la lista de URLs de las imágenes de los productos
      offerProducts.clear();
      for (int i = 0; i < products!.length; i++) {
        offerProducts.add({
          'id': products[i]['id'],
          'name': products[i]['name'],
          'imagen_product': products[i]['imagen_product'],
          'description': products[i]['description'],
          'price_points': products[i]['price_points'],
        });
      }
    });
    isLoading = false;
  }

  void _fetchNewProducts() async {
    final httpService = HttpService();
    final products = await httpService.getProducts(0);

    setState(() {
      // Limpiar la lista de newProducts antes de agregar nuevos productos
      newProducts.clear();

      // Capturar solo los primeros 4 productos
      for (int i = 0; i < 4; i++) {
        // Verificar si hay productos disponibles
        if (i < products!.length) {
          // Agregar los detalles del producto a la lista de newProducts
          newProducts.add({
            'id': products[i]['id'],
            'name': products[i]['name'],
            'imagen_product': products[i]['imagen_product'],
            'description': products[i]['description'],
            'price_points': products[i]['price_points'],
          });
        }
      }
    });
    isLoading = false;
  }

  void _fetchMoreProducts() async {
    final httpService = HttpService();
    final moreproducts = await httpService.getProducts(0);

    setState(() {
      // Verificar si hay productos disponibles
      if (moreproducts != null && moreproducts.length > 4) {
        // Limpiar la lista de newProducts antes de agregar nuevos productos
        moreProducts.clear();

        // Capturar productos a partir del quinto elemento en adelante
        for (int i = 4; i < moreproducts.length; i++) {
          moreProducts.add({
            'id': moreproducts[i]['id'],
            'name': moreproducts[i]['name'],
            'imagen_product': moreproducts[i]['imagen_product'],
            'description': moreproducts[i]['description'],
            'price_points': moreproducts[i]['price_points'],
          });
        }
      }
    });

    // Marcar isLoading como falso después de cargar los productos
    isLoading = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    // Configurar un temporizador para cambiar automáticamente las imágenes
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage == offerProducts.length - 1) {
        _currentPage = 0;
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _currentPage++;
        _scrollController.animateTo(
          _currentPage * MediaQuery.of(context).size.width,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  void _scrollListener() {
    setState(() {
      _currentPage = (_scrollController.position.pixels /
              MediaQuery.of(context).size.width)
          .round();
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
              SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    'Productos',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC4C4C4),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),

              SizedBox(
                  height: 20), // Espacio entre textos y el campo de búsqueda
              /*TextField(
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
                  fillColor: Color.fromARGB(255, 37, 40, 46),
                  filled: true,
                ),
              ),*/
              /* Center(
                child: Text(
                  '¡Aun no esta disponible las compras en esta app!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 245, 160, 81),
                  ),
                ),
              ),*/
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(child: LoadingIndicator())
                  : Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                          if (offerProducts != null &&
                              offerProducts.isNotEmpty) ...[
                            Text(
                              'Super Ofertas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC4C4C4), // Color del texto
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _buildSquareCardProduct(),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                          
                            Text(
                              'Mas recientes',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC4C4C4), // Color del texto
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                        if (newProducts != null &&
                              newProducts.isNotEmpty) ...[
                                  _buildSquareCardList(),
                            ] else ...[
                          Center(
                              child: Text(
                                'No hay productos disponibles',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                              
                          ],
                          
                          SizedBox(
                            height: 15,
                          ),
                          if (moreProducts != null &&
                              moreProducts.isNotEmpty) ...[
                            Text(
                              'Más productos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC4C4C4),
                              ),
                            ),
                            _buildRectangularCardList(),
                          ]
                        ])))
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSquareCardProduct() {
    return Container(
      height: 130, // Nota: Altura de la lista de cartas cuadradas
      child: ListView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          children: [
            for (int i = 0; i < offerProducts.length; i++)
              // Determinar si esta es la imagen actual que se debe mostrar
              _buildSingleSquareCard(
                  offerProducts[i]['id'],
                  offerProducts[i]['imagen_product'],
                  offerProducts[i]['name'],
                  offerProducts[i]['description'],
                  offerProducts[i]['price_points']),
          ]),
    );
  }

  Widget _buildSquareCardList() {
    return Container(
      height: MediaQuery.of(context).size.width / 1.8,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < newProducts.length; i++)
            _buildSquareCard(
                newProducts[i]['id'],
                newProducts[i]['imagen_product'],
                newProducts[i]['name'],
                newProducts[i]['description'],
                newProducts[i]['price_points']),
        ],
      ),
    );
  }

  Widget _buildRectangularCardList() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap:
                  true, // Para ajustar automáticamente la altura del ListView
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (int i = 0; i < moreProducts.length; i++)
                  _buildRectangularCard(
                      moreProducts[i]['id'],
                      moreProducts[i]['imagen_product'],
                      moreProducts[i]['name'],
                      moreProducts[i]['description'],
                      moreProducts[i]['price_points']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleSquareCard(
      int id, String imageUrl, String title, String description, int price) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  DetailProduct(id, imageUrl, title, description, price)));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xFF232327), // Nota: Color de fondo de la carta
            borderRadius:
                BorderRadius.circular(10), // Nota: Borde redondeado de la carta
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https:/$imageUrl',
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSquareCard(
      int id, String imageUrl, String title, String description, int price) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  DetailProduct(id, imageUrl, title, description, price)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1.8,
          margin: EdgeInsets.symmetric(
              horizontal: 10), // Margen horizontal entre las cartas
          decoration: BoxDecoration(
            color: Color(0xFF232327), // Color de fondo de la carta
            borderRadius:
                BorderRadius.circular(10), // Borde redondeado de la carta
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la carta
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  'https:/$imageUrl',
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 130, // Altura de la imagen
                  fit: BoxFit.cover, // Ajuste de la imagen
                ),
              ),
              // Contenido de la carta (título y descripción)
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIconWithText(Icons.monetization_on,
                            price.toString(), Color(0xFFFFFFFF)),
                        Spacer(),
                        Icon(Icons.favorite,
                            color: Color(
                                0xFFFFFFFF)), // Cambiar el color del icono
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
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
      int id, String imageUrl, String title, String description, int price) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailProduct(id, imageUrl, title, description, price)));
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
                    'https:/$imageUrl',
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 110, // Altura de la imagen
                    fit: BoxFit.cover, // Ajuste de la imagen
                  ),
                ),
                SizedBox(width: 10), // Espacio entre la imagen y el texto
                // Título y descripción de la carta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título de la carta
                      Padding(
                        padding: const EdgeInsets.only(top: 17.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),),
                      SizedBox(
                          height:
                              10),
                      Text(
                        showMoreText
                            ? description
                            : (description.length > 100
                                ? description.substring(0, 50) + "..."
                                : description),
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFFC4C4C4)),
                      ),

                      SizedBox(height: 5),
                      Row(
                        children: [
                          _buildIconWithText(
                              Icons.monetization_on, '', Color(0xFFFFFFFF)),
                          Text(
                            price.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFC4C4C4),
                            ),
                          ),
                        ],
                      ),
                       SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
