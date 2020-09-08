import 'package:chat_app/global/environment.dart';
import 'package:chat_app/src/models/mensajes_response_model.dart';
import 'package:chat_app/src/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ChatService with ChangeNotifier {
  UsuarioModel usuarioPara;

  Future getChat(String usuarioId) async {
    final resp = await http.get('${Environment.apiUrl}/mensajes/$usuarioId',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final mensajesResponse = mensajesResponseFromJson(resp.body);

    return mensajesResponse.mensajes;
  }
}
