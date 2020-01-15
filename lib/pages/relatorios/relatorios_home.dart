import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelatoriosHome extends StatefulWidget {
  @override
  _RelatoriosHomeState createState() => _RelatoriosHomeState();
}

class _RelatoriosHomeState extends State<RelatoriosHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Relatórios",
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),

      ),
      body: Center(
        child: Container(
          child: Text('Relatórios'),
        ),
      ),
    );
  }
}