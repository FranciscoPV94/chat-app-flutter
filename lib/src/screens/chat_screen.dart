import 'dart:io';

import 'package:chat_app/src/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscibiendo = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.0,
        title: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    'Te',
                    style: TextStyle(fontSize: 14),
                  ),
                  backgroundColor: Colors.blue[200],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  'Francisco Peralta',
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
      uid: '123',
      texto: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 800)),
    );
    _messages.insert(0, msj);
    msj.animationController.forward();

    setState(() {
      _estaEscibiendo = false;
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
