import 'package:flutter/material.dart';
import '../../components/GradientBackground.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _Help();
}

class _Help extends State<Help> {
  List<QuestionAnswer> faqs = [
    QuestionAnswer(question:'¿Cómo puedo cambiar mi contraseña?', answer:'Para cambiar tu contraseña, ve a la sección de Configuración en tu perfil y selecciona la opción de Cambiar Contraseña. A continuación, sigue las instrucciones para actualizar tu contraseña.',),
    QuestionAnswer(question: '¿Cómo puedo recuperar mi cuenta si olvidé mi contraseña?', answer:'Si olvidaste tu contraseña, puedes restablecerla siguiendo los pasos de recuperación de contraseña. Ve a la página de inicio de sesión y selecciona "¿Olvidaste tu contraseña?". Luego, sigue las instrucciones para restablecer tu contraseña.',),
    QuestionAnswer(question:'¿Cómo puedo canjear un cupón?', answer:'Para canjear un cupón, ve a la sección de Cupones en la aplicación y selecciona el cupón que deseas canjear. Luego, sigue las instrucciones para completar el proceso de canje, que puede incluir ingresar un código promocional o hacer clic en un enlace especial.',),
    QuestionAnswer(question:'¿Qué debo hacer si mi cupón no funciona?', answer:'Si encuentras problemas al intentar canjear un cupón, primero verifica que estás ingresando el código correcto o siguiendo los pasos indicados. Si el problema persiste, ponte en contacto con nuestro equipo de soporte para obtener ayuda adicional.',),
    QuestionAnswer(question:'¿Cómo puedo obtener más información sobre los productos disponibles para canjear?', answer:'Puedes explorar los productos disponibles en la sección de Catálogo de la aplicación. Allí encontrarás una lista de todos los productos, incluidos los cursos SAP y otros artículos que puedes canjear con tus cupones.',),
    QuestionAnswer(question:'¿Cuánto tiempo tengo para canjear un cupón una vez que lo he adquirido?', answer:'El tiempo para canjear un cupón puede variar según las políticas de la promoción o el producto. Por lo general, encontrarás esta información especificada en los términos y condiciones del cupón. Es importante revisar esta información antes de adquirir un cupón para asegurarte de que puedas canjearlo dentro del plazo establecido.',),
    QuestionAnswer(question:'¿Puedo transferir un cupón a otra persona?', answer:'En la mayoría de los casos, los cupones son personales y no se pueden transferir a otras personas. Sin embargo, algunas promociones pueden permitir la transferencia de cupones. Verifica los términos y condiciones de la promoción específica para obtener información sobre la transferibilidad de los cupones.',),
  ];

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
                      SizedBox(width: 30), // Agrega espacio entre el icono y el texto
                      Text(
                        "Ayuda",
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
                Center(
                  child: Text(
                    "Preguntas frecuentes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: faqs.map((faq) {
                          return ExpansionTile(
                            title: Text(
                              faq.question,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  faq.answer,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                            ],
                          );
                        }).toList(),
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
}

class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({required this.question, required this.answer});
}
