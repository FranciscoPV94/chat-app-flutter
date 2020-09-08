import 'package:chat_app/src/screens/login_screen.dart';
import 'package:chat_app/src/screens/usuarios_screen.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLogin(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future checkLogin(BuildContext context) async {
    final authServie = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final autenticasdo = await authServie.isLoggedIn();
    if (autenticasdo) {
      //Navigator.pushReplacementNamed(context, 'usuarios');
      socketService.initConnect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsuariosScreen(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      // Navigator.pushReplacementNamed(context, 'login');
      //socketService.disconnect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginScreen(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
