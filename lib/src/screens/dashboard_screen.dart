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
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    )
                    /*Image.network(
                      'https://image.flaticon.com/icons/png/512/147/147144.png'),*/
                    ),
                decoration: BoxDecoration(color: ColorSettings.colorPrimary),
                onDetailsPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
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
              ),
              ListTile(
                title: Text('Notas'),
                subtitle: Text('CRUD Notas'),
                leading: Icon(Icons.phone_android),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/notas');
                },
              ),
              ListTile(
                title: Text('Movies'),
                subtitle: Text('Prueba API REST'),
                leading: Icon(Icons.movie),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/movie');
                },
              ),
              ListTile(
                title: Text('Tareas'),
                subtitle: Text('Agenda de tareas'),
                leading: Icon(Icons.event_note),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/tareas');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
