import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practica2/src/utils/color_settings.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseHelper _databaseHelper;
  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerAPaterno = TextEditingController();
  TextEditingController _controllerAMaterno = TextEditingController();
  TextEditingController _controllerTelefono = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();

  final _keyForm = GlobalKey<FormState>();
  File? imagen;

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorSettings.colorPrimary,
          title: Text('Profile'),
        ),
        body: FutureBuilder(
          future: _databaseHelper.getUser(),
          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            var user = snapshot.hasData ? snapshot.data : null;
            if (user != null) {
              _controllerNombre.text = user.nombre!;
              _controllerAPaterno.text = user.aPaterno!;
              _controllerAMaterno.text = user.aMaterno!;
              _controllerEmail.text = user.email!;
              _controllerTelefono.text = user.telefono!;
            }
            return Center(
              child: SingleChildScrollView(
                child: Form(
                    key: _keyForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, top: 15, left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              seleccionarFuente(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              child: (user?.foto == null)
                                  ? Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 40,
                                    )
                                  : Image.file(
                                      File(user!.foto!),
                                      height: 80,
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, top: 15, left: 10, right: 10),
                          child: _nombreTextField(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, top: 15, left: 10, right: 10),
                          child: _aPaternoTextField(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, top: 15, left: 10, right: 10),
                          child: _aMaternoTextField(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, top: 15, left: 10, right: 10),
                          child: _emailTextField(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, top: 15, left: 10, right: 10),
                          child: _telefonoTextField(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 15, top: 15, left: 10, right: 10),
                          child: _botonActualizarInfo(user),
                        ),
                      ],
                    )),
              ),
            );
          },
        ));
  }

  Widget _nombreTextField() {
    return TextFormField(
      controller: _controllerNombre,
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

  Widget _aPaternoTextField() {
    return TextFormField(
      controller: _controllerAPaterno,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: "Primer apellido",
      ),
      onChanged: (value) {},
      validator: (value) {
        if (value?.isEmpty == true) {
          return "El campo es obligatorio";
        }
      },
    );
  }

  Widget _aMaternoTextField() {
    return TextFormField(
      controller: _controllerAMaterno,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: "Segundo Apellido",
      ),
      onChanged: (value) {},
      validator: (value) {
        if (value?.isEmpty == true) {
          return "El campo es obligatorio";
        }
      },
    );
  }

  Widget _telefonoTextField() {
    return TextFormField(
      controller: _controllerTelefono,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: "Número Telefónico",
      ),
      onChanged: (value) {},
      validator: (value) {
        if (value?.isEmpty == true) {
          return "El campo es obligatorio";
        } else if (_controllerTelefono.text.length != 10) {
          return "Telefono invalido";
        }
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: "Email",
      ),
      onChanged: (value) {},
      validator: (value) {
        if (value?.isEmpty == true) {
          return "El campo es obligatorio";
        }
      },
    );
  }

  Widget _botonActualizarInfo(UserModel? oldUser) {
    return ElevatedButton(
        onPressed: () {
          if (_keyForm.currentState?.validate() == false) return;
          UserModel user = UserModel(
              id: (oldUser?.id == null) ? null : oldUser?.id,
              nombre: _controllerNombre.text,
              aPaterno: _controllerAPaterno.text,
              aMaterno: _controllerAMaterno.text,
              telefono: _controllerTelefono.text,
              email: _controllerEmail.text,
              foto: (oldUser?.foto == null) ? null : oldUser?.foto);
          //print(user.toMap());
          _databaseHelper.upsert(user.toMap(), "user").then((value) {
            print(value);
            if (value > 0) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('La solicitud no se completo')));
            }
          });
        },
        child: Text("Actualizar Información"));
  }

  seleccionarFuente(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pickImagen(ImageSource.camera);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: Row(
                        children: [
                          Expanded(child: Text('Tomar fotografia')),
                          Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      pickImagen(ImageSource.gallery);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: Row(
                        children: [
                          Expanded(child: Text('Seleccionar foto de galeria')),
                          Icon(
                            Icons.image,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          Text(
                            ' Cancelar',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<String?> pickImagen(fuente) async {
    try {
      final imagen = await ImagePicker().pickImage(source: fuente);

      if (imagen == null) return null;

      var directory = await getExternalStorageDirectory();
      final name = path.basename(imagen.path);
      var ruta = path.join(directory!.path, name);
      imagen.saveTo(ruta);
      //print(ruta);
      UserModel user = UserModel(
          id: 1,
          nombre: _controllerNombre.text,
          aPaterno: _controllerAPaterno.text,
          aMaterno: _controllerAMaterno.text,
          telefono: _controllerTelefono.text,
          email: _controllerEmail.text,
          foto: ruta);

      _databaseHelper.upsert(user.toMap(), "user");
      setState(() {});
      return ruta;
    } on PlatformException catch (e) {
      print('Fallo al tomar imagen: $e');
    }
    return null;
  }
}
