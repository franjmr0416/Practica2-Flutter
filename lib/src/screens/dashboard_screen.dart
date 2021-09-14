import 'package:flutter/material.dart';
import 'package:practica2/src/utils/color_settings.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: ColorSettings.colorPrimary,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Morales Rico Francisco Javier'),
                accountEmail: Text('17030659@itcelaya.edu.mx'),
                currentAccountPicture: CircleAvatar(
                  child: Image.network(
                      'https://image.flaticon.com/icons/png/512/147/147144.png'),
                ),
                decoration: BoxDecoration(color: ColorSettings.colorPrimary),
              ),
              ListTile(
                title: Text('Propinas'),
                subtitle: Text('Calculadora de propinas'),
                leading: Icon(Icons.monetization_on_outlined),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/opc1');
                },
              ),
              ListTile(
                title: Text('Intensiones'),
                subtitle: Text('itensiones implicitas'),
                leading: Icon(Icons.phone_android),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/intensiones');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
