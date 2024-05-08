import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/GradientBackground.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditions();
}

class _TermsConditions extends State<TermsConditions> {
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
                      "Términos y condiciones",
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
              SizedBox(height: 15),
              Center(
                child: Text(
                  "¡Lee atentamente!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 19),
                    _customText(Colors.white, 17, "Introducción"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Agradecemos tu preferencia por nuestra aplicación ITS wallet.  Estos términos y condiciones constituyen un acuerdo legal entre ITSYSTEMS PERÚ SAC y los usuarios de la aplicación. Al acceder y utilizar la aplicación, usted acepta estar sujeto a estos términos y condiciones, así como a todas las leyes y regulaciones aplicables. Por favor, lea detenidamente este documento antes de utilizar la aplicación. Si no está de acuerdo con alguno de estos términos, le recomendamos que no utilice la aplicación."),
                    SizedBox(height: 19),
                    _customText(Colors.white, 17, "Registro de la Cuenta"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Para utilizar nuestra aplicación, es necesario registrarse y crear una cuenta. La información proporcionada durante el registro debe ser precisa y actualizada en todo momento. Eres responsable de mantener la confidencialidad de tu cuenta y de todas las actividades que ocurran bajo tu cuenta."),
                    SizedBox(height: 19),
                    _customText(Colors.white, 17, "Uso de Cupones y Productos"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Los cupones son de un solo uso y no son transferibles. Tienen una fecha de caducidad, después de la cual no se pueden canjear. El canje está sujeto a la disponibilidad del curso o producto. Nos reservamos el derecho de modificar o retirar cualquier curso o producto sin previo aviso. Los productos canjeados no son reembolsables ni intercambiables."),
                    SizedBox(height: 19),
                    _customText(Colors.white, 17, "Conducta del Usuario"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Al utilizar nuestra aplicación, aceptas no realizar actividades dañinas, ilegales o que violen los derechos de terceros. No puedes interferir ni interrumpir el funcionamiento de la aplicación. Nos reservamos el derecho de suspender o cancelar tu cuenta si violas estos términos y condiciones."),
                    SizedBox(height: 19),
                    _customText(Colors.white, 17, "Propiedad Intelectual"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Todos los derechos de propiedad intelectual sobre la aplicación, incluidos textos, gráficos, logotipos y software, son propiedad nuestra o de nuestros licenciantes. No puedes reproducir, distribuir o utilizar los contenidos de la aplicación sin nuestro consentimiento por escrito."),
                    SizedBox(height: 19),
                    _customText(
                        Colors.white, 17, "Limitación de Responsabilidad"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "No nos hacemos responsables de ningún daño directo, indirecto, incidental, especial, consecuente o punitivo derivado del uso de nuestra aplicación. No garantizamos la disponibilidad ininterrumpida o libre de errores de la aplicación."),
                    SizedBox(height: 19),
                    _customText(Colors.white, 17,
                        "Modificaciones de los Términos y Condiciones"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Las modificaciones entrarán en vigencia inmediatamente después de su publicación en la aplicación. Te notificaremos sobre cualquier cambio en los términos y condiciones."),
                    SizedBox(height: 19),
                    _customText(Colors.white, 17, "Ley Aplicable"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Estos términos y condiciones se rigen por las leyes del país en el que estamos registrados."),
                    SizedBox(height: 19),
                    _customText(Colors.white, 17, "Contacto"),
                    SizedBox(height: 19),
                    _customText(Colors.grey, 14,
                        "Si tienes alguna pregunta o inquietud sobre estos términos y condiciones, contáctanos en info@itsystems.pe. Al utilizar nuestra aplicación, aceptas estos términos y condiciones en su totalidad. Si no estás de acuerdo con alguno de estos términos, por favor, no utilices nuestra aplicación."),
                    SizedBox(height: 30),
                  ],
                ),
              ),
           )) ],
          ),
        ),
      ),
    ));
  }

  Widget _customText(Color color, double fontSize, String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
