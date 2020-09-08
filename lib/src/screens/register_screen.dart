import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/widgets/custom_boton.dart';
import 'package:chat_app/src/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Logo(),
                  _Form(),
                  _Labels(),
                  Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Labels extends StatelessWidget {
  const _Labels({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '¿Ya tienes una cuenta?',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: Text(
              'Ingresar ahora!',
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    Key key,
  }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardTipe: TextInputType.text,
            textEditingController: nameCtrl,
            isPassword: false,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo eléctronico',
            keyboardTipe: TextInputType.emailAddress,
            textEditingController: emailCtrl,
            isPassword: false,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Contraseña',
            keyboardTipe: TextInputType.visiblePassword,
            textEditingController: passCtrl,
            isPassword: true,
          ),
          CustomBtn(
            text: 'Ingresar',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final registerResp = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());

                    if (registerResp == true) {
                      socketService.initConnect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {}
                  },
          )
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      margin: EdgeInsets.only(top: 50),
      width: 170,
      child: Column(
        children: [
          Image(image: AssetImage('assets/tag-logo.png')),
          SizedBox(
            height: 10,
          ),
          Text(
            'Registro',
            style: TextStyle(fontSize: 30),
          )
        ],
      ),
    ));
  }
}
