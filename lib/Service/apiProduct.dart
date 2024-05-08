import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static String urlits = '';

  HttpService() {
    urlits = 'https://wallet.itscloud.store';
    //urlits = 'http://127.0.0.1:8000';
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

//--------------API GET PRODUCTS------------------------//

  Future<List<dynamic>?> getProducts(int? oferta) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();
    int? active = 1;

    // Construir la URL con los parámetros de la consulta
    Uri uri =
        Uri.parse('$urlits/products/product?active=$active&oferta=$oferta');

    try {
      // Realizar la solicitud HTTP con el token de acceso
      final response = await http.get(
        uri,
        headers: {
          'Authorization':
              'Bearer $accessToken', // Incluir el token de acceso en el encabezado
          'Content-Type': 'application/json',
        },
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Decodificar el cuerpo de la respuesta JSON
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        // Manejar caso de error en la respuesta
        print('Error en la solicitud HTTP: ${uri}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }

//--------------API EXCHANGES PRODUCTS------------------------//

  Future<Map<String, dynamic>?> exchangeProduct(
      int productId) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    int? countProduct = 1;
    // Construir el cuerpo de la solicitud
    Map<String, dynamic> body = {
      'user_id': userId,
      'product_id': productId,
      'count_product': countProduct,
    };

    try {
      // Realizar la solicitud HTTP POST
      final response = await http.post(
        Uri.parse('$urlits/exchanges_products/exchange_product'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 404) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 400) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else {
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP POST: $e');
    }
  }
  //--------------API GET MYPRODUCTS------------------------//
  
  Future<List<dynamic>> getMyProducts() async {
  try {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    
    // Verificar si el token de acceso es nulo
    if (accessToken == null) {
      throw Exception('El token de acceso es nulo');
    }
    
    // Construir la URL con los parámetros de la consulta
    Uri uri = Uri.parse('$urlits/exchanges_products/exchange_product?user_id=$userId');

    // Realizar la solicitud HTTP con el token de acceso
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken', // Incluir el token de acceso en el encabezado
        'Content-Type': 'application/json',
      },
    );

    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200) {
      // Decodificar el cuerpo de la respuesta JSON
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      // Manejar caso de error en la respuesta
      print('Error en la solicitud HTTP: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    // Manejar errores de conexión u otros errores
    print('Error en la solicitud HTTP: $e');
    return [];
  }
}
}
