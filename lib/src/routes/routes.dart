import 'package:chat_app/src/screens/chat_screen.dart';
import 'package:chat_app/src/screens/loading_screen.dart';
import 'package:chat_app/src/screens/login_screen.dart';
import 'package:chat_app/src/screens/register_screen.dart';
import 'package:chat_app/src/screens/usuarios_screen.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext context)> appRoutes = {
  'usuarios': (_) => UsuariosScreen(),
  'chat': (_) => ChatScreen(),
  'login': (_) => LoginScreen(),
  'register': (_) => RegisterScreen(),
  'loading': (_) => LoadingScreen(),
};
