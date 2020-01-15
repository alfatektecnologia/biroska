import 'package:flutter/cupertino.dart';

class WifiSetup with ChangeNotifier {
  String wifiName;
  String uidAdmin;
  static String wifiID;

  String _myKey = 'AIzaSyDDnYDA64F9dtc9Ef-I4HqFL4wKOJqg29E';

  WifiSetup({this.wifiName, this.uidAdmin});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"ssid": wifiName, "uid": uidAdmin};
    return map;
  }

  void updateWifi(String nome) {
    this.wifiName = nome;
    wifiID = nome;
    notifyListeners();
  }

  Future getWifiSSID() async {}

  getWifiNome() async {}
}
