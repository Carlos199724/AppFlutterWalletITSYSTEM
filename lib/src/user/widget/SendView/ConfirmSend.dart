import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Service/apiUser.dart';
import '../../components/errorView.dart';
import 'DetailsSend.dart';
import '../../components/GradientBackground.dart';

class ConfirmSend extends StatefulWidget {
  final String codigo;
  final String fullName;
  final int points;

  const ConfirmSend({
    Key? key,
    required this.codigo,
    required this.fullName,
    required this.points,
  }) : super(key: key);

  @override
  State<ConfirmSend> createState() => _ConfirmSendState();
}

class _ConfirmSendState extends State<ConfirmSend> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  String _errorMessage = '';
  int comision = 0;
  int total = 0;
  bool isTransferEnabled = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          color: Colors.grey)),
                  SizedBox(
                      width: 40), // Agrega espacio entre el icono y el texto
                  Text(
                    "Puntos a transferir",
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
              _buildHeader(),
              SizedBox(height: 20),
              _buildTransferSection(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Ingresar Monto",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.fullName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 80),
      ],
    );
  }

  Widget _buildTransferSection() {
    return Column(
      children: [
        Container(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Pts.",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 60),
              border: InputBorder.none,
            ),
            textAlign: TextAlign.center,

            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(color: Colors.white, fontSize: 60),
            onChanged: _onPointsChanged,
          ),
        ),
        SizedBox(height: 8),
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.orange),
          ),
        SizedBox(height: 80),
        _buildCommentSection(),
        SizedBox(height: 50),
        ElevatedButton(
          onPressed: isTransferEnabled || _isLoading
              ? _onTransferPressed
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2D52EC),
            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20),
                        ),
            minimumSize: Size(double.infinity, 50),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  'Transferir',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }

 Widget _buildCommentSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      TextField(
        controller: _commentController,
        decoration: InputDecoration(
          hintText: 'Agregar mensaje',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          counterStyle: TextStyle(color: Colors.white),
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        maxLength: 150,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        style: TextStyle(color: Colors.white), // Establece el color del texto
      ),
    ],
  );
}


  void _onPointsChanged(String value) {
    int? number = int.tryParse(value);

    if (number == null || number < 2 || number > widget.points) {
      setState(() {
        isTransferEnabled = false;
      });
    } else if (number == 1 && value.length == 1) {
      setState(() {
        _errorMessage = 'El monto no es correcto';
      });
    } else {
      setState(() {
        _errorMessage = '';
      });

      if (number >= 1 && number <= 100) {
        comision = 1;
      } else if (number > 100 && number <= 500) {
        comision = 3;
      } else if (number > 500) {
        comision = 5;
      }

      setState(() {
        total = number - comision;
        isTransferEnabled = true;
      });
    }
  }

  void _onTransferPressed() async {
    setState(() {
      _isLoading = true;
    });
    final data = await HttpService().transactionPoints(
      widget.codigo,
      total,
      comment: _commentController.text,
    );

    if (data != null) {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DetailsSend(
            public_key: widget.codigo,
            fullName: widget.fullName,
            points: total,
            comision: comision,
            total_points: _controller.text,
            comment: _commentController.text,
            id: data['id'],
            date: data['created_at'],
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'La transacción falló';
      });
      ErrorViewSnackBar(context, _errorMessage);
    }
  }
}
