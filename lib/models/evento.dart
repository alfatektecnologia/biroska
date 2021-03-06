class Evento {
  String nomeEvento;
  String dataEvento;
  bool isAtivo;
  String eventoUrl;
  String userId;
  String dataCadastro;
  String key;

  Evento(
      {this.nomeEvento,
      this.dataEvento,
      this.isAtivo,
      this.eventoUrl,
      this.userId,
      this.dataCadastro,
      this.key});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nomeEvento': this.nomeEvento,
      'dataEvento': this.dataEvento,
      'isAtivo': this.isAtivo,
      'eventoUrl': this.eventoUrl,
      'userId': this.userId,
      'dataCadastro': this.dataCadastro
    };

    return map;
  }
}
