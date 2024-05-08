import 'package:flutter/material.dart';
import 'package:billetera_digital/src/user/widget/ConfigPage.dart';
import 'package:billetera_digital/src/user/widget/ProductPage.dart';
import 'package:billetera_digital/src/user/widget/MyProductView/MyProductsPage.dart';
import 'package:billetera_digital/src/user/widget/DashHomePage.dart';
import 'package:billetera_digital/src/user/components/pageUpdated.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({Key? key}) : super(key: key);

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  late Widget selectedWidget;
  int _selectedIndex = 0;

  final List<Widget> _widgets = [
    DashHomePage(),
    ProductPage(),
    MyProductsPage(),
    ConfigPage(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.store,
    Icons.shopping_basket,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    selectedWidget = _widgets[_selectedIndex];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 4 ) {
      showUpdateDialog(context);
    } else{
      setState(() {
        selectedWidget = _widgets[_selectedIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C0D0E),
      body: selectedWidget,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 37, 40, 46),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _widgets.length,
            (index) => IconButton(
              icon: Icon(
                _icons[index],
                color: _selectedIndex == index ? Color(0xFF2D52EC) : Colors.white,
              ),
              onPressed: () => _onItemTapped(index),
            ),
          ),
        ),
      ),
    );
  }
}
