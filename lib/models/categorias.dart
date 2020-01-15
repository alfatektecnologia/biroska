

class Categorias{
  final int categoriaId;
  final String nomeCategoria;

  Categorias({this.categoriaId, this.nomeCategoria});

 

}
  final porcoes = Categorias(
    categoriaId: 0, 
    nomeCategoria:"Porções");

  final lanches = Categorias(
    categoriaId: 1,
    nomeCategoria: 'Lanches'
  );

  final espetos = Categorias(
    categoriaId: 2,
    nomeCategoria: 'Espetos'
  );

  final cervejas = Categorias(
    categoriaId: 3,
    nomeCategoria: 'Cervejas'
  );
  final drinks = Categorias(
    categoriaId:4,
    nomeCategoria: 'Drinks'
  );

  final cachacas = Categorias(
    categoriaId: 5,
    nomeCategoria: 'Cachaças'
  );

  final bebidas = Categorias(
    categoriaId: 6,
    nomeCategoria: 'Bebidas'
  );

  var categoriasList= [
    porcoes,
    lanches,
    espetos,
    cervejas,
    drinks,
    cachacas,
    bebidas
  ];

  

  
