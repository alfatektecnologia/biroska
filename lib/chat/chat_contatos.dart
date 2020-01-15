import 'dart:async';

import 'package:biroska/chat/conversas.dart';
import 'package:biroska/models/usuario.dart';

import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatContatos extends StatefulWidget {
  @override
  _ChatContatosState createState() => _ChatContatosState();
}

class _ChatContatosState extends State<ChatContatos> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  var getContatos;

  @override
  void initState() {
    super.initState();
    getContatos = Util.getContatos();//desse jeito não deve funcionar o stream
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future:getContatos,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Carregando contatos...',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListaContatos(
              snapshot: snapshot,
            );
            break;
        }
        return Container(
          child: Text('Erro ao carregar contatos',style: TextStyle(fontSize: 20),
                  ),
        );
      },
    );
  }
}

class ListaContatos extends StatefulWidget {
  final snapshot;

  const ListaContatos({Key key, this.snapshot}) : super(key: key);
  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data.length,
      itemBuilder: (_, int index) {
        List<Usuario> listUsuarios = widget.snapshot.data;
        Usuario usuario = listUsuarios[index];
        return ListTile(
          onTap: () {
            Util.gotoScreen(
                Conversas(
                  nome: usuario.nome,
                  url: usuario.fotoUrl,
                  idContato: usuario.id,
                ),
                context);
          },
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage:
                usuario.fotoUrl != null ? NetworkImage(usuario.fotoUrl) : null,
          ),
          title: Text(usuario.nome),
        );
      },
    );
  }
}
