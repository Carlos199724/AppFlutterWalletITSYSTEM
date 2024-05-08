import 'package:billetera_digital/src/user/widget/MyProductView/MyProductTicket.dart';
import 'package:flutter/material.dart';
import '../../../../Service/apiUser.dart' as HttpService1;
import '../../../../Service/apiProduct.dart' as HttpService2;
import 'package:flutter/services.dart';
import '../../components/errorView.dart';
import '../../components/ProcessingDialog.dart';

class DetailProduct extends StatefulWidget {
  final int id;
  final String imageUrl;
  final String title;
  final String description;
  final int price;

  DetailProduct(
      this.id, this.imageUrl, this.title, this.description, this.price);

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int points = 0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPoints();
  }

  Future<void> fetchPoints() async {
    final data = await HttpService1.HttpService().getUserData();

    if (data != null) {
      setState(() {
        points = data['points'] ?? 0;
      });
    }
  }

  Future<void> _onPurchaseProduct() async {
    setState(() {
      _errorMessage = '';
    });
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible:
          false, // Para que no se pueda cerrar haciendo clic fuera del diálogo
      builder: (BuildContext context) {
        return ProcessingDialog();
      },
    );

    try {
      dynamic data =
          await HttpService2.HttpService().exchangeProduct(widget.id);

      if (data != null && data is Map<String, dynamic>) {
        if (data.containsKey('error')) {
          // Si hay un error en la respuesta, mostrar el mensaje de error
          setState(() {
            _errorMessage = data['error'];
          });
          ErrorViewSnackBar(context, _errorMessage);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MyProductTicket(
                data['id'],
                data['created_at'],
                widget.title,
                data['code_product'],       
                widget.price, 
                'En proceso',

              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Ocurrió un error al procesar la respuesta.';
        });
        ErrorViewSnackBar(context, _errorMessage);
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de red';
      });
      ErrorViewSnackBar(context, _errorMessage);
      Navigator.pop(context);
    }
  }

  Future<void> prueba() async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Para que no se pueda cerrar haciendo clic fuera del diálogo
      builder: (BuildContext context) {
        return ProcessingDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Confirmación de la compra',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: Image.asset(
                          'assets/alerta.png', // Ruta de la imagen del anuncio
                          height: 70.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Producto:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Costo',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  '${widget.price}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Saldo disponible:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  '${points}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Color(0xFF2D52EC),
                                width: 2.0), // Color y grosor del borde
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          minimumSize: Size(350.0, 0),
                          backgroundColor: Color(0xFF2D52EC),
                        ),
                        onPressed: points < widget.price
                            ? null // Desactiva el botón si el saldo disponible es menor al precio
                            : _onPurchaseProduct,
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: points < widget.price
                                ? Colors.grey
                                : Color(0xFFFFFFFF),
                          ),
                        ),
                      )),
                      SizedBox(height: 10.0),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Color(0xFF2D52EC), width: 2.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            minimumSize: Size(350.0, 0),
                            backgroundColor: Color(0xFFFFFFFF),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D52EC),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Chip(
              backgroundColor: Color(0xFF2D52EC),
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: constraints.maxWidth * 0.3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              label: Text(
                "Comprar",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: widget.imageUrl,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https:/${widget.imageUrl}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40.0,
                  right: 15.0,
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 37, 40, 46),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0, // Coloca el contenedor en la parte inferior
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.price.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                                width:
                                    5), // Ajusta el espacio entre el texto y el icono según tus preferencias
                            Icon(
                              Icons
                                  .monetization_on, // Cambia este icono según lo que necesites
                              color: Colors.white,
                              size:
                                  30.0, // Cambia el tamaño del icono según tus preferencias
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    buildItemDesc(context, "Descripción"),
                    buildItemRow(context, widget.description),
                    //buildItemView(context, "4.1 | 3000+ Vendidos"),//
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildItemRow(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              softWrap:
                  true, // Añadido para manejar el desbordamiento del texto
            ),
          ),
        ],
      ),
    );
  }

  Container buildItemView(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.star, // Puedes cambiar este icono por el que desees
            color: Color(0xFF2D52EC),
            size: 24.0,
          ),
          Icon(
            Icons.star, // Puedes cambiar este icono por el que desees
            color: Color(0xFF2D52EC),
            size: 24.0,
          ),
          Icon(
            Icons.star, // Puedes cambiar este icono por el que desees
            color: Color(0xFF2D52EC),
            size: 24.0,
          ),
          Icon(
            Icons.star, // Puedes cambiar este icono por el que desees
            color: Color(0xFF2D52EC),
            size: 24.0,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Container buildItemDesc(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: <Widget>[
          Text(
            text,
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
}
