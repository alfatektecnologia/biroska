import 'dart:io';

import 'package:biroska/models/erros.dart';
import 'package:biroska/models/produto.dart';
import 'package:biroska/models/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Util with ChangeNotifier {
  static String userID = 'null ';
  static String userEmail = 'null';
  static bool isAdmin;
  bool uploadingImage = false;
  static bool userHasFoto = false;
  static var urlImagem;
  static var urlImagemCadastro;
  static var urlImagemAudioMensagem;
  static final Firestore firestore = Firestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static List<Produto> listGeralProdutos=List(); //preparo uma lista para receber os produtos do snapShot

  //navegar para outra pÃ¡gina (used inside an onclick button event)
  static void gotoScreen(Widget pagina, context) {
    Route route = MaterialPageRoute(builder: (context) => pagina);
    Navigator.push(context, route);
  }

  //check if exist a logged user
  static Future<Map<dynamic, dynamic>> getCurrentUserStatus() async {
    var userData = Map();
    bool result = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser(); //checa se existe user logado
    userData['user'] = user;
    if (user != null) {
      userID = user.uid;
      userEmail = user.email;
    }

    if (user != null) {
      result = await userIsAdmin(user.uid);
      userData['admin'] = result;

      //return true or false;
    } else {
      //user==null
      // return false;
      userData['admin'] = result;
    }

    return userData;
  }

  //set url da foto recuperada do firestore

  setFotoUrl(String url) {
    urlImagem = url;

    notifyListeners();
  }

  setUploadingTask(bool state) {
    uploadingImage = state;
    notifyListeners();
  }

  setFotoUrlImagemAudio(String url) {
    urlImagemAudioMensagem = url;

    notifyListeners();
  }

  //check if user is admin
  static Future<bool> userIsAdmin(userID) async {
    bool isAdmin = false;//if null at database it becomes false too
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .where("id", isEqualTo: userID)
        .getDocuments();

    {
      if (querySnapshot.documents.isEmpty) {
        isAdmin = false;
      } else {
        for (DocumentSnapshot item in querySnapshot.documents) {
          var dados = item.data;
          if (dados["isAdmin"]) {
            isAdmin = true;

            // return isAdmin;
          } 
        }
      }
    }
    return isAdmin;
  }

  //carregar dados perfil
  static Future<Map> recuperarDadosPerfil() async {
    Map hasDados = {};
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('usuarios').document(userID).get();

      Map<String, dynamic> dados = snapshot.data;
      if (dados['fotoUrl'] != null) {
        userHasFoto = true;
        hasDados = dados;
      }
    } catch (e) {
      //salvando o erro na nuvem
      ErroReport erro = ErroReport(
        codigoErro: e.toString(),
        localErro: 'Util=>recuperarDadosPerfil',
        emailUser: userEmail,
        date: DateTime.now(),
        wasFixed: false,
      );
      Util.salvarErros(erro.toMap());
      // print('Erro capturando dados do usuário no Firestore=>RecuperarDados');
    }
    ;

    return hasDados;
  }

  //salvar dados
  static Future salvarDados(String collection, String uid, Map dados) async {
    firestore.collection(collection).document(uid).setData(dados).then((value) {
      //print('dados salvos com sucesso');
    }).catchError((e) {
      //salvando o erro na nuvem
      ErroReport erro = ErroReport(
        codigoErro: e.toString(),
        localErro: 'Util=>salvarDados',
        emailUser: userEmail,
        date: DateTime.now(),
        wasFixed: false,
      );
      Util.salvarErros(erro.toMap());
      //print(e);
    });
  }

  //salvar dados cadastro
  static Future salvarDadosCadastro(
      String collection, String uid, Map dados) async {
    firestore.collection(collection).add(dados).then((value) {
      //print('dados salvos com sucesso');
    }).catchError((e) {
      //salvando o erro na nuvem
      ErroReport erro = ErroReport(
        codigoErro: e.toString(),
        localErro: 'Util=>salvarDadosCadastro',
        emailUser: userEmail,
        date: DateTime.now(),
        wasFixed: false,
      );
      Util.salvarErros(erro.toMap());
      // print(e);
    });
  }

  //salvar os erros do app e dar suporte se necessário
  static Future salvarErros(Map dadosErro) async {
    firestore.collection('suporte').add(dadosErro);
  }

  //atualizar dados
  static Future atualizarDados(String collection, String uid, Map dados) async {
    firestore
        .collection(collection)
        .document(uid)
        .updateData(dados)
        .then((value) {
      print('dados salvos com sucesso');
    }).catchError((e) {
      print(e);
    });
  }

  //salvar imagem do perfil no firestore
  Future salvarFotoFirestore(File imagem) async {
    StorageReference pastaRaiz = firebaseStorage.ref();
    StorageReference arquivo = pastaRaiz
        .child('perfil')
        .child(userID + '.jpg'); //todo checar de não é nullo

    //upload da imagem
    StorageUploadTask uploadTask = arquivo.putFile(imagem);

    //controlar o processo de upload
    uploadTask.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setUploadingTask(true);
        print('uploading... $uploadingImage');
        notifyListeners();
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setUploadingTask(false);
        print('uploading... $uploadingImage');
        userHasFoto = true; //usuário possue foto salva
        notifyListeners();
      }
    });

    uploadTask.onComplete.then((StorageTaskSnapshot snapshot) async {
      String url = await snapshot.ref.getDownloadURL();
      urlImagem = url;
      notifyListeners();
    });
  }

  //salvar imagem do cadastro no firestore
  Future salvarFotoCadastroFirestore(File imagem, String colecao) async {
    String nomeArquivo = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference pastaRaiz = firebaseStorage.ref();
    StorageReference arquivo = pastaRaiz
        .child(colecao)
        .child(nomeArquivo + '.jpg'); //todo checar de não é nullo

    //upload da imagem
    StorageUploadTask uploadTask = arquivo.putFile(imagem);

    //controlar o processo de upload
    uploadTask.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setUploadingTask(true);
        print('uploading... $uploadingImage');
        notifyListeners();
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setUploadingTask(false);
        print('uploading... $uploadingImage');

        notifyListeners();
      }
    });

    uploadTask.onComplete.then((StorageTaskSnapshot snapshot) async {
      String url = await snapshot.ref.getDownloadURL();
      urlImagemCadastro = url; 
      notifyListeners();
    });
  }
/* 
  //salvar imagem do cadastro no firestore
  Future salvarFotoCadastroFirestore(File imagem, String colecao) async {
    String nomeArquivo = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference pastaRaiz = firebaseStorage.ref();
    StorageReference arquivo = pastaRaiz
        .child(colecao)
        .child(nomeArquivo + '.jpg'); //todo checar de não é nullo

    //upload da imagem
    StorageUploadTask uploadTask = arquivo.putFile(imagem);

    //controlar o processo de upload
    uploadTask.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        uploadingImage = true;
        // print('uploading... $uploadingImage');
        notifyListeners();
      } else if (storageEvent.type == StorageTaskEventType.success) {
        uploadingImage = false;
        //print('uploading... $uploadingImage');

        notifyListeners();
      }
    });

    uploadTask.onComplete.then((StorageTaskSnapshot snapshot) async {
      String url = await snapshot.ref.getDownloadURL();
      urlImagem = url;
      notifyListeners();
    });
  } */

  //salvar imagem/audio da mensagem no firestore, não utilizado no momento
  Future salvarFotoAudioMensagemFirestore(File imagem) async {
    String nomeArquivo = DateTime.now().microsecondsSinceEpoch.toString();
    uploadingImage = true; //sinalisar para exibir circularprogress...
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference pastaRaiz = firebaseStorage.ref();
    StorageReference arquivo =
        pastaRaiz.child('mensagem').child(userID).child(nomeArquivo + '.jpg');

    //upload da imagem
    StorageUploadTask uploadTask = arquivo.putFile(imagem);

    //controlar o processo de upload
    uploadTask.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        uploadingImage = true;
        //print('uploading... $uploadingImage');
        notifyListeners();
      } else if (storageEvent.type == StorageTaskEventType.success) {
        uploadingImage = false;
        // print('uploading... $uploadingImage');

        notifyListeners();
      }
    });

    uploadTask.onComplete.then((StorageTaskSnapshot snapshot) async {
      String url = await snapshot.ref.getDownloadURL();
      setFotoUrlImagemAudio(url);

      notifyListeners();
    });
  }

  /*recuperar imagem da camera ou da galeria*/

  Future recuperarImagemCadastro(String origem, String colecao) async {
    File imagem;

    switch (origem) {
      case 'camera':
        imagem = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case 'galeria':
        imagem = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    salvarFotoCadastroFirestore(imagem, colecao);
  }

  /*recuperar imagem da camera ou da galeria
  -metodo usado tanto para foto do perfil, como para imagens nas
  -mensagens*/
  Future recuperarImagem(String origem, bool isPerfil) async {
    File imagem;

    switch (origem) {
      case 'camera':
        imagem = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case 'galeria':
        imagem = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }
    isPerfil
        ? salvarFotoFirestore(imagem)
        : salvarFotoAudioMensagemFirestore(
            imagem); //salva a imagem recuperada da camera ou da galeria
  }

  //recuperar contatos ordenados por nome
  static Future<List<Usuario>> getContatos() async {
    //retorna um snapShot de todos os usuarios
    QuerySnapshot querySnapshot =
        await firestore.collection('usuarios').orderBy('nome').getDocuments();

    List<Usuario> listUsuarios =
        List(); //preparo uma lista para receber os usuarios do snapShot

    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data; //dados recebe um Map<String,dynamic>

      if (dados['id'] == userID)
        continue; //se a condição é verdadeira, não inclue o usuario na lista

      Usuario usuario = Usuario(
          email: dados['email'],
          id: dados['id'],
          isAdmin: dados[
              'isAdmin']); //esses campos estão como requeridos na classe Usuario
      //se usuario não for true nas 3 perguntas, ele não participa do chat
      usuario.fotoUrl = dados['fotoUrl'];
      usuario.isAtivo = dados['isAtivo'];
      usuario.isDisponivel = dados['isDisponivel'];
      usuario.isMaior = dados['isMaior'];
      usuario.isResponsavel = dados['isResponsavel'];
      usuario.nome = dados['nome'];

      listUsuarios.add(usuario);
    }
    return listUsuarios;
  }

  //grava as mensagens digitadas pelos usuarios do batepapo
  static Future gravarMensagem(Map map, String idContato, bool isPapo) async {
    String colecao;

    isPapo ? colecao = 'conversas' : colecao = "mensagens";

    if (isPapo) {
      colecao = 'conversas';
      //saving in the userID folder
      await firestore
          .collection(colecao)
          .document(userID)
          .collection('ultima_conversa')
          .document(idContato)
          .setData(map);
      //saving in the IdContato folder
      await firestore
          .collection(colecao)
          .document(idContato)
          .collection('ultima_conversa')
          .document(userID)
          .setData(map);
    } else {
      colecao = 'mensagens';
      //saving in the userID folder
      await firestore
          .collection(colecao)
          .document(userID)
          .collection(idContato)
          .add(map);
      //saving in the IdContato folder
      await firestore
          .collection(colecao)
          .document(idContato)
          .collection(userID)
          .add(map); //todo: add or setdata?

    }
  }

  //recuperar mensagens gravadas ordenadas por data
  static Stream<QuerySnapshot> getMensagens(idContato, _controller) {
    //retorna um snapShot de todas mensagens
    Stream<QuerySnapshot> querySnapshot = firestore
        .collection('mensagens')
        .document(userID)
        .collection(idContato)
        .orderBy('dataMessage')
        .snapshots();

    querySnapshot.listen((dados) {
      _controller.add(dados);
    });

    return querySnapshot;
  }

  //recuperar produtos ativos
  static Future<List<Produto>> getProdutosAtivos() async {
    List<Produto> listGerProdutos=List();
    //retorna um snapShot de todos os produtos
    QuerySnapshot querySnapshot =
        await firestore.collection('produtos')
        .where('isAtivo', isEqualTo: true)
        //.where('categoria', isEqualTo:categoria)
        .getDocuments();
  

    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data; //dados recebe um Map<String,dynamic>

      /* if (dados['id'] == userID)
        continue; //se a condição é verdadeira, não inclue o usuario na lista */

      Produto produto = Produto(
        nomeProduto: dados['nome'],
        valorProduto:dados['valor'],
        valorMeioProduto:dados['valorMeio'],
        descrProduto: dados['descricao'],
        categoria: dados['categoria'],
        
        fotoUrl:dados['url'],);
     

      listGerProdutos.add(produto);
      listGeralProdutos=listGerProdutos;
    }
    listGeralProdutos=listGerProdutos;
    //notifyListeners();
    return listGerProdutos;
    
  }


//show message like snackbar
  static showFlushbar(BuildContext context, String mensagem) {
    Flushbar(
      message: mensagem,
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.redAccent,
    )..show(context);
  }

  List<Produto> getList(String nomeCategoria)  {//como rodar isso qdo houver clic em outra categoria?

    List<Produto> lProd = List();
    if (listGeralProdutos != null) {
      listGeralProdutos.forEach((value) {
        lProd.add(value);
        print(value);
      });
    }
//    setState(() {
//      listProdutos = lProd;
//    });

    return lProd;
  }


}
