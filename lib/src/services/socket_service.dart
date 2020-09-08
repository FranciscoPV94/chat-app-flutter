import 'package:chat_app/global/environment.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  ServerStatus get serverStatus => this._serverStatus;

  Future<void> initConnect() async {
    print('init server');

    final token = await AuthService.getToken();

    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });
    _socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('nuevo-mensaje', (payload) {
      print('$payload');
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
