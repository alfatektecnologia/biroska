import 'package:flutter/material.dart';

class Fachada extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(

                  color: Color(0xff00bb8c),
                  
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                   // bottomRight: Radius.circular(60),
                  )),
            ),
            Positioned(
              top: 240 * 0.3,
              left: MediaQuery.of(context).size.width * 0.20,
              child: Image.asset('assets/images/logo_biroska.png',
                height: 120,
              ),
            )
          ],
        ),
      ],
    );
  }
}
