import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Promotion extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Promoções",
            style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(color: Colors.white, fontSize: 25))),

      ),
      body: Center(
        child: Container(
          child: Text('Promoções'),
        ),
      ),
    );
  }
}
