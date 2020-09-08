import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final Function() onPressed;
  final String text;
  const CustomBtn({
    Key key,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        elevation: 2.0,
        highlightElevation: 5,
        color: Colors.blue,
        shape: StadiumBorder(),
        child: Container(
            width: double.infinity,
            height: 50,
            child: Center(
                child: Text(
              this.text,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ))),
        onPressed: onPressed);
  }
}
