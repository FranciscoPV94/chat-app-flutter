import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {Key key,
      @required this.texto,
      @required this.uid,
      @required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.elasticInOut),
      child: FadeTransition(
        opacity: animationController,
        child: Container(
          child: this.uid == authService.usuario.uid
              ? _myMessage()
              : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),
          child: Text(
            this.texto,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget _notMyMessage() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey[700],
              borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5, right: 50, left: 5),
          child: Text(
            this.texto,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
