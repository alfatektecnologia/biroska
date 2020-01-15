class ErroReport {
  String codigoErro;
  
  String emailUser;
  String localErro;
  bool wasFixed;
  DateTime date;

  ErroReport({this.codigoErro, this.emailUser, this.localErro, this.date,this.wasFixed});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'codigoErro': this.codigoErro,
      'emailUser': this.emailUser,
      'localErro': this.localErro,
      'date': this.date,
      'wasFixed':this.wasFixed,
      
    };
    return map;
  }
}
