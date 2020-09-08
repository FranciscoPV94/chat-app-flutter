import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/src/models/login_response_model.dart';
import 'package:chat_app/src/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  UsuarioModel usuario;
  bool _autenticando = false;

  final _storage = FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post('${Environment.apiUrl}/login/login',
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        });

    if (resp.statusCode == 200) {
      final response = responseModelFromJson(resp.body);
      this.usuario = response.usuario;
      await this._guardarToken(response.token);
      this.autenticando = false;
      return true;
    } else {
      this.autenticando = false;
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.autenticando = true;

    final data = {'nombre': name, 'email': email, 'password': password};

    final resp = await http.post('${Environment.apiUrl}/login/new',
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        });

    print(resp.body);

    if (resp.statusCode == 200) {
      final response = responseModelFromJson(resp.body);
      this.usuario = response.usuario;
      await this._guardarToken(response.token);
      this.autenticando = false;
      return true;
    } else {
      this.autenticando = false;
      final resoBody = jsonDecode(resp.body);
      return resoBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    if (token != null) {
      final resp = await http.get('${Environment.apiUrl}/login/renew',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      if (resp.statusCode == 200) {
        final response = responseModelFromJson(resp.body);
        this.usuario = response.usuario;
        await this._guardarToken(response.token);
        return true;
      } else {
        this.logout();
        return false;
      }
    } else {
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    _storage.delete(key: 'token');
  }
}
