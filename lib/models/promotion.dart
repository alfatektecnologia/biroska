class Promotion {
  String produto;
  double valor;
  double valorMeia;
  String url;
  bool isAtivo;
  String userId;
  DateTime date;

  Promotion({
    this.produto,
    this.valor,
    this.valorMeia,
    this.url,
    this.isAtivo,
    this.userId,
    this.date
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'produto': this.produto,
      'valor': this.valor,
      'valorMeia':this.valorMeia,
      'url': this.url,
      'isAtivo': this.isAtivo,
      'userId': this.userId,
      'date':this.date
    };

    return map;
  }
}
