import 'package:biroska/chat/chat_home.dart';
import 'package:biroska/models/categorias.dart';
import 'package:biroska/models/produto.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:biroska/widgets/categorias_widget.dart';

import 'package:biroska/widgets/menu_bar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;

  HomePage(this.isAdmin);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Produto> produtosList = List();
  List<Produto> listProdutos =
      List(); //list with products from selected category
  @override
  void initState() {
    recuperaProdutos();//recupera todos os produtos cadastrados
    super.initState();

    
  }

  void recuperaProdutos() async {
    try {
      var listGeral = await Util.getProdutosAtivos(); //list of all products
      setState(() {
        produtosList = listGeral; //has all possible products
        print(listGeral);
        print(produtosList);
      });
    } catch (e) {
      print(e);
    }
  }

  //get products of specific category
  Future<List<Produto>> getList(String nomeCategoria) async {

    List<Produto> lProd = List();
    if (produtosList != null ) {
      await produtosList.forEach((value) {
        if (value.categoria==nomeCategoria) {

          lProd.add(value);
        }
        
        print(value);
      });
    }
    
    return lProd;
  }

  @override
  Widget build(BuildContext context) {
    final appState =
        Provider.of<AppState>(context); //access to index of categories
    final isSelected = appState.selectedCategoriaId; //get the index

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.mood,
              color: Colors.white,
            ),
            onPressed: () {
              Util.gotoScreen(ChatHome(), context);
            },
          )
        ],
        title: Text("Menu",
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),
        backgroundColor: Colors.black,
      ),
      drawer: MenuBar(
        //choose a menu
        isAdmin: this.widget.isAdmin,
        context: context,
      ),
      body: ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.black, Colors.grey])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Text('Categorias',
                      style: TextStyle(color: Colors.white60, fontSize: 20)),
                ),
                Consumer<AppState>(
                  builder: (context, appState, _) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (final categoria in categoriasList)
                            CategoriasWidget(
                                categoria: categoria), //shows the categories
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Text('Itens',
                      style: TextStyle(color: Colors.white60, fontSize: 20)),
                ),
                Consumer<AppState>(
                  builder: (context, appState, _) => Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FutureBuilder<List<Produto>>(
                      future: getList(appState.selectedCategoriaNome),
                      // initialData: getList('Porções'),
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
                            
                            listProdutos = appState.listProdutos;
                            
                            if(snapshot.hasData){
                                return ListaProdutos(
                              snapshot: snapshot,
                              //snapshot: snapshot,
                            );

                            }else {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListaProdutos extends StatefulWidget {
  final snapshot;
  ListaProdutos({this.snapshot});

  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.snapshot.data.length,
      itemBuilder: (_, int index) {
        List<Produto> lista = widget.snapshot.data;
        Produto produto = lista[index];

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
                Image.network(produto.fotoUrl, width: 300),
                Text(
                  produto.nomeProduto,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
