class Mensagem {
  String idUsuario;
  String message;
  DateTime dataMessage;
  String tipo; //define o tipo de mensagem que pode ser texto,imagem ou audio
  String fotosUrl;
  String audioUrl;

  Mensagem();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idUsuario': this.idUsuario,
      'message': this.message,
      'dataMessage': this.dataMessage,
      'tipo': this.tipo,
      'fotosUrl': this.fotosUrl,
      'audioUrl': this.audioUrl
    };

    return map;
  }
}
