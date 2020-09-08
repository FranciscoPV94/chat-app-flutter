import 'dart:io';

import 'package:chat_app/src/models/mensajes_response_model.dart';
import 'package:chat_app/src/models/usuario_model.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/chat_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscibiendo = false;

  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  UsuarioModel usuarioPara;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.usuarioPara = chatService.usuarioPara;

    this.socketService.socket.on('mensaje-personal', _listenMgs);

    this._cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioId);
    final history = chat.map((e) => ChatMessage(
        texto: e.mensaje,
        uid: e.de,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMgs(dynamic data) {
    print(data);
    ChatMessage message = new ChatMessage(
        texto: data['mensaje'],
        uid: data['de'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 500)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.0,
        centerTitle: true,
        leading: BackButton(
          color: Colors.blue[300],
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text(
                    '${usuarioPara.nombre.substring(0, 1)}',
                    style: TextStyle(fontSize: 14),
                  ),
                  backgroundColor: Colors.blue[200],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  '${usuarioPara.nombre}',
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                ))
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return _messages[index];
                },
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.8,
      ),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            onSubmitted: _handleSubmit,
            onChanged: (value) {
              setState(() {
                if (value.trim().length > 0) {
                  _estaEscibiendo = true;
                } else {
                  _estaEscibiendo = false;
                }
              });
            },
            decoration:
                InputDecoration.collapsed(hintText: 'Escribe un mensaje'),
          )),
          Container(
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscibiendo
                          ? () =>
                              _handleSubmit(_textEditingController.text.trim())
                          : null)
                  : Container(
                      //margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(Icons.send),
                            onPressed: _estaEscibiendo
                                ? () => _handleSubmit(
                                    _textEditingController.text.trim())
                                : null),
                      ),
                    ))
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;

    _focusNode.requestFocus();
    _textEditingController.clear();

    final msj = ChatMessage(
      uid: authService.usuario.uid,
      texto: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 800)),
    );
    _messages.insert(0, msj);
    msj.animationController.forward();

    setState(() {
      _estaEscibiendo = false;
    });

    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.usuarioPara.uid,
      'mensaje': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('mensaje-personal');

    super.dispose();
  }
}
