import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Eventos extends StatefulWidget {
  @override
  _EventosState createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Delivery",
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),

      ),
      body: Center(
        child: Container(
          child: Text('Delivery'),
        ),
      ),
    );
  }
}