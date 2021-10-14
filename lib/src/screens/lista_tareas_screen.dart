import 'package:flutter/material.dart';
import 'package:practica2/src/utils/color_settings.dart';

class ListaTareasScreen extends StatefulWidget {
  ListaTareasScreen({Key? key}) : super(key: key);

  @override
  _ListaTareasScreenState createState() => _ListaTareasScreenState();
}

class _ListaTareasScreenState extends State<ListaTareasScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas'),
        backgroundColor: ColorSettings.colorPrimary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tarea').whenComplete(() {
                  setState(() {});
                });
              },
              icon: Icon(Icons.add))
        ],
        bottom: TabBar(controller: _tabController, tabs: const <Widget>[
          Tab(
            text: 'Pendientes',
          ),
          Tab(
            text: 'Completadas',
          )
        ]),
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[Text('tab1'), Text('tab2')]),
    );
  }
}
