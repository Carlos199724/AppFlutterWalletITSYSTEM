import 'package:billetera_digital/src/user/widget/LoginPage.dart';
import 'package:flutter/material.dart';
import '../components/GradientBackground.dart';
import './SettingsView/ChangePassword.dart';
import './SettingsView/TermsConditions.dart';
import './SettingsView/ReportProblem.dart';
import './SettingsView/HelpFAQ.dart';
import './SettingsView/AccountData.dart';
import './SettingsView/ExchangeCoupons.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 50), // Reduje la cantidad de espacio superior
              Row(
                children: [
                  Text(
                    'Ajustes de perfil',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC4C4C4), // Color del texto
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Espacio entre textos
              Text(
                'Cuenta',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF), // Color del texto
                ),
              ),
              SizedBox(height: 10), // Espacio entre textos
              Container(
                padding: EdgeInsets.all(10), // Espaciado interno del contenedor
                decoration: BoxDecoration(
                  color: Color(0xFF232327), // Color de fondo del contenedor
                  borderRadius: BorderRadius.circular(
                      10), // Borde redondeado del contenedor
                ),
                child: Column(
                  children: [
                    _buildSettings('account_circle', 'Cuenta', pageBuilder: () => AccountData()),
                    SizedBox(height: 20), // Espacio entre textos
                    _buildSettings('discount', 'Cupones canjeados', pageBuilder: () => ExchangeCoupons()),
                  ],
                ),
              ),
              SizedBox(height: 20), // Espacio entre textos
              Text(
                'Ayuda e información',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF), // Color del texto
                ),
              ),
              SizedBox(height: 10), // Espacio entre textos
              Container(
                padding: EdgeInsets.all(10), // Espaciado interno del contenedor
                decoration: BoxDecoration(
                  color: Color(0xFF232327), // Color de fondo del contenedor
                  borderRadius: BorderRadius.circular(
                      10), // Borde redondeado del contenedor
                ),
                child: Column(
                  children: [
                    _buildSettings('flag_rounded', 'Informar de un problema', pageBuilder: () => ReportProblem()),
                    SizedBox(height: 10),
                    _buildSettings('forum', 'Ayuda', pageBuilder: () => Help()),
                    SizedBox(height: 10),
                    _buildSettings('gpp_maybe_rounded', 'Términos y condiciones', pageBuilder: () => TermsConditions()),
                  ],
                ),
              ),
              SizedBox(height: 20), // Espacio entre textos
              Text(
                'Inicio Sessión',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF), // Color del texto
                ),
              ),
              SizedBox(height: 10), // Espacio entre textos
              Container(
                padding: EdgeInsets.all(10), // Espaciado interno del contenedor
                decoration: BoxDecoration(
                  color: Color(0xFF232327), // Color de fondo del contenedor
                  borderRadius: BorderRadius.circular(
                      10), // Borde redondeado del contenedor
                ),
                child: Column(
                  children: [
                    _buildSettings('lock_reset_sharp', 'Cambiar contraseña', pageBuilder: () => ChangePassword()),
                    SizedBox(height: 10), // Espacio entre textos
                    InkWell(
                      onTap: () {
                        // Mostrar alerta
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Cerrar Sesión'),
                              content: Text(
                                  '¿Estás seguro de que quieres cerrar sesión?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cerrar la alerta
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginUser()),
                                    );
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.white), // Icono
                          SizedBox(
                              width: 10), // Espacio entre el icono y el texto
                          Expanded(
                            // Expandir el texto para ocupar todo el espacio disponible
                            child: Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF), // Color del texto
                              ),
                            ),
                          ),
                          Spacer(), // Ajustar espacio entre el texto y el icono
                          Icon(Icons.chevron_right_outlined,
                              color: Colors.white), // Segundo icono
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Text(
                  'v2.0.4(000000006)',
                  style: TextStyle(
                    color: Color(0xFFC4C4C4), // Color del texto
                    fontSize: 11, // Tamaño del texto
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // Un mapa que asocia nombres de iconos con los íconos reales
  final Map<String, IconData> iconMap = {
    'flag_rounded': Icons.flag_rounded,
    'gpp_maybe_rounded': Icons.gpp_maybe_rounded,
    'lock_reset_sharp': Icons.lock_reset_sharp,
    'forum': Icons.forum,
    'account_circle': Icons.account_circle,
    'discount': Icons.discount,
  };

  Widget _buildSettings(String iconName, String title, {required Widget Function() pageBuilder}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageBuilder()),
        );
      },
      child: Row(
        children: [
          Icon(iconMap[iconName], color: Colors.white),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
          Spacer(),
          Icon(Icons.chevron_right_outlined, color: Colors.white),
        ],
      ),
    );
  }
}
