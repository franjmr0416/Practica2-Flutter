class TareasModel {
  int? id;
  String? nomTarea;
  String? dscTarea;
  String? fechaEntrega;
  int? entregada;

  TareasModel(
      {this.id,
      this.nomTarea,
      this.dscTarea,
      this.fechaEntrega,
      this.entregada});

  //Map -> Object
  factory TareasModel.fromMap(Map<String, dynamic> map) {
    return TareasModel(
        id: map['idTarea'],
        nomTarea: map['nomTarea'],
        dscTarea: map['dscTarea'],
        fechaEntrega: map['fechaEntrega'],
        entregada: map['entregada']);
  }
  //Object -> Map
  Map<String, dynamic> toMap() {
    return {
      'idTarea': id,
      'nomTarea': nomTarea,
      'dscTarea': dscTarea,
      'fechaEntrega': fechaEntrega,
      'entregada': entregada
    };
  }
}
