import 'package:chat_app/src/models/usuario_model.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    UsuarioModel(
        uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    UsuarioModel(
        uid: '1', nombre: 'Melissa', email: 'test1@test.com', online: false),
    UsuarioModel(
        uid: '1', nombre: 'Fernando', email: 'test1@test.com', online: false),
    UsuarioModel(
        uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${authService.usuario.nombre}',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black54),
            onPressed: () {
              AuthService.deleteToken();
              Navigator.pushReplacementNamed(context, 'login');
            }),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        //enablePullUp: true,
        onRefresh: _cargarUsuarios,
        header: ClassicHeader(
          refreshingText: 'Cargando',
          releaseText: 'Suéltelo para actualizar',
          completeText: 'Listo',
        ),
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
      itemBuilder: (BuildContext context, int index) {
        return _UsuarioListTile(usuario: usuarios[index]);
      },
    );
  }

  void _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

class _UsuarioListTile extends StatelessWidget {
  const _UsuarioListTile({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('${usuario.nombre.substring(0, 1)}'),
      ),
      title: Text('${usuario.nombre}'),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[400] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}
