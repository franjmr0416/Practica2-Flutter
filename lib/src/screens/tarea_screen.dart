import 'package:flutter/material.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/tareas_model.dart';
import 'package:practica2/src/utils/color_settings.dart';

class TareaScreen extends StatefulWidget {
  TareasModel? tarea;
  TareaScreen({Key? key, this.tarea}) : super(key: key);

  @override
  _TareaScreenState createState() => _TareaScreenState();
}

class _TareaScreenState extends State<TareaScreen> {
  late DatabaseHelper _databaseHelper;
  TextEditingController _controllerNomTarea = TextEditingController();
  TextEditingController _controllerDscTarea = TextEditingController();
  bool completada = false;
  int estadoSwitch = 0;
  var _currentSelectDate = DateTime.now();

  @override
  void initState() {
    if (widget.tarea != null) {
      _controllerNomTarea.text = widget.tarea!.nomTarea!;
      _controllerDscTarea.text = widget.tarea!.dscTarea!;
      (widget.tarea!.entregada! == 0) ? completada = false : completada = true;
      _currentSelectDate = DateTime.parse(widget.tarea!.fechaEntrega!);
    }
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea'),
        backgroundColor: ColorSettings.colorPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
                child: _nomTareaInput(),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
                child: _dscTareaInput(),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
                child: _selectDataTime(),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
                child: _completadaInput(),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
                child: _botonUpsert(widget.tarea),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _nomTareaInput() {
    return TextFormField(
      controller: _controllerNomTarea,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: "Nombre",
      ),
      onChanged: (value) {},
      validator: (value) {
        if (value?.isEmpty == true) {
          return "El campo es obligatorio";
        }
      },
    );
  }

  Widget _dscTareaInput() {
    return TextFormField(
      controller: _controllerDscTarea,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: "Descripción",
      ),
      onChanged: (value) {},
      validator: (value) {
        if (value?.isEmpty == true) {
          return "El campo es obligatorio";
        }
      },
    );
  }

  Future<DateTime?> _dateInput() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
      helpText: 'Fecha de vencimiento',
    );
  }

  void callDatePicker() async {
    var selectedDate = await _dateInput();
    if (selectedDate != null) {
      setState(() {
        _currentSelectDate = selectedDate;
      });
    }
  }

  Widget _selectDataTime() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(bottom: 10, top: 0, left: 0, right: 10),
                child: Text('Fecha de vencimiento'))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                onPressed: callDatePicker,
                icon: Icon(Icons.date_range_outlined),
                label: Text(_currentSelectDate.toString().substring(0, 10))),
          ],
        )
      ],
    );
  }

  Widget _completadaInput() {
    return SwitchListTile(
      title: Text('Marcar como completada'),
      secondary: Icon(Icons.check_circle_outline_outlined),
      value: completada,
      onChanged: (value) {
        if (completada == false) {
          completada = true;
          estadoSwitch = 1;
        } else {
          completada = false;
          estadoSwitch = 0;
        }
        setState(() {});
        print('cambio switch');
        print(completada);
        print(estadoSwitch);
      },
      activeColor: ColorSettings.colorPrimary,
    );
  }

  Widget _botonUpsert(TareasModel? oldTarea) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(primary: ColorSettings.colorPrimary),
      onPressed: () {
        //armado de modelo
        TareasModel tarea = TareasModel(
            id: (oldTarea?.id == null) ? null : oldTarea?.id,
            nomTarea: _controllerNomTarea.text,
            dscTarea: _controllerDscTarea.text,
            fechaEntrega: _currentSelectDate.toString(),
            entregada: (oldTarea?.entregada == null)
                ? 0
                : estadoSwitch); //BUG NO SE ACTUALIZA ENTREGADO
        print(tarea.toMap());
        //insercion a la bd
        _databaseHelper.upsert(tarea.toMap(), "tareas").then((value) {
          print(value);
          if (value > 0) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('La solicitud no se completo')));
          }
        });
      },
      icon: Icon(Icons.save_rounded),
      label: Text('Guardar'),
    );
  }
}
