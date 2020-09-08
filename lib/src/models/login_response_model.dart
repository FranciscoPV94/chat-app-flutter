import 'dart:convert';

import 'package:chat_app/src/models/usuario_model.dart';

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  ResponseModel({
    this.ok,
    this.msg,
    this.usuario,
    this.token,
  });

  bool ok;
  String msg;
  UsuarioModel usuario;
  String token;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        ok: json["ok"],
        msg: json["msg"],
        usuario: UsuarioModel.fromJson(json["usuario"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "usuario": usuario.toJson(),
        "token": token,
      };
}
