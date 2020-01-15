import 'package:biroska/app_state.dart';
import 'package:biroska/models/categorias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriasWidget extends StatelessWidget {
  final Categorias categoria;

  const CategoriasWidget({Key key, this.categoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSelected = appState.selectedCategoriaId == categoria.categoriaId;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            appState.updateCategoriaId(categoria.categoriaId);
            appState.updateCategoriaNome(categoria.nomeCategoria);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 3, color: Colors.white),
            color: isSelected ? Colors.orange : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                categoria.nomeCategoria,
                style: TextStyle(
                    //color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
