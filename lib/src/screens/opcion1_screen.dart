import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:practica2/src/utils/color_settings.dart';

class Opcion1Screen extends StatefulWidget {
  Opcion1Screen({Key? key}) : super(key: key);

  @override
  _Opcion1ScreenState createState() => _Opcion1ScreenState();
}

class _Opcion1ScreenState extends State<Opcion1Screen> {
  double montoConsumo = 0.0;
  double propina = 0.0;
  double total = 0.0;
  TextEditingController txtConsumoCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextFormField txtConsumo = TextFormField(
      controller: txtConsumoCont,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Consumo \$',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
    );
    ElevatedButton btnCalcular = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: ColorSettings.colorButton),
      onPressed: () {
        //montoConsumo = double.tryParse());
        var input = txtConsumoCont.value.text;

        if (input.isEmpty ||
            double.tryParse(input) == null ||
            double.tryParse(input) == 0.0) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Ingrese una cantidad valida'),
                );
              });
        } else {
          montoConsumo = double.tryParse(input)!;
          propina = (montoConsumo / 100) * 15;
          total = montoConsumo + propina;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text('Total a pagar'),
                    content: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Consumo: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                          TableCell(
                              child: Text('\$' + montoConsumo.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  )))
                        ]),
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Propina: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                          TableCell(
                              child: Text('\$' + propina.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  )))
                        ]),
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'TOTAL: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          TableCell(
                              child: Text(
                            '\$' + total.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorSettings.colorPrimary),
                          ))
                        ])
                      ],
                    ));
              });
        }

        setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Icon(Icons.paid), Text('Ver total a pagar')],
      ),
    );
    Text etiqueta = Text(
      'Ingresa el monto de tu consumo',
      style: TextStyle(
        color: ColorSettings.colorPrimary,
        fontSize: 18,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Calcular total a pagar'),
        backgroundColor: ColorSettings.colorPrimary,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/coffee1.jpg'), fit: BoxFit.fill)),
          ),
          Card(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                padding: EdgeInsets.all(8.0),
                shrinkWrap: true,
                children: [
                  etiqueta,
                  SizedBox(
                    height: 10,
                  ),
                  txtConsumo,
                  SizedBox(
                    height: 5,
                  ),
                  btnCalcular
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
