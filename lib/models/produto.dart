class Produto {
  String nomeProduto;
  double valorProduto;
  double valorMeioProduto;
  String descrProduto;
  String categoria;
  bool isAtivo;
  String fotoUrl;

  Produto(
      {this.nomeProduto,
      this.valorProduto,
      this.valorMeioProduto,
      this.descrProduto,
      this.categoria,
      this.isAtivo,
      this.fotoUrl});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nome': this.nomeProduto,
      'valor': this.valorProduto,
      'valorMeio':this.valorMeioProduto,
      'descricao': this.descrProduto,
      'categoria': this.categoria,
      'isAtivo': this.isAtivo,
      'url': this.fotoUrl
    };

    return map;
  }
}
