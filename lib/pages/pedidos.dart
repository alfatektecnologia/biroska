import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pedidos",
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),

      ),
      body: Center(
        child: Container(
          child: Text('Pedidos'),
        ),
      ),
    );
  }
}