import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
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