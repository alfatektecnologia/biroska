import 'package:biroska/models/evento.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:biroska/widgets/menu_bar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroEventos extends StatefulWidget {
  @override
  _CadastroEventosState createState() => _CadastroEventosState();
}

class _CadastroEventosState extends State<CadastroEventos> {
  final _nomeController = TextEditingController();
  final _dateController = TextEditingController();
 GlobalKey<FormState> _eventoformKey = GlobalKey<FormState>();
 

  @override
  void dispose() {
    super.dispose();
    _nomeController.dispose();
    _dateController.dispose();

     }
//show message like snackbar
  void showFlushbar(BuildContext context) {
    Flushbar(
      message: 'Perfil salvo com sucesso!',
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.redAccent,
    )..show(context);
  }
  //saving and validating
  void validateDataAndSave(context) {
    final form = _eventoformKey.currentState;
    if (form.validate() && Util.urlImagemEvento != null) {
      print('Evento is valid');
      Evento evento = Evento(
        nomeEvento: _nomeController.text,
        dataEvento: _dateController.text,
        isAtivo: true,
        eventoUrl: Util.urlImagemEvento,
        userId: Util.userID,
        dataCadastro: DateTime.now().toString()
      );
      
                        
                        Util.salvarDadosCadastro("eventos", Util.userID, evento.toMap());
      //show message
      showFlushbar(context);
    } else {
      print('Evento is invalid');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _eventoformKey,
              child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /* Padding(
                padding: const EdgeInsets.only(left: 10, top: 16.0, bottom: 8),
                child: Text(
                  'Produto:',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ), */
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 8.0, right: 8),
                child: Consumer<Util>(
                  builder: (context, util, _) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Util.urlImagemEvento !=null
                            ?NetworkImage(Util.urlImagemEvento)
                            :AssetImage('assets/images/fachada.jpeg'),
                            fit: BoxFit.cover),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white24),
                    //padding: EdgeInsets.only(left: 16, right: 16),
                    height: 200,
                    //child: Image.asset('assets/images/fachada.jpeg',),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        util.recuperarImagemCadastro("camera", 'eventos');
                      },
                    ),
                    GestureDetector(
                        onTap: () =>
                            util.recuperarImagemCadastro("camera", 'eventos'),
                        child: Text('Camera')),
                    SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          util.recuperarImagemCadastro("galeria", 'eventos');
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () =>
                            util.recuperarImagemCadastro("galeria", 'eventos'),
                        child: Text('Galeria')),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.text,
                  controller: _nomeController,
                  validator: (value) => value.isEmpty ? 'Nome inválido!' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Nome do evento',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.datetime,
                  controller: _dateController,
                  validator: (value) => value.isEmpty ? 'Data inválida!' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Data do evento',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      elevation: 0,
                      onPressed: () {
                        validateDataAndSave(context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
