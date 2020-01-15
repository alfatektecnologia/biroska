import 'package:biroska/utilitarios/utilitarios.dart';


import 'package:flutter/material.dart';

import 'models/produto.dart';

class AppState with ChangeNotifier {
  int selectedCategoriaId = 0; //seleciono a categoria ID padrão
  String selectedCategoriaNome =
      'Porções'; //seleciono o nome da categoria padrão

  List<Produto> listProdutos = List();

  void updateCategoriaId(int selectedCategoriaId) {
    this.selectedCategoriaId = selectedCategoriaId;
    notifyListeners();
  }

  void updateCategoriaNome(String selectedCategoriaNome) {
    this.selectedCategoriaNome = selectedCategoriaNome;
    getList(selectedCategoriaNome);
    notifyListeners();
  }

  void updateListProdutos(List<Produto> listProdutos) {
    this.listProdutos = listProdutos;
    notifyListeners();
  }



  List<Produto> getList(String nomeCategoria) {
    //como rodar isso qdo houver clic em outra categoria?

    List<Produto> lProd = List();
    if (Util.listGeralProdutos != null) {
      Util.listGeralProdutos.forEach((value) {
        lProd.add(value);
        print(value);
      });
    }
    print('AppState=> ' + nomeCategoria);
    updateListProdutos(lProd);
    notifyListeners();

    return lProd;
  }
}
