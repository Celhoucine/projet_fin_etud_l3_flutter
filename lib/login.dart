import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:projet_fin_etud_l3_flutter/api/login-register.dart';
import 'main.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  @override
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('email or password incorrect'),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  login() async {
    var data = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    final response = await auth().login(data, 'login');
    var info = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('user authenticated.');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', info['token']);
      prefs.setString('mode', info['mode']);
      if (info['mode'] == 'agence') {
        Navigator.of(context).pushNamed('home_agence');
      } else {
        Navigator.of(context).pushNamed('home_client');
      }
    } else {
      showSnackBar(context);
      print('authentication failed');
    }
  }

  final _Form = new GlobalKey<FormState>();
  late var FormData = _Form.currentState;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool obscureText = true;
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        body: ListView(children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: ScreenHeight * 0.037,
                ),
                Container(
                  width: ScrrenWidth * 0.60,
                  height: ScreenHeight * 0.25,
                  child: Image(
                    image: AssetImage('assets/logo3.webp'),
                  ),
                ),
                SizedBox(height: ScreenHeight * 0.05),
                Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: ScreenHeight * 0.05,
                ),
                Form(
                    key: _Form,
                    child: Column(
                      children: [
                        Container(
                          width: ScrrenWidth * 0.8,
                          height: ScreenHeight * 0.09,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                label: Text('Email'),
                                hintText: 'Enter your Email',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            validator: (email) {
                              if (GetUtils.isEmail(email!)) {
                                return null;
                              } else {
                                return 'email not valide';
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: ScreenHeight * 0.008,
                        ),
                        Container(
                          width: ScrrenWidth * 0.8,
                          height: ScreenHeight * 0.075,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                                suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                    icon: Icon(obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                label: Text('Password'),
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            validator: (password) {
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: ScreenHeight * 0.03,
                        ),
                        RaisedButton(
                            color: Color.fromRGBO(84, 140, 129, 1),
                            child: Text(
                              'sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (FormData!.validate()) {
                                login();
                              }
                              ;
                            }),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onTap: () {
                              //go to forget page
                            },
                            child: Text(
                              'Forget your password?',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: ScrrenWidth * 0.6,
                          height: ScreenHeight * 0.0005,
                          color: Colors.black87,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('if you don\'t have Account'),
                        ),
                        RaisedButton(
                          color: Color.fromRGBO(84, 140, 129, 1),
                          onPressed: () {
                            Navigator.of(context).pushNamed('register');
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          )
        ]),
      )),
    );
  }
}
