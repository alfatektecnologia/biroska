import 'dart:io';
import 'package:biroska/chat/chat_index.dart';
import 'package:biroska/pages/delivery.dart';
import 'package:biroska/pages/eventos.dart';
import 'package:biroska/pages/homepage.dart';
import 'package:biroska/pages/pedidos.dart';
import 'package:biroska/pages/promotion.dart';
import 'package:biroska/pages/relatorios/relatorios_home.dart';
import 'package:biroska/utilitarios/utilitarios.dart';
import 'package:flutter/material.dart';
import 'package:biroska/pages/cadastros/cadastro_index.dart';

final util = Util();

class MenuBar extends StatelessWidget {
  final bool isAdmin;
  final context;

  const MenuBar({Key key, this.isAdmin, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAdmin ? menuAdmin() : menuGeral();
  }

  Widget menuGeral() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage(
                    'assets/images/logo_biroska.png',
                  )),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'oliveiraemanoel.br@gmail.com',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text("Menu"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(HomePage(Util.isAdmin), context);
            },
          ),
         /*  ListTile(
            leading: Icon(Icons.assignment),
            title: Text("Meus pedidos"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Pedidos(), context);
            },
          ), */
          ListTile(
            leading: Icon(Icons.mood),
            title: Text("Batepapo"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(ChatHome(), context);
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text("Eventos"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Eventos(), context);
            },
          ),
          /* ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text("Delivery"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Delivery(), context);
            },
          ), */
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text("Promoções"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Promotion(), context);
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text("Sair"),
            onTap: () => exit(0),
          ),
          
        ],
      ),
    );
  }

  Widget menuAdmin() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage(
                    'assets/images/logo_biroska.png',
                  )),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'oliveiraemanoel.br@gmail.com',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text("Menu"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(HomePage(Util.isAdmin), context);
            },
          ),
          /* ListTile(
            leading: Icon(Icons.assignment),
            title: Text("Meus pedidos"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Pedidos(), context);
            },
          ), */
          ListTile(
            leading: Icon(Icons.mood),
            title: Text("Batepapo"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(ChatHome(), context);
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text("Eventos"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Eventos(), context);
            },
          ),
          /* ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text("Delivery"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Delivery(), context);
            },
          ), */
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text("Promoções"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(Promotion(), context);
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text("Sair"),
            onTap: () => exit(0),
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: Text('Administração', style: TextStyle(color: Colors.white38)),
          ),
          ListTile(
            leading: Icon(Icons.playlist_add),
            title: Text("Cadastros"),
            onTap: () {
              Navigator.of(context)
                  .pop(); //close the menu before going to another page
              Util.gotoScreen(CadastroHome(), context);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Relatórios"),
            onTap: () {
              Navigator.of(context).pop();
              Util.gotoScreen(RelatoriosHome(), context);
            },
          ),
        ],
      ),
    );
  }
}
