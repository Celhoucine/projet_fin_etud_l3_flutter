import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projet_fin_etud_l3_flutter/api/login-register.dart';
import 'package:projet_fin_etud_l3_flutter/agence/home_agence.dart';
import 'package:projet_fin_etud_l3_flutter/client/home_client.dart';
import 'package:projet_fin_etud_l3_flutter/login.dart';
import 'package:projet_fin_etud_l3_flutter/register_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _view = login();
  preferences = await SharedPreferences.getInstance();
  var token = await preferences.getString('token');
  var mode = await preferences.getString('mode');
  if (token == null) {
    _view = login();
  } else {
    var response = await auth().loginwithtoken(token, 'user');
    if (response.statusCode == 200) {
      if (mode == 'client') {
        _view = home_client();
      }
      if (mode == 'agence') {
        _view = home_agence();
      }
    } else {
      _view = login();
    }
  }
  runApp(MyApp(_view));
}

class MyApp extends StatefulWidget {
  final Widget _view;
  const MyApp(this._view);

  @override
  State<MyApp> createState() => _MyAppState(this._view);
}

class _MyAppState extends State<MyApp> {
  @override
  late Widget _view;
  _MyAppState(_view) {
    this._view = _view;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: this._view,
      routes: {
        "register": (context) => register(),
        "login": (context) => login(),
        'home_client': (context) => home_client(),
        'home_agence': (context) => home_agence(),
      },
    );
  }
}
