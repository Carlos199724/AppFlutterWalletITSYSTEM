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

  //--------------API GET POINTS------------------------//

  Future<Map<String, dynamic>?> getUserData() async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    // Verificar si se obtuvo el token de acceso
    if (accessToken == null) {
      // Manejar caso en el que no se obtuvo el token de acceso
      print('No se pudo obtener el token de acceso.');
      return null;
    }

    // Construir la URL con el parámetro id
    Uri uri = Uri.parse('$urlits/users/getusers?id=$userId');

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
        Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        // Manejar caso de error en la respuesta
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }

  //--------------API GET TRANSACTION HISTORY------------------------//

  Future<List<dynamic>?> getTransactionFilter(int countTransaction) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    // Construir la URL con los parámetros de la consulta
    Uri uri = Uri.parse(
        '$urlits/transaction/get_filter?user_id=$userId&count_transaction=$countTransaction');

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
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }

  //--------------API VERIFY PUBLIC KEY------------------------//

  Future<Map<String, dynamic>?> verifyPublicKey(String publicKey) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    // Verificar si se obtuvo el token de acceso
    if (accessToken == null) {
      // Manejar caso en el que no se obtuvo el token de acceso
      print('No se pudo obtener el token de acceso.');
      return null;
    }

    // Construir la URL con los parámetros de la consulta
    Uri uri = Uri.parse(
        '$urlits/users/verifykey?public_key=$publicKey&user_id=$userId');

    try {
      // Realizar la solicitud HTTP con el token de acceso
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 404) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        // Manejar caso de otros códigos de estado
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }

  //--------------API TRANSACTION POINTS------------------------//

  Future<Map<String, dynamic>?> transactionPoints(
      String receiverPublicKey, int amount,
      {String? comment}) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? senderPrivateKey = prefs.getString('private_key');

    // Verificar si se obtuvo el token de acceso
    if (accessToken == null) {
      // Manejar caso en el que no se obtuvo el token de acceso
      print('No se pudo obtener el token de acceso.');
      return null;
    }

    // Construir el cuerpo de la solicitud
    Map<String, dynamic> body = {
      'sender_private_key': senderPrivateKey,
      'receiver_public_key': receiverPublicKey,
      'amount': amount,
    };
    if (comment != null && comment.isNotEmpty) {
      body['comment'] = comment;
    }

    // Realizar la solicitud POST
    Uri uri = Uri.parse('$urlits/transaction/transaction_points');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      } else {
        // Manejar caso de otros códigos de estado
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }

    //--------------API EXCHANGES COUPONS------------------------//

  Future<Map<String, dynamic>?> exchangeCoupon(String couponCode) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    // Verificar si se obtuvo el token de acceso
    if (accessToken == null) {
      // Manejar caso en el que no se obtuvo el token de acceso
      print('No se pudo obtener el token de acceso.');
      return null;
    }

    // Construir la URL de la API
    Uri uri = Uri.parse('$urlits/exchanges_coupons/exchange');

    try {
      // Construir el cuerpo de la solicitud
      Map<String, dynamic> body = {'coupon_code': couponCode , 'users': userId};

      // Realizar la solicitud HTTP con el token de acceso
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 404) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 400) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else {
        // Manejar caso de otros códigos de estado
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }

  //--------------API REPORT A PROBLEM------------------------//

  Future<Map<String, dynamic>?> reportProblem(String problemType, String descripTion, String eviDence) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    // Verificar si se obtuvo el token de acceso
    if (accessToken == null) {
      // Manejar caso en el que no se obtuvo el token de acceso
      print('No se pudo obtener el token de acceso.');
      return null;
    }

    // Construir la URL con el parámetro id
    Uri uri = Uri.parse('$urlits/bugReport/create');

    try {
      // Construir el cuerpo de la solicitud
      Map<String, dynamic> body = {'problema': problemType, 'descripcion': descripTion, 'evidencia': eviDence, 'usuario_id': userId};

      // Realizar la solicitud HTTP con el token de acceso
      final response = await http.post(
        uri,
        headers: {
          'Authorization':
              'Bearer $accessToken', // Incluir el token de acceso en el encabezado
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 201) {
        // Decodificar el cuerpo de la respuesta JSON
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 400) {
        // Manejar caso de error en la respuesta
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 403) {
        // Manejar caso de error en la respuesta
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 500) {
        // Manejar caso de error en la respuesta
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else {
        // Manejar caso de error en la respuesta
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }

  //--------------API UPDATE USER DATA------------------------//
  Future<Map<String, dynamic>?> updateUserData(String eEmail, String pPhone, String aAddress, String postalCode) async {
    // Obtener el token de acceso
    String? accessToken = await getAccessToken();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    // Verificar si se obtuvo el token de acceso
    if (accessToken == null) {
      // Manejar caso en el que no se obtuvo el token de acceso
      print('No se pudo obtener el token de acceso.');
      return null;
    }

    // Construir la URL con el parámetro id
    Uri uri = Uri.parse('$urlits/users/update-data/$userId');

    try {
      // Construir el cuerpo de la solicitud
      Map<String, dynamic> body = {'email': eEmail, 'phone': pPhone, 'address': aAddress, 'postal_code': postalCode};

      // Realizar la solicitud HTTP con el token de acceso
      final response = await http.put(
        uri,
        headers: {
          'Authorization':
              'Bearer $accessToken', // Incluir el token de acceso en el encabezado
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Decodificar el cuerpo de la respuesta JSON
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 405) {
        // Manejar caso de error en la respuesta
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 403) {
        // Manejar caso de error en la respuesta
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else if (response.statusCode == 500) {
        // Manejar caso de error en la respuesta
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else {
        // Manejar caso de error en la respuesta
        print('Error en la solicitudA HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Manejar errores de conexión u otros errores
      print('Error en la solicitudE HTTP: $e');
      return null;
    }
  }
}
