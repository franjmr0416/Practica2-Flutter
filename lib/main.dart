import 'package:flutter/material.dart';
import 'package:practica2/src/screens/agregar_nota_screen.dart';
import 'package:practica2/src/screens/intenciones_screen.dart';
import 'package:practica2/src/screens/movies_screens/detail_screen.dart';
import 'package:practica2/src/screens/movies_screens/popular_screen.dart';
import 'package:practica2/src/screens/notas_screen.dart';
import 'package:practica2/src/screens/splash_screen.dart';
import 'package:practica2/src/screens/opcion1_screen.dart';
import 'package:practica2/src/screens/profile_screen.dart';
import 'package:practica2/src/screens/lista_tareas_screen.dart';
import 'package:practica2/src/screens/tarea_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/opc1': (BuildContext context) => Opcion1Screen(),
        '/intensiones': (BuildContext context) => IntencionesScreen(),
        '/notas': (BuildContext context) => NotasScreen(),
        '/agregar': (BuildContext context) => AgregarNotaScreen(),
        '/profile': (BuildContext context) => ProfileScreen(),
        '/movie': (BuildContext context) => PopularScreen(),
        '/tareas': (BuildContext context) => ListaTareasScreen(),
        '/tarea': (BuildContext context) => TareaScreen(),
        '/detail': (BuildContext context) => DetailScreen()
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
