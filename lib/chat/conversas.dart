import 'dart:async';
import 'dart:io';

import 'package:biroska/models/mensagem.dart';
import 'package:biroska/models/papo.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Conversas extends StatefulWidget {
  final String nome;
  final String url;
  final String idContato;

  const Conversas({Key key, this.nome, this.url, this.idContato})
      : super(key: key);

  @override
  _ConversasState createState() => _ConversasState();
}

class _ConversasState extends State<Conversas> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final ScrollController _scrollController = ScrollController();
  bool uploadingImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage:
                  widget.url != null ? NetworkImage(widget.url) : null,
            ),
            SizedBox(
              width: 16,
            ),
            Text(widget.nome,
                style: GoogleFonts.permanentMarker(
                    textStyle: TextStyle(color: Colors.white, fontSize: 18)))
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              RecoverMessagesWithListener(
                idContato: widget.idContato,
                scrollController: _scrollController,
                controller: _controller,
              ),
              CaixaMensagem(
                idContato: widget.idContato,
                nome: widget.nome,
                fotoUrl: widget.url,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CaixaMensagem extends StatefulWidget {
  final String idContato;
  final String nome;
  final String fotoUrl;

  const CaixaMensagem({Key key, this.idContato, this.nome, this.fotoUrl})
      : super(key: key);
  @override
  _CaixaMensagemState createState() => _CaixaMensagemState();
}

class _CaixaMensagemState extends State<CaixaMensagem> {
  bool isAudio = true; //to change icon in floating button
  TextEditingController _mensagemController = TextEditingController();
  FlutterSound flutterSound = FlutterSound();

  void gravarAudio() async {
    // Start recording
    String path = await flutterSound.startPlayer(null);
    var _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
      if (e != null) {
        DateTime date =
            new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        /* String txt = DateFormat(‘mm:ss:SS’, ‘en_US’).format(date);
  this.setState(() {
    this._isPlaying = true;
    this._playerTxt = txt.substring(0, 8);
  }); */
      }
    });
    print('gravando');
  }

  stopRecording() async {
    String result = await flutterSound.stopRecorder();
/* print(‘stopRecorder: $result’);
if (_recorderSubscription != null) {
 _recorderSubscription.cancel();
 _recorderSubscription = null;
} */
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Util>(
      //para poder usar o provider e poder recuperar a foto da camera
      builder: (context, util, _) => Container(
        padding: EdgeInsets.all(8),
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextField(
                  onTap: () {
                    setState(() {
                      isAudio = false;
                    });
                  },
                  onChanged: (v) {
                    setState(() {
                      isAudio = false;
                    });
                  },
                  controller: _mensagemController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: util.uploadingImage
                            ? CircularProgressIndicator()
                            : Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                        onPressed: () {
                          //recupera a imagem da camera/
                          recuperaImagemSalvaMensagem(
                              widget.idContato, widget.nome, widget.fotoUrl);
                        },
                      ),
                      hintText: "Digite sua mensagem...",
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      filled: true,
                      fillColor: Colors.grey[700],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                ),
              ),
            ),
            FloatingActionButton(
              //todo qdo for foto, o q fazer com esse botão?
              mini: true,
              
              onPressed: () {
                setState(() {
                  if (isAudio) {
                    // Start recording

                    gravarAudio();
                    stopRecording();
                  } else {
                    _enviarMensagem(
                        widget.idContato, widget.nome, widget.fotoUrl);
                    isAudio = true; //default icon
                    _mensagemController.clear();
                  }
                });
              },
              child: isAudio ? Icon(Icons.mic) : Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }

  void _enviarMensagem(String idContato, String nome, String fotoUrl) {
    String message = _mensagemController.text;
    if (message.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.message = message;
      mensagem.dataMessage = DateTime.now();
      mensagem.tipo = "texto";
      mensagem.idUsuario = Util.userID;
      mensagem.fotosUrl = null;
      mensagem.audioUrl = null;

      Util.gravarMensagem(mensagem.toMap(), idContato, false);

      Papo papo = Papo();
      papo.nome = widget.nome;
      papo.fotoUrl = widget.fotoUrl;
      papo.idRemetente = Util.userID;
      papo.idDestinatario = idContato;
      papo.tipo = 'texto';
      papo.ultimoPapo = message;

      Util.gravarMensagem(papo.toMap(), idContato, true);
    }
  }
}

