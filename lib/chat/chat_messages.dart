import 'dart:async';

import 'package:biroska/chat/conversas.dart';

import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatConversas extends StatefulWidget {
  @override
  _ChatConversasState createState() => _ChatConversasState();
}

class _ChatConversasState extends State<ChatConversas> {
  final Firestore firestore = Firestore.instance;

  final _controller = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot> _adicionarListenerPapos() {
    final stream = firestore
        .collection('conversas')
        .document(Util.userID)
        .collection('ultima_conversa')
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });

    return stream;
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerPapos();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
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
                    'Carregando conversas...',
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
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Text("Erro ao carregar dados");
            } else {
              if (querySnapshot.documents.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Não há conversas gravadas!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              }
              return Mensagens(querySnapshot: querySnapshot);
            }

            break;
          default:
//return Container();
        }
        return Container();
      },
    );
  }
}
/* busca as mensagens na nuvem e mostra*/

class Mensagens extends StatefulWidget {
  final QuerySnapshot querySnapshot;

  const Mensagens({Key key, this.querySnapshot}) : super(key: key);
  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.querySnapshot.documents.length,
      itemBuilder: (_, index) {
        //recupera as mensagens
        List<DocumentSnapshot> _messages =
            widget.querySnapshot.documents.toList();

        //recupera apenas um item

        DocumentSnapshot item = _messages[index];

        return ListTile(
          onTap: () {
            Util.gotoScreen(
                Conversas(
                  nome: item['nome'],
                  url: item['fotoUrl'],
                  idContato: item['idDestinatario'],
                ),
                context);
          },
          title: Text(item['nome']),
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage:
                item['fotoUrl'] != null ? NetworkImage(item['fotoUrl']) : null,
          ),
          subtitle:
              Text(item['ultimoPapo'], style: TextStyle(color: Colors.grey)),
        );
      },
    );
  }
}
