import 'package:biroska/models/evento.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Eventos extends StatefulWidget {
  @override
  _EventosState createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  bool teste = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Eventos",
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),
      ),
      body: Center(
        child: Consumer<Util>(
          builder: (context, appState, _) => Container(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<Evento>>(
              future: Util.getEventosAtivos(),
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
                            'Carregando itens...',
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
                    //todo:checar erros

                    // listProdutos = appState.listProdutos;

                    if (snapshot.hasData) {
                      return ListView.builder(
                        //scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, int index) {
                          List<Evento> lista = snapshot.data;

                          Evento evento = lista[index];

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              /* height: MediaQuery.of(context).size.height,// 300,
                              width: MediaQuery.of(context).size.width,//300, */
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(width: 3, color: Colors.white),
                                color: Colors.orange[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.network(evento.eventoUrl, width: 300),
                                    Util.isAdmin
                                        ? FloatingActionButton(
                                            onPressed: () {
                                              print(evento.key);
                                              evento.isAtivo = false;
                                              Util.atualizarDadosCadastro(
                                                  'eventos',
                                                  evento.key,//documentId
                                                  evento.toMap());
                                            },
                                            child: Icon(Icons.delete),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                        child: Text(
                          'Itens não cadastrados!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }

                    break;
                }
                return Container(
                  child: Text(
                    'Erro ao carregar itens',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          )),
        ),
      ),
    );
  }
}
