
import 'package:flutter/material.dart';

class Usuario {//não usar para funcionarios

  String nome;
  String email;
  String id;
  bool isAdmin;
  bool isAtivo;
  String setor;
  String fotoUrl;
  bool isDisponivel;
  bool isMaior;
  bool isResponsavel;

  Usuario({
    this.nome,
    @required this.email,
    @required this.id,
    @required this.isAdmin,
    this.isAtivo=true,
    this.setor,
    this.fotoUrl,
    this.isDisponivel,
    this.isMaior,
    this.isResponsavel
  });

  Map<String,dynamic> toMap() {
    
    Map<String,dynamic> map = {

      "email" : this.email,
      "id": this.id,
      "isAdmin":this.isAdmin,
      'isAtivo':this.isAtivo,
      'isDisponivel':this.isDisponivel,
      'isMaior':this.isMaior,
      'isResponsavel':this.isResponsavel,
      'setor':this.setor,
      'nome':this.nome,
      'fotoUrl':this.fotoUrl


    };
    return map;
  }

}