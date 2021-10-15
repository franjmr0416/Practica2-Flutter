import 'package:flutter/material.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/tareas_model.dart';
import 'package:practica2/src/screens/tarea_screen.dart';
import 'package:practica2/src/utils/color_settings.dart';

class ListaTareasScreen extends StatefulWidget {
  ListaTareasScreen({Key? key}) : super(key: key);

  @override
  _ListaTareasScreenState createState() => _ListaTareasScreenState();
}

class _ListaTareasScreenState extends State<ListaTareasScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
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
      body: TabBarView(controller: _tabController, children: <Widget>[
        _tareasPendientes(true),
        _tareasPendientes(false)
      ]),
    );
  }

  Widget _tareasPendientes(bool pendientes) {
    return FutureBuilder(
        future: (pendientes == true)
            ? _databaseHelper.getAllTareasPendientes()
            : _databaseHelper.getAllTareasCompletadas(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TareasModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error intente nuevamente'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return _listadoTareas(snapshot.data!);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        });
  }

  Widget _listadoTareas(List<TareasModel> tareas) {
    return ListView.builder(
      itemBuilder: (BuildContext context, index) {
        TareasModel tarea = tareas[index];
        var fechaEntrega = DateTime.parse(tarea.fechaEntrega!);
        var retraso = fechaEntrega.isBefore(DateTime.now());
        const iconoOK = Icon(
          Icons.book_rounded,
          color: Colors.green,
        );
        const iconoR = Icon(
          Icons.error,
          color: Colors.red,
        );

        return Card(
          child: Column(
            children: [
              ListTile(
                leading: (retraso && tarea.entregada != 1) ? iconoR : iconoOK,
                title: Text(tarea.nomTarea!),
                subtitle: (retraso && tarea.entregada != 1)
                    ? Text(
                        'RETRASADA fecha de entrega: ' +
                            tarea.fechaEntrega.toString().substring(0, 10),
                        style: TextStyle(color: Colors.red))
                    : Text('Fecha de entrega: ' +
                        tarea.fechaEntrega.toString().substring(0, 10)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirmación'),
                              content: Text('¿Borrar tarea?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _databaseHelper
                                          .delete(tarea.id!, "tareas")
                                          .then((noRows) {
                                        if (noRows > 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text('Tarea Eliminada')));
                                          setState(() {});
                                        }
                                      });
                                    },
                                    child: Text('Si')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'))
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.delete_outline),
                    label: Text('ELIMINAR'),
                    style: TextButton.styleFrom(primary: Colors.red),
                  ),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TareaScreen(
                                      tarea: tarea,
                                    )));
                      },
                      icon: Icon(Icons.edit),
                      label: Text('DETALLES'))
                ],
              )
            ],
          ),
        );
      },
      itemCount: tareas.length,
    );
  }
}
