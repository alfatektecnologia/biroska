import 'package:biroska/models/categorias.dart';
import 'package:biroska/models/produto.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:biroska/widgets/menu_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroProdutos extends StatefulWidget {
  @override
  _CadastroProdutosState createState() => _CadastroProdutosState();
}

class _CadastroProdutosState extends State<CadastroProdutos> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _valorMeiaController = TextEditingController();
  Categorias categorias;
  var selectedItem;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nomeController.dispose();
    _valorController.dispose();
    _valorMeiaController.dispose();
    _descricaoController.dispose();
  }

  //saving and validating
  void validateDataAndSave(context) {
    final form = _formKey.currentState;
    if (form.validate() && Util.urlImagemCadastro != null) {
      //print('Produto is valid');
      //var dateTime = DateTime.now();
      Produto produto = Produto(
          nomeProduto: _nomeController.text,
          valorProduto: double.parse(_valorController.text),
          valorMeioProduto: double.parse(_valorMeiaController.text),
          descrProduto: _descricaoController.text,
          categoria: selectedItem,
          isAtivo: true,
          fotoUrl: Util.urlImagemCadastro);

      Util.salvarDadosCadastro("produtos", Util.userID, produto.toMap());
      //show message
      Util.showFlushbar(context, 'Produto salvo com sucesso!');
      Util.urlImagemCadastro = null;
      setState(() {
        //limpar caixa de textos
        _nomeController.text = "";
        _valorController.text = '';
        _valorMeiaController.text = '';
      });
    } else {
      //print('Produto is invalid');
      //show message
      Util.showFlushbar(context, 'Falha! Verifique os dados do produto!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 8.0, right: 8),
                child: Consumer<Util>(
                  builder: (context, util, _) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Util.urlImagemCadastro != null
                                ? NetworkImage(Util.urlImagemCadastro)
                                : AssetImage('assets/images/fachada.jpeg'),
                            fit: BoxFit.fill),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white24),
                    //padding: EdgeInsets.only(left: 16, right: 16),
                    height: 200,
                    //child: Image.asset('assets/images/fachada.jpeg',),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        util.recuperarImagemCadastro("camera", 'produtos');
                      },
                    ),
                    GestureDetector(
                        onTap: () =>
                            util.recuperarImagemCadastro("camera", 'produtos'),
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
                          util.recuperarImagemCadastro("galeria", 'produtos');
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () =>
                            util.recuperarImagemCadastro("galeria", 'produtos'),
                        child: Text('Galeria')),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.text,
                  controller: _nomeController,
                  validator: (value) =>
                      value.isEmpty ? 'Nome inválido de produto!' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Nome do produto',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.text,
                  controller: _descricaoController,
                  validator: (value) =>
                      value.isEmpty ? 'Descrição inválida de produto!' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Descrição do produto',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _valorController,
                  validator: (value) =>
                      value.isEmpty ? 'Valor inválido!' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Valor do produto. Ex.: 10.00',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _valorMeiaController,
                  /* validator: (value) =>
                      value== ? 'Valor inválido!' : null, */
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Valor 1/2 porção. Ex.: 8.00',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton(
                      items: categoriasList
                          .map((value) => DropdownMenuItem(
                                child: Text(value.nomeCategoria,
                                    style: TextStyle(fontSize: 20)),
                                value: value.nomeCategoria,
                              ))
                          .toList(),
                      onChanged: (valueSelected) {
                        setState(() {
                          selectedItem = valueSelected;
                        });
                      },
                      hint: Text('Selecione a categoria do produto:',
                          style: TextStyle(color: Colors.white)),
                      value: selectedItem,
                    ),
                  ],
                ),
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
                      onPressed: () {
                        validateDataAndSave(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
