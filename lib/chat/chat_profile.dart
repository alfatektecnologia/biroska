import 'dart:async';

import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:biroska/utilitarios/utilitarios.dart';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPerfil extends StatefulWidget {
  @override
  _ChatPerfilState createState() => _ChatPerfilState();
}

class _ChatPerfilState extends State<ChatPerfil> {
  final _nomeController = TextEditingController();
  
  var _perfilformKey = GlobalKey<FormState>();
  bool isMaior = false;
  bool isResponsible = false;
  bool isDisponible = true;
  Map dadosRecuperados = {};
  Util util = Util();
  bool userHasDataSalved = false;

  @override
  void dispose() {
    super.dispose();
    _nomeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDadosSalvos();
  }

  Future<bool> getDadosSalvos() async {
    Map hasDados = {};
    util.setUploadingTask(true);
    dadosRecuperados = await Util.recuperarDadosPerfil();
    hasDados = dadosRecuperados;
    hasDados.length > 0 ? userHasDataSalved = true : userHasDataSalved = false;

    setState(() {
      dadosRecuperados['nome'] != null
          ? _nomeController.text = dadosRecuperados['nome']
          : _nomeController.text = ' ';

      dadosRecuperados['fotoUrl'] != null
          ? util.setFotoUrl(dadosRecuperados['fotoUrl'])
          : util.setFotoUrl(null);

      dadosRecuperados['isDisponivel'] != null
          ? isDisponible = dadosRecuperados['isDisponivel']
          : isDisponible = false;

      dadosRecuperados['isMaior'] != null
          ? isMaior = dadosRecuperados['isMaior']
          : isMaior = false;

      dadosRecuperados['isResponsavel'] != null
          ? isResponsible = dadosRecuperados['isResponsavel']
          : isResponsible = false;
    });
    Timer(Duration(seconds: 3), (){

      util.setUploadingTask(false);

    });
    
    return userHasDataSalved;
  }

  //show message like snackbar
  void showFlushbar(BuildContext context) {
    Flushbar(
      message: 'Perfil salvo com sucesso!',
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.redAccent,
    )..show(context);
  }

  //saving and validating

  void validateDataAndSave(context) {
    final form = _perfilformKey.currentState;
    if (form.validate() && Util.userHasFoto) {
      print('Profile is valid');
      Map<String, dynamic> dados = {
        'email': Util.userEmail,
        'nome': _nomeController.text.toUpperCase(),
        'fotoUrl': Util.urlImagem,
        'isDisponivel': isDisponible,
        'isMaior': isMaior,
        'isAdmin': false,
        'isResponsavel': isResponsible,
        'id': Util.userID
      };
      //data exists??? save or update?
      userHasDataSalved
          ? Util.atualizarDados('usuarios', Util.userID, dados)
          : Util.salvarDados('usuarios', Util.userID, dados);
      //show message
      showFlushbar(context);
    } else {
      print('Profile is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _perfilformKey,
        child: Consumer<Util>(
          builder: (context, util, _) => Container(
            child: Center(
                child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                  child: Center(child: Text('Sua foto:')),
                ),
                util.uploadingImage ? CircularProgressIndicator() : Container(),
                CircleAvatar(
                  radius: 80,
                  // backgroundColor: Colors.grey,
                  backgroundImage: Util.urlImagem != null
                      ? NetworkImage(Util.urlImagem)
                      : AssetImage('assets/images/lambe_lambe-23.jpg'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        util.recuperarImagem('camera', true);
                      },
                    ),
                    GestureDetector(
                        onTap: () => util.recuperarImagem('camera', true),
                        child: Text('Camera')),
                    SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          util.recuperarImagem('galeria', true);
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () => util.recuperarImagem('galeria', true),
                        child: Text('Galeria')),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    keyboardType: TextInputType.emailAddress,
                    controller: _nomeController,
                    onTap: () => _perfilformKey.currentState.reset(),
                    validator: (value) => (value.isEmpty || value.length < 3)
                        ? 'Nome inválido!'
                        : null,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Nome",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        //labelText: 'Nome',
                        errorStyle:
                            TextStyle(color: Color(0xffbb002f), fontSize: 15),
                        labelStyle: TextStyle(color: Colors.green)),
                  ),
                ),
                CheckboxListTile(
                  title: Text('Disponível para batepapo'),
                  onChanged: (bool value) {
                    setState(() {
                      isDisponible = !isDisponible;
                    });
                  },
                  value: isDisponible,
                ),
                CheckboxListTile(
                  title: Text('Tenho no mínimo 18 anos de idade'),
                  onChanged: (bool value) {
                    setState(() {
                      isMaior = !isMaior;
                    });
                  },
                  value: isMaior,
                ),
                CheckboxListTile(
                  title: Text('Sou responsável pelos meus atos'),
                  onChanged: (bool value) {
                    setState(() {
                      isResponsible = !isResponsible;
                    });
                  },
                  value: isResponsible,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 60,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          'Salvar',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        elevation: 0,
                        onPressed: () => validateDataAndSave(context),
                      ),
                    ),
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}

/* 
-provider?
-circular avatar
-nome
-tirar foto ou pegar da galeria
-salvar foto
-salvar url*/
