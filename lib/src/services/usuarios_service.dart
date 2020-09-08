import 'package:chat_app/global/environment.dart';
import 'package:chat_app/src/models/usuarios_response_model.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/src/models/usuario_model.dart';

class UsuariosServie {
  Future<List<UsuarioModel>> getUsuarios() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/usuarios', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosResponseModelFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
