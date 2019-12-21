import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  LocationData currentLocation;

  var location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
  Future<LocationData> getMapLocation() async {
    var currentLocation2;
    try {
      currentLocation2 = await location.getLocation();
      setState(() {
        if(mounted){
currentLocation = currentLocation2;
        }
        
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return currentLocation2;
  }

  @override
  void initState() {
    super.initState();
    getMapLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Container(
          child: Text(
            currentLocation.latitude.toString()+' '+ currentLocation.longitude.toString(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ]),
    );
  }
}
