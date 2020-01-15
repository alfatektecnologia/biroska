import 'package:flutter/material.dart';

class CadastroUsuarios extends StatefulWidget {
  @override
  _CadastroUsuariosState createState() => _CadastroUsuariosState();
}

class _CadastroUsuariosState extends State<CadastroUsuarios> {
  final _nomeController = TextEditingController();

  @override
  void dispose() {
    
    super.dispose();
    _nomeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 16.0, bottom: 8),
              child: Text(
                'Cadastrados:',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white24),
                  padding: EdgeInsets.only(left: 16, right: 16),
                  height: 100,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Fulano de tal'),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                keyboardType: TextInputType.emailAddress,
                controller: _nomeController,
                validator: (value) => value.isEmpty ? 'Nome inválido!' : null,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    labelText: 'Nome',
                    errorStyle:
                        TextStyle(color: Color(0xffbb002f), fontSize: 15),
                    labelStyle: TextStyle(color: Colors.green)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                keyboardType: TextInputType.emailAddress,
                controller: _nomeController,
                validator: (value) => value.isEmpty ? 'Nome inválido!' : null,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    labelText: 'Nome',
                    errorStyle:
                        TextStyle(color: Color(0xffbb002f), fontSize: 15),
                    labelStyle: TextStyle(color: Colors.green)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                keyboardType: TextInputType.emailAddress,
                controller: _nomeController,
                validator: (value) => value.isEmpty ? 'Nome inválido!' : null,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    labelText: 'Nome',
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
                    onPressed: () {},
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*atenção:usuario já pode ter se cadastrado como usuario comum...
-listar cadastrados
-ao clicar no cadastrado, preencher automaticamento os campos do formulário
-isfuncionario/time/parceiros
-setor
-isadmin?
-isativo?
-

*/
