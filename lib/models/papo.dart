class Papo {
  String idRemetente;
  String idDestinatario;
  String nome;
  String ultimoPapo;
  String fotoUrl;
  String tipo;

  Papo();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idRemetente': this.idRemetente,
      'idDestinatario': this.idDestinatario,
      'nome': this.nome,
      'fotoUrl': this.fotoUrl,
      'tipo': this.tipo,
      'ultimoPapo': this.ultimoPapo
    };
    return map;
  }
}
