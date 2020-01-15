import 'package:biroska/app_state.dart';


import 'package:biroska/models/produto.dart';
import 'package:biroska/utilitarios/utilitarios.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* recupera a lista dos produtos ativos,
filtra os produtos de acordo com a categoria selecionada
mostra os produtos em uma list view horizontal*/

class ItensWidget extends StatefulWidget {
  final String categoria;

  final List<Produto> listGeneralProdutos; //lista com todos os produtos ativos

  const ItensWidget({Key key, this.categoria, this.listGeneralProdutos})
      : super(key: key);


  @override
  _ItensWidgetState createState() => _ItensWidgetState();
}

class _ItensWidgetState extends State<ItensWidget> {

  List<Produto> listProdutos =
      List(); //list with products from selected category
  @override
  void initState() {
    super.initState();

//    try {
//      getList(widget.categoria);
//      print(listProdutos);
//    } catch (e) {
//
//      print(e);
//    }
  }
  


  @override
  Widget build(BuildContext context) {
    final appState =
        Provider.of<AppState>(context); //access to index of categories
    final isSelected =
        appState.selectedCategoriaNome == widget.categoria; //get the index
    //final util = Provider.of<Util>(context);


    return ChangeNotifierProvider<Util>(
      create: (_)=>Util(),
      child: Consumer<Util>(
        builder: (context,util,_)=>FutureBuilder(
          future: Util.getCurrentUserStatus(),
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
                return ListaProdutos(
                  //snapshot: snapshot,
                );
                break;
            }
            return Container(
              child: Text('Erro ao carregar contatos',style: TextStyle(fontSize: 20),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Produto> getList(String nomeCategoria)  {//como rodar isso qdo houver clic em outra categoria?

    List<Produto> lProd = List();
    if (widget.listGeneralProdutos != null) {
      widget.listGeneralProdutos.forEach((value) {
        lProd.add(value);
        print(value);
      });
    }
    setState(() {
      listProdutos = lProd;
    });

    return lProd;
  }


}

class ListaProdutos extends StatefulWidget {
  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
     // itemCount: listProdutos.length,//como atualizar isso? qdo houver mudanças
      itemBuilder: (_, int index) {
//Produto produto = listProdutos[index];
     //   print(produto.nomeProduto);
      //  print(produto.valorProduto);

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 3, color: Colors.white),
              color: Colors.orange,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /* Image.network(produto.fotoUrl,width:300),
                Text(
                  produto.nomeProduto,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ), */
              ],
            ),
          ),
        );
      },
    );
  }
}


