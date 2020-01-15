import 'dart:io';

import 'package:biroska/models/erros.dart';
import 'package:biroska/pages/homepage.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:biroska/widgets/fachada.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  final Map dadosUsuario;

  Login(this.dadosUsuario);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  bool hasUser = false;
  bool isAdmin = false;
  bool hadErrorOnValidate = false;
  //Util util;

  String messageError;
  var result;
  var listener;
  final formKey =
      GlobalKey<FormState>(); //used to access Form and can validate TextForm
  final scaffoldKey =
      GlobalKey<ScaffoldState>(); //used to access to scaffold to use a snackbar

  void validateDataAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      print('Data is valid');
      hasUser
          ? signIn(_emailController.text, _senhaController.text)
          : createUser(_emailController.text, _senhaController.text);
    } else {
      hadErrorOnValidate = true;

      //salvando o erro na nuvem
      ErroReport erro = ErroReport(
        codigoErro:'erro validando dados' ,
        localErro: 'validadeDataAndSave',
        emailUser: _emailController.text ,
        date: DateTime.now() ,
        wasFixed: false,

      );
      Util.salvarErros(erro.toMap());

    }
  }

  //Show a message using a SnackBar
  void showMessage(String message) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  //Doing Authentication
  Future signIn(String email, String senha) async {
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((firebaseuser) {
      messageError = 'Autenticado com sucesso';
      //show snackbar
      showMessage(messageError);
      //userIsAdmin(user.uid);
      gotoPagina(context, HomePage(isAdmin));
    }).catchError((e) {

      //salvando o erro na nuvem
      ErroReport erro = ErroReport(
        codigoErro: e.toString() ,
        localErro: 'Login=>signIn',
        emailUser: _emailController.text ,
        date: DateTime.now() ,
        wasFixed: false,

      );
      Util.salvarErros(erro.toMap());

     // print('Falha na autenticação' + e.toString());
      //mostrarAlerta('Falha na autenticação. Verifique sua senha!');
      messageError = 'Falha na autenticação. Verifique sua senha!';
      //show snackbar
      showMessage(messageError);
    });
  }

  //Creating new general user
  Future createUser(String email, String senha) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((value) {
      messageError = 'Criado e Autenticado com sucesso';
      //show snackbar
      showMessage(messageError);

      gotoPagina(context, HomePage(isAdmin));
    }).catchError((e) {

      //salvando o erro na nuvem
      ErroReport erro = ErroReport(
        codigoErro: e.toString() ,
        localErro: 'Login=>createUser',
        emailUser: _emailController.text ,
        date: DateTime.now() ,
        wasFixed: false,

      );
      Util.salvarErros(erro.toMap());
      /*estou considerando que a senha nunca poderá estar errada, pois ainda não foi cadastrada */
      messageError = 'Erro no cadastramento. E-mail já cadastrado!';
      //show snackbar
      showMessage(messageError);

      print('Falha na criação' + e.toString());
    });
  }

  //send email if user has forgotten password
  void sendEmailWithPass() {
    if (hasUser) {
      _firebaseAuth.sendPasswordResetEmail(email: user.email).then((value) {
        messageError = 'Senha enviada para seu e-mail';
        showMessage(messageError);
      }).catchError((e) {

        //salvando o erro na nuvem
      ErroReport erro = ErroReport(
        codigoErro: e.toString() ,
        localErro: 'Login=>sendEmailWithPass',
        emailUser: _emailController.text ,
        date: DateTime.now() ,
        wasFixed: false,

      );
      Util.salvarErros(erro.toMap());
        messageError = 'Falha no re-envio de senha!';
        showMessage(messageError);
      });
    } else {
      messageError = 'Usuário não cadastrado';
      showMessage(messageError);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    hasInternet();
    setState(() {
      //check if exist a user throw the email sent by Main method
      if (widget.dadosUsuario['user'] != null) {
        user = widget.dadosUsuario['user'];
        _emailController.text = user.email;
        isAdmin = widget.dadosUsuario['admin'];
        hasUser = true;
      }
    });
    super.initState();
  }

  gotoPagina(BuildContext context, Widget pagina) {
    Route route = MaterialPageRoute(builder: (context) => pagina);
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blueGrey,
      //bottomNavigationBar: BottomNavigationBar(items: null) ,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Fachada(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffffffff)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onTap: () {
                        if (hadErrorOnValidate) {
                          formKey.currentState.reset();
                          hadErrorOnValidate = false;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) =>
                          value.isEmpty || !value.contains('@')
                              ? 'E-mail inválido!'
                              : null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'E-mail',
                          errorStyle:
                              TextStyle(color: Color(0xffbb002f), fontSize: 15),
                          labelStyle: TextStyle(color: Colors.blueGrey)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffffffff)), //(0xff801935)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      keyboardType: TextInputType.text,
                      controller: _senhaController,
                      validator: (value) => value.isEmpty || value.length < 6
                          ? 'Senha inválida!'
                          : null,
                      obscureText: true,
                      onTap: () {
                        if (hadErrorOnValidate) {
                          formKey.currentState.reset();
                          hadErrorOnValidate = false;
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Senha (min 6 dígitos)',
                          errorStyle:
                              TextStyle(color: Color(0xffbb002f), fontSize: 15),
                          labelStyle: TextStyle(color: Colors.blueGrey)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.lime,
                  ), //(0xff801935)),
                  child: FlatButton(
                      child: Center(
                        child: Text(
                          hasUser
                              ? 'Login'.toUpperCase()
                              : 'Cadastrar'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.black, //(0xff801935),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: validateDataAndSave),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  onPressed: sendEmailWithPass,
                  child: Text(
                    'esqueci a senha...',
                    style: TextStyle(color: Colors.white),
                  )) //(0xff801935)),))
            ],
          ),
        ),
      ),
    );
  }

//check if has a valid internet connection
  Future hasInternet() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          mostrarAlerta('Verifique sua conexão com a internet!', context);

          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  mostrarAlerta(String message, context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Alerta',
                style: TextStyle(color: Colors.black, fontSize: 40),
              ),
              content: Text(
                message,
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: FlatButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      exit(0);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
              elevation: 16,
              backgroundColor: Colors.white,
              //shape: CircleBorder(),
            ));
  }
}
