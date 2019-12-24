import 'package:biroska/app_state.dart';
import 'package:biroska/models/wifi.dart';
import 'package:biroska/pages/homepage.dart';
import 'package:biroska/pages/login.dart';
import 'package:biroska/utilitarios/utilitarios.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  /* Error -32601 received from application: Method not found
  * esse erro acontece quando o main() tem um processo async
  * e não é executado corretamente.
  * esse comando resolve o problema: WidgetsFlutterBinding.ensureInitialized();*/

  WidgetsFlutterBinding.ensureInitialized();

  var resultFromGetUser = await Util.getCurrentUserStatus();

  /*fixar a orientação em modo portrait */
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(resultFromGetUser));
  });
}

class MyApp extends StatefulWidget {
  final Map usuario;

  MyApp(this.usuario);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var initialPage; //defines initial page to home:
  @override
  void initState() {
    super.initState();
    initialPage = checaUser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<WifiSetup>(
          create: (_) => WifiSetup(),
        ),
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<Util>(
          create: (_) => Util(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Biroska do Carlão',
        theme: ThemeData.dark(),
        home: initialPage,
        //home: Login(),
      ),
    );
  }

  Widget checaUser() {
    //if user is Admin must login
    Widget result = Login(
        widget.usuario); //seta como default a pagina de login para user admin
    if (widget.usuario['user'] != null) {
      //checa se existe usuario autenticado
      if (!widget.usuario['admin']) {
        result = HomePage(false);
        return result;
      }
    } else {
      result = Login(widget.usuario);
      return result;
    }
    return result;
  }
}
