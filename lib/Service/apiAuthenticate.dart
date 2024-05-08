import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  final String _sunatUrl = 'https://api.sunat.dev';

  static String urlits = '';

  HttpService() {
  urlits = 'https://wallet.itscloud.store';
  //urlits = 'http://127.0.0.1:8000';
  }

  Future<Map<String, dynamic>?> fetchDniData(
      String nrodocument, String type) async {
    const tokenSunat =
        'dHWfg8GCrHFA09i4LCFs6nTApSHJrzaRMorr9UDGM7swBFDOEX34K3tZE3veuecK';
    final url = '$_sunatUrl/$type/$nrodocument?apikey=$tokenSunat';

    final response = await http.get(Uri.parse(url));

    try {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (e) {
      print('Error al decodificar la respuesta JSON: $e');
      return null;
    }
  }

    //--------------API REGISTER------------------------//

  Future<bool> registerUser(
    String numeroDocumento,
    String nombre,
    String apellido,
    String telefono,
    String correo,
    String password, {
    String? code,
  }) async {
    final url =
        '$urlits/users/register'; // URL de la API de registro, ajusta según sea necesario

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'num_document': numeroDocumento,
          'full_name': '$nombre $apellido',
          'phone': telefono,
          'email': correo,
          'password': password,
          if (code != null) 'reference_code': code,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Registro exitoso
        return true;
      } else {
        // Manejar otros códigos de estado si es necesario
        print('Respuesta del servidor: ${response.body}');
        return false;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return false;
    }
  }

  //--------------API VERIFY REFERENCE CODE------------------------//

  Future<bool> verifyReferenceCode(String referenceCode) async {
    final url =
        '$urlits/users/verifycode?reference_code=$referenceCode'; // URL de la API para verificar el código de referencia

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Código de referencia válido
        return true;
      } else {
        // Código de referencia inválido
        return false;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error de conexión: $e');
      return false;
    }
  }

  //--------------API LOGIN------------------------//

  Future<bool> loginUser(String document, String password) async {
    final url = '$urlits/users/login'; // URL de la API de inicio de sesión
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'num_document': document,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        // Inicio de sesión exitoso
        // Guardar el token de acceso en SharedPreferences
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', jsonResponse['access_token']);
        prefs.setString('refresh_token', jsonResponse['refresh_token']);
        prefs.setInt('id', jsonResponse['id']);
        prefs.setString('full_name', jsonResponse['full_name']);
        prefs.setString('num_document', jsonResponse['num_document']);
        prefs.setString('email', jsonResponse['email']);
        prefs.setInt('points', jsonResponse['points']);
        prefs.setString('public_key', jsonResponse['public_key']);
        prefs.setString('private_key', jsonResponse['private_key']);
        //prefs.setString('address', jsonResponse['address']);
        prefs.setBool('user_admin', jsonResponse['user_admin']);
        prefs.setString('qr_code_path', jsonResponse['qr_code_path']);
        prefs.setString('reference_code', jsonResponse['reference_code']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Manejar errores de conexión
      print({'Error de conexión: $e'});
      return false;
    }
  }

  //-------------CHANGE PASSWORD--------------//

  Future<Map<String, dynamic>?> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    final url = '$urlits/users/change-password'; // URL de la API para cambiar la contraseña

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken', // Incluir token de acceso en la cabecera
        },
        body: json.encode({
          'old_password': currentPassword,
          'new_password1': newPassword,
          'new_password2': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Contraseña cambiada exitosamente
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
        //return true;
      } else if (response.statusCode == 400) {
        // Convierte la respuesta JSON en un objeto Dart
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse;
      } else {
        // Manejar otros códigos de estado si es necesario
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print('B');
        print(response.statusCode);
        return jsonResponse;
      }
    } catch (e) {
      // Manejar errores de conexión
      print('Error en la solicitud HTTP: $e');
      return null;
    }
  }


}
