// To parse this JSON data, do
//
//     final usuariosResponseModel = usuariosResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/src/models/usuario_model.dart';

UsuariosResponseModel usuariosResponseModelFromJson(String str) =>
    UsuariosResponseModel.fromJson(json.decode(str));

String usuariosResponseModelToJson(UsuariosResponseModel data) =>
    json.encode(data.toJson());

class UsuariosResponseModel {
  UsuariosResponseModel({
    this.ok,
    this.msg,
    this.usuarios,
  });

  bool ok;
  String msg;
  List<UsuarioModel> usuarios;

  factory UsuariosResponseModel.fromJson(Map<String, dynamic> json) =>
      UsuariosResponseModel(
          ok: json["ok"],
          msg: json["msg"],
          usuarios: List<UsuarioModel>.from(
              json["usuarios"].map((x) => UsuarioModel.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson()))
      };
}