/* busca as mensagens na nuvem e mostra*/

class Mensagens extends StatefulWidget {
  final QuerySnapshot querySnapshot;
  final ScrollController scrollController;

  const Mensagens({Key key, this.querySnapshot, this.scrollController})
      : super(key: key);
  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: widget.querySnapshot.documents.length,
        itemBuilder: (_, index) {
          //recupera as mensagens
          List<DocumentSnapshot> _messages =
              widget.querySnapshot.documents.toList();

          //recupera apenas um item

          DocumentSnapshot item = _messages[index];

          //configurar alinhamento e cor de fundo
          Alignment _alignment = Alignment.centerRight;
          Color _color = Colors.grey[700];

          if (Util.userID != item['idUsuario']) {
            _color = Colors.teal[400];
            _alignment = Alignment.centerLeft;
          }

          return Align(
            alignment: _alignment,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: item['tipo'] == 'texto'
                    ? Text(
                        item['message'],
                        style: TextStyle(fontSize: 18),
                      )
                    : Image.network(item['fotosUrl']),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecoverMessagesWithListener extends StatefulWidget {
  final String idContato;
  final controller;
  final scrollController;

  const RecoverMessagesWithListener(
      {Key key, this.idContato, this.controller, this.scrollController})
      : super(key: key);
  @override
  _RecoverMessagesWithListenerState createState() =>
      _RecoverMessagesWithListenerState();
}

class _RecoverMessagesWithListenerState
    extends State<RecoverMessagesWithListener> {
  final Firestore firestore = Firestore.instance;

  Stream<QuerySnapshot> _adicionarListenerMensagens() {
    final stream = firestore
        .collection('mensagens')
        .document(Util.userID)
        .collection(widget.idContato)
        .orderBy('dataMessage')
        .snapshots();

    stream.listen((dados) {
      widget.controller.add(dados);
    });

    Timer(Duration(seconds: 1), () {
      widget.scrollController
          .jumpTo(widget.scrollController.position.maxScrollExtent);
    });

    return stream;
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerMensagens();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.close();
    widget.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.controller.stream,
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
                    'Carregando mensagens...',
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
              return Expanded(
                child: Text("Erro ao carregar dados"),
              );
            } else {
              return Mensagens(
                querySnapshot: querySnapshot,
                scrollController: widget.scrollController,
              );
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

void recuperaImagemSalvaMensagem(
    String idContato, String nome, String fotoUrl) async {
  Util util = Util();
  File imagem;

  imagem = await ImagePicker.pickImage(source: ImageSource.gallery);

  String nomeArquivo = DateTime.now().microsecondsSinceEpoch.toString();
  util.setUploadingTask(true); //sinalisar para exibir circularprogress...
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageReference pastaRaiz = firebaseStorage.ref();
  StorageReference arquivo = pastaRaiz
      .child('mensagem')
      .child(Util.userID)
      .child(nomeArquivo + '.jpg');

  //upload da imagem
  StorageUploadTask uploadTask = arquivo.putFile(imagem);

  //controlar o processo de upload
  uploadTask.events.listen((StorageTaskEvent storageEvent) {
    if (storageEvent.type == StorageTaskEventType.progress) {
      util.setUploadingTask(true);
      print('uploading... $util.uploadingImage');
//notifyListeners();
    } else if (storageEvent.type == StorageTaskEventType.success) {
      util.setUploadingTask(false);
      print('uploading... $util.uploadingImage');

      //notifyListeners();
    }
  });

  uploadTask.onComplete.then((StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    util.setFotoUrlImagemAudio(url);

    Mensagem mensagem = Mensagem();
    mensagem.message = "";
    mensagem.dataMessage = DateTime.now();
    mensagem.tipo = "foto";
    mensagem.idUsuario = Util.userID;
    mensagem.fotosUrl = url;
    mensagem.audioUrl = 'null';

    Util.gravarMensagem(mensagem.toMap(), idContato, false);

    Papo papo = Papo();
    papo.nome = nome;
    papo.fotoUrl = fotoUrl;
    papo.idRemetente = Util.userID;
    papo.idDestinatario = idContato;
    papo.tipo = 'texto';
    papo.ultimoPapo = 'imagem/áudio...';

    Util.gravarMensagem(papo.toMap(), idContato, true);
  });
}
