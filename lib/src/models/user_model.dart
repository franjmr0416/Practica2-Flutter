class UserModel {
  int? id;
  String? nombre;
  String? aPaterno;
  String? aMaterno;
  String? email;
  String? telefono;
  String? foto;

  UserModel(
      {this.id,
      this.nombre,
      this.aPaterno,
      this.aMaterno,
      this.email,
      this.telefono,
      this.foto});

  //Map -> Object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        nombre: map['nombre'],
        aPaterno: map['aPaterno'],
        aMaterno: map['aMaterno'],
        email: map['email'],
        telefono: map['telefono'],
        foto: map['foto']);
  }
  //Object -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'aPaterno': aPaterno,
      'aMaterno': aMaterno,
      'email': email,
      'telefono': telefono,
      'foto': foto
    };
  }
}
