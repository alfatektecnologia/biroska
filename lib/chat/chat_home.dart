import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_camera.dart';
import 'chat_contatos.dart';
import 'chat_messages.dart';
import 'chat_profile.dart';

class ChatHome extends StatefulWidget {
  

  
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> with SingleTickerProviderStateMixin {
  TabController _tabController;
  
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
    
  }


  @override
  void dispose() {
    
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Batepapo',
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),
        backgroundColor: Colors.black,
        bottom: TabBar(
          
          isScrollable: true,
          controller: _tabController,
          labelPadding: EdgeInsets.symmetric(horizontal: 10),
          tabs: <Widget>[
            Icon(Icons.camera_alt),
            Text('Perfil'.toUpperCase(),
            style: TextStyle(fontSize:17),),
            Text('Conversas'.toUpperCase(),
            style: TextStyle(fontSize:17),),
            Text('Contatos'.toUpperCase(),
            style: TextStyle(fontSize:17),),
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
                  //physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    ChatCamera(),
                    ChatPerfil(),
                    ChatConversas(),
                    ChatContatos(),
                  ],),
      ),
    );
  }
}
/* todo: 
tabsViews
recuperar o id do usuario
exigir foto 
tirar a foto utilizando a camera
recuperar essa foto
salvar essa foto e usuario
salvar as configurações desse usuario


*/