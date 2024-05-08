import 'package:flutter/material.dart';
import '../../../../Service/apiAuthenticate.dart';
import 'RegisterCode.dart';
import 'package:flutter/services.dart';
import '../../components/errorView.dart';
import '../../components/GradientBackground.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? _selectedValue;
  bool datosCompletos = false;
  bool _formEnabled = false;
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerNombre = TextEditingController();
  final TextEditingController controllerApellido = TextEditingController();
  final TextEditingController controllerCellphone = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  bool _isLoading = false;
  bool _isnext = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
       child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(
                    top: 20.0), // Agrega espacio en la parte superior
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_new_outlined,
                            color: Colors.white)),
                    SizedBox(
                        width: 10), // Agrega espacio entre el icono y el texto
                    Text(
                      "Paso 1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // Espacio entre los textos
              Center(
                child: Text(
                  "Siente inmediatamente la facilidad de realizar transacciones con solo registrarse",
                  textAlign: TextAlign.center, // Alinear al centro
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Color del segundo texto
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(                   
                        hintText: 'Selecione Doc.Indentidad',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 37, 40, 46),
                        prefixIcon: Icon(Icons.person, color: Colors.white,),
                      ),
                      dropdownColor: Color.fromARGB(255, 37, 40, 46),
                      value: _selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedValue = newValue;
                          _formEnabled = true;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'dni',
                          child: Text('DNI', style: TextStyle(color: Colors.white),),
                          
                        ),
                        DropdownMenuItem(
                          value: 'pass',
                          child: Text('Pasaporte', style: TextStyle(color: Colors.white),),
                        ),
                        DropdownMenuItem(
                          value: 'ce',
                          child: Text('Carnet de extrangería', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: controller,
                        enabled: _formEnabled,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Ingrese N° de documento",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Color.fromARGB(
                              255, 37, 40, 46), // Cambia el color de fondo aquí
                          filled: true,
                          prefixIcon: Icon(Icons.badge_outlined, color: Colors.white,),
                          //errorText: 'Debe contener solo números y tener 8 dígitos',
                          errorStyle: TextStyle(
                              color: Colors.yellow), // Mensaje de restricción
                        ),
                        inputFormatters: [
                          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Solo permite números
                          LengthLimitingTextInputFormatter(
                              _selectedValue == 'dni'
                                  ? 8
                                  : 12), // Limita a 8 caracteres
                        ],
                        /*keyboardType: TextInputType.number, // Especifica que el teclado debe ser numérico*/
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF2D52EC),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            fixedSize: MaterialStateProperty.all<Size>(
                              Size(58, 58),
                            ),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15), // Radio del borde
                                        side: BorderSide(
                                          color: Color(
                                              0xFF2D52EC), // Color del borde
                                          width: 2, // Ancho del borde
                                        ))),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 20), // Espacio horizontal
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading =
                                        true; // Activa el indicador de carga
                                  });
                                  final tipoDocumento = _selectedValue ?? '';
                                  final numeroDocumento = controller.text;

                                  if (numeroDocumento.isNotEmpty) {
                                    // Llamar a la API y manejar la respuesta
                                    final dniData = await HttpService()
                                        .fetchDniData(
                                            numeroDocumento, tipoDocumento);
                                    final body = dniData?['body'];
                                    if (dniData != null) {
                                      if (dniData['statusCode'] == 404) {
                                        // Si la respuesta indica un error 400, muestra una alerta
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'El número de documento no existe.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isLoading =
                                                        false; // Desactiva el indicador de carga
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        String preNombres = body['preNombres'];
                                        String apePaterno = body['apePaterno'];
                                        String apeMaterno = body['apeMaterno'];

                                        String capitalizeFirstLetter(String s) {
                                          if (s == null || s.isEmpty) return '';
                                          List<String> words = s.split(' ');
                                          List<String> capitalizedWords =
                                              words.map((word) {
                                            if (word.isEmpty) return '';
                                            return word[0].toUpperCase() +
                                                word.substring(1).toLowerCase();
                                          }).toList();
                                          return capitalizedWords.join(' ');
                                        }

                                        String preNombresCapitalized =
                                            capitalizeFirstLetter(preNombres);
                                        String apePaternoCapitalized =
                                            capitalizeFirstLetter(apePaterno);
                                        String apeMaternoCapitalized =
                                            capitalizeFirstLetter(apeMaterno);

                                        setState(() {
                                          controllerNombre.text =
                                              preNombresCapitalized;
                                          controllerApellido.text =
                                              '${apePaternoCapitalized} ${apeMaternoCapitalized}';
                                          _isLoading =
                                              false; // Desactiva el indicador de carga
                                          _isnext = true;
                                        });
                                      }
                                    } else {
                                      // Manejar el caso cuando la respuesta es nula
                                      print(
                                          'Error: La respuesta de la API es nula.');
                                    }
                                  } else {
                                    // Manejar el caso cuando el número de documento está vacío
                                    setState(() {
                                      _isLoading = false;
                                      _errorMessage =
                                          'Por favor ingrese un número de documento válido.';
                                    });
                                    ErrorViewSnackBar(context, _errorMessage);
                                    return;
                                  }
                                },
                          child: _isLoading
                              ? SizedBox(
                                  // Si está cargando, muestra el indicador de carga
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3, // Ancho de la línea
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white), // Color del indicador
                                  ),
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.find_in_page_outlined,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: controllerNombre,
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        enabled: false,
                        hintText:
                            controllerNombre.text.isEmpty ? "Nombre" : null,
                            hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(
                            255, 37, 40, 46), // Cambia el color de fondo aquí
                        filled: true,
                        prefixIcon: Icon(Icons.person, color: Colors.white,),
                      ),
                    ),

                    // Agrega más widgets al Column según sea necesario
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: controllerApellido,
                      style: TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        enabled: false,
                        hintText:
                            controllerApellido.text.isEmpty ? "Apellido" : null,
                            hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(
                            255, 37, 40, 46), // Cambia el color de fondo aquí
                        filled: true,
                        prefixIcon: Icon(Icons.person, color: Colors.white,),
                      ),
                    ),

                    // Agrega más widgets al Column según sea necesario
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: controllerCellphone,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Ingrese número telefónico",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(
                            255, 37, 40, 46), // Cambia el color de fondo aquí
                        filled: true,
                        prefixIcon: Icon(Icons.phone, color: Colors.white,),
                      ),
                    ),

                    // Agrega más widgets al Column según sea necesario
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: controllerEmail,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          // Actualiza el estado de _isnext cuando cambia el texto del campo de correo electrónico
                          _isnext = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Ingrese correo electrónico",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromARGB(
                            255, 37, 40, 46), // Cambia el color de fondo aquí
                        filled: true,
                        prefixIcon: Icon(Icons.attach_email_outlined, color: Colors.white,),
                      ),
                    ),

                    // Agrega más widgets al Column según sea necesario
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Align(
                alignment: Alignment
                    .bottomCenter, // Alinear hacia abajo y a la derecha
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .end, // Alinear al final (borde derecho)
                    children: [
                      Container(
                        width: 20, // Ancho fijo para el icono
                        height: 100,
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors
                              .transparent, // Establecer el color transparente
                          size: 30,
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: IconButton(
                          icon: Icon(Icons.keyboard_control_rounded,
                              color: Color(0xFF2D52EC), size: 40),
                          onPressed: () {},
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 40, // Ancho fijo para el icono
                        height: 100,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF2D52EC), size: 30),
                          onPressed: _isnext && controllerEmail.text.isNotEmpty
                              ? () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => RegisterCode(
                                      numeroDocumento: controller.text,
                                      nombre: controllerNombre.text,
                                      apellido: controllerApellido.text,
                                      telefono: controllerCellphone.text,
                                      correo: controllerEmail.text,
                                    ),
                                  ));
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  //],//
//);//
}
