import 'dart:io';

import 'package:biroska/app_state.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_extend/share_extend.dart';


class ChatCamera extends StatefulWidget {


  const ChatCamera({Key key,}) : super(key: key);
  @override
  _ChatCameraState createState() => _ChatCameraState();
}

class _ChatCameraState extends State<ChatCamera> {
  var appState = AppState();

  File imagem, myFile;
  var foto;
  

  @override
  void initState() {
    super.initState();

    myCameras();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imagem != null
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.file(myFile),
                IconButton(
                  onPressed: () {
                   ShareExtend.share(myFile.path,'images');
                  },
                  icon: Icon(Icons.share),
                )
              ],
            ),
          )
        : Center(
            child: Container(
                child: Text('Carregando imagem...',
                    style: TextStyle(color: Colors.white, fontSize: 20))));
  }

  Future<File> myCameras() async {
    imagem = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      myFile = imagem;
    });
    return imagem;
  }

  Future<File> myGallery() async {
    imagem = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    return imagem;
  }
}
