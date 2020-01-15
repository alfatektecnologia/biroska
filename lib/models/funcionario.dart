class Funcionario {
  String nomeFuncionario;
  String funcID;
  bool isAdmin;
  bool isAtivo;
  String setor;
  String adminID;

  Funcionario(
      {this.nomeFuncionario,
      this.funcID,
      this.isAdmin,
      this.isAtivo,
      this.setor,
      this.adminID});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nomeFuncionario,
      'ID': this.funcID,
      'isAdmin': this.isAdmin,
      'isAtivo': this.isAtivo,
      'setor': this.setor,
      'adminID': this.adminID
    };
    return map;
  }
}
