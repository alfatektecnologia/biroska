import 'dart:async';

import 'package:biroska/models/wifi.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastroWifi extends StatefulWidget {
  @override
  _CadastroWifiState createState() => _CadastroWifiState();
}

class _CadastroWifiState extends State<CadastroWifi> {
  final Connectivity _connectivity = Connectivity();
  String _connectionStatus = 'Unknown';

  String wifiNome;

  @override
  void initState() {
    
    super.initState();
    initConnectivity();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiIP;

        try {
          wifiName = (await _connectivity.getWifiName()).toString();
        } catch (e) {
          print(e.toString());

          wifiName = "Failed to get Wifi Name";
        }

        try {
          wifiIP = (await _connectivity.getWifiIP()).toString();
        } catch (e) {
          print(e.toString());

          wifiName = "Failed to get Wifi IP";
        }

        setState(() {
          _connectionStatus = '$result\n'
              'Wifi Name: $wifiName\n'
              'Wifi IP: $wifiIP\n';
        });
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  getWifi() async {
    wifiNome = await Connectivity().getWifiName();
    print(wifiNome);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<WifiSetup>(
        builder: (BuildContext context, WifiSetup value, _) => Column(
          children: <Widget>[
            Text(
              (value.wifiName != null)
                  ? value.wifiName
                  : 'Não encontrado=> $WifiSetup.wifiID ',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(_connectionStatus,
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

/*todo: 
show actual wifi ssid 
compares with saved in firebase
and get user imput with the new ssid if needed  
and save/update to firebase*/
