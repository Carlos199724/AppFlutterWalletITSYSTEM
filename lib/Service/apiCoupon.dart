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

//--------------API GET COUPONS------------------------//

  Future<List<dynamic>> getCoupons() async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    // Verificar si se obtuvo el token de acceso
    if (accessToken == null) {
      // Manejar caso en el que no se obtuvo el token de acceso
      print('No se pudo obtener el token de acceso.');
      return [];
    }

    // Construir la URL con el parámetro id
    Uri uri = Uri.parse('$urlits/exchanges_coupons/exchange?users=$userId');

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
        print('Error en la solicitudA HTTP: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitudB HTTP: $e');
      return [];
    }
  }

}