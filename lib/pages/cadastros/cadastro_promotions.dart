import 'package:biroska/models/promotion.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:biroska/widgets/menu_bar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroPromotions extends StatefulWidget {
  @override
  _CadastroPromotionsState createState() => _CadastroPromotionsState();
}

class _CadastroPromotionsState extends State<CadastroPromotions> {
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();
  final _valorMeiaController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nomeController.dispose();
    _valorController.dispose();
    _valorMeiaController.dispose();
  }

//show message like snackbar
  void showFlushbar(BuildContext context, String mensagem) {
    Flushbar(
      message: mensagem,
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.redAccent,
    )..show(context);
  }

  //saving and validating
  void validateDataAndSave(context) {
    final form = _formKey.currentState;
    if (form.validate() && Util.urlImagemCadastro != null) {
      print('Promotion is valid');
      var dateTime = DateTime.now();
      Promotion promotion = Promotion(
          produto: _nomeController.text,
          valor: double.parse(_valorController.text),
          valorMeia:double.parse(_valorMeiaController.text),
          url: Util.urlImagemCadastro,
          isAtivo: true,
          userId: Util.userID,
          date: dateTime);

      Util.salvarDados("promotions", Util.userID, promotion.toMap());
      //show message
      showFlushbar(context, 'Promoção salva com sucesso!');
      Util.urlImagemCadastro = null;
      setState(() {
        //limpar caixa de textos
        _nomeController.text = "";
        _valorController.text = '';
        _valorMeiaController.text = '';
      });
    } else {
      print('Promotion is invalid');
      //show message
      showFlushbar(context, 'Falha! Verifique os dados da promoção!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 8.0, right: 8),
                child: Consumer<Util>(
                  builder: (context, util, _) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Util.urlImagemCadastro != null
                                ? NetworkImage(Util.urlImagemCadastro)
                                : AssetImage(
                                    'assets/images/lambe_lambe-23.jpg'),
                            fit: BoxFit.fill),
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
                  validator: (value) =>
                      value.isEmpty ? 'Nome inválido de produto!' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Nome do produto',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _valorController,
                  validator: (value) =>
                      value.isEmpty ? 'Valor inválido!' : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Valor 1/1 do produto. Ex.: 10.00',
                      errorStyle:
                          TextStyle(color: Color(0xffbb002f), fontSize: 15),
                      labelStyle: TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _valorMeiaController,
                  /* validator: (value) =>
                      value== ? 'Valor inválido!' : null, */
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: 'Valor 1/2 do produto. Ex.: 8.00',
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
