import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:projet_fin_etud_l3_flutter/agence/editprofile.dart';
import 'package:projet_fin_etud_l3_flutter/agence/failed.dart';
import 'package:projet_fin_etud_l3_flutter/agence/postadd.dart';
import 'package:projet_fin_etud_l3_flutter/agence/profileagence.dart';
import 'package:projet_fin_etud_l3_flutter/agence/success.dart';
import 'package:projet_fin_etud_l3_flutter/agence/updateoffer.dart';
import 'package:projet_fin_etud_l3_flutter/api/login-register.dart';
import 'package:projet_fin_etud_l3_flutter/agence/home_agence.dart';
import 'package:projet_fin_etud_l3_flutter/client/client_edit_profile_success.dart';
import 'package:projet_fin_etud_l3_flutter/client/clientchangepassword.dart';
import 'package:projet_fin_etud_l3_flutter/client/editclientprofile.dart';
import 'package:projet_fin_etud_l3_flutter/client/failedclient.dart';
import 'package:projet_fin_etud_l3_flutter/client/filtteroffer.dart';
import 'package:projet_fin_etud_l3_flutter/client/home_client.dart';
import 'package:projet_fin_etud_l3_flutter/client/profileclient.dart';
import 'package:projet_fin_etud_l3_flutter/login.dart';
import 'package:projet_fin_etud_l3_flutter/register_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'agence/changepassword.dart';

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
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp(_view));
}

class MyApp extends StatefulWidget {
  final Widget _view;
  const MyApp(this._view);

  @override
  State<MyApp> createState() => _MyAppState(this._view);
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    getper();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  late Widget _view;
  _MyAppState(_view) {
    this._view = _view;
  }
  late int id;
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: this._view,
      routes: {
        "register": (context) => register(),
        "login": (context) => login(),
        'home_client': (context) => home_client(),
        'home_agence': (context) => home_agence(),
        'postadd': (context) => postadd(),
        'editprofileagency': (context) => editprofile(),
        'ChangePassword': (context) => changepassword(),
        'changeClientpassword': (context) => changeClientpassword(),
        'success': (context) => success(),
        'profileagence': (context) => profileagence(),
        'editprofileclient': (context) => editclientprofile(),
        'profileclient': (context) => profileclient(),
        'profileclientsuccess': (context) => editeclientsuccess(),
        'failed': (context) => failedpage(),
        'failedClient': (context) => failedpageClient(),
        'updateoffer': (context) => UpdateOffer(),
        'filtteroffer': (context) => FiltterOffer()
      },
    );
  }

  Future getper() async {
    bool services;
    LocationPermission per;
    per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied ||
        per == LocationPermission.deniedForever) {
      per = await Geolocator.requestPermission();
      if (per == LocationPermission.denied ||
          per == LocationPermission.deniedForever) {
        exit(0);
      }
    }
  }
}
