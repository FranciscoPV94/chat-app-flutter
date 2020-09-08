class UsuarioModel {
  bool online;
  String email;
  String nombre;
  String uid;

  UsuarioModel({this.online, this.email, this.nombre, this.uid});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
      };
}
