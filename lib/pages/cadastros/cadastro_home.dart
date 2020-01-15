import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cadastro_index.dart';


class CadastroHome extends StatefulWidget {
  @override
  _CadastroHomeState createState() => _CadastroHomeState();
}

class _CadastroHomeState extends State<CadastroHome> with SingleTickerProviderStateMixin {
    
    TabController _tabController;

    @override void initState() {
    
    super.initState();
    _tabController = TabController(vsync: this,length: 6,initialIndex: 0);


  }
@override void dispose() {
    
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cadastros',
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),
        backgroundColor: Colors.black,
        bottom: TabBar(
          isScrollable:true ,
          controller: _tabController,
          tabs: <Widget>[
            
            Text('Usuários',
            style: TextStyle(fontSize: 15),),
            Text('Produtos',
            style: TextStyle(fontSize: 15),),
            Text('Eventos',
            style: TextStyle(fontSize: 15),),
            Text('Promoções',
            style: TextStyle(fontSize: 15),),
            Text('Wifi',
            style: TextStyle(fontSize: 15),),
            Text('Map',
            style: TextStyle(fontSize: 15),),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.black, Colors.grey])),
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    CadastroUsuarios(),
                    CadastroProdutos(),
                    CadastroEventos(),
                    CadastroPromotions(),
                    CadastroWifi(),
                    MapSample()
                  ],),
      ),
    );
  }
}