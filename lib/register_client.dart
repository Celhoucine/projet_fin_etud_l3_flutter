import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:projet_fin_etud_l3_flutter/api/login-register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Client extends StatefulWidget {
  const Client({Key? key}) : super(key: key);

  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {
  @override
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('email already exsist'),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  register() async {
    var data = {
      'firstName': fnameController.text,
      'lastName': lnameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': passwordController.text,
      'mode': 'client'
    };
    var response = await auth().register(data, 'Clientregister');
    var info = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', info['token']);
      prefs.setString('mode', 'client');
      Navigator.of(context).pushNamed('home_client');
    } else {
      showSnackBar(context);
    }
  }

  final _RegisterClientForm = new GlobalKey<FormState>();
  late var formData = _RegisterClientForm.currentState;
  bool modeClient = true;
  bool modeAgency = false;
  bool obscureText = true;
  bool obscureText1 = true;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController CpasswordController = new TextEditingController();

  Widget build(BuildContext context) {
    final Screenwidth = MediaQuery.of(context).size.width;
    final Screenheight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Form(
          key: _RegisterClientForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0),
                child: Text('first-name'),
              ),
              Container(
                width: Screenwidth * 0.8,
                height: Screenheight * 0.09,
                child: TextFormField(
                  controller: fnameController,
                  decoration: InputDecoration(
                      hintText: 'Enter your first name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('last-name'),
              ),
              Container(
                width: Screenwidth * 0.8,
                height: Screenheight * 0.09,
                child: TextFormField(
                  controller: lnameController,
                  decoration: InputDecoration(
                      hintText: 'Enter your last name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              ////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Email'),
              ),
              Container(
                width: Screenwidth * 0.8,
                height: Screenheight * 0.09,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  validator: (email) {
                    if (GetUtils.isEmail(email!)) {
                      return null;
                    } else {
                      return 'this is wrong email';
                    }
                  },
                ),
              ),
              /////////////////
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Password'),
              ),
              Container(
                width: Screenwidth * 0.8,
                height: Screenheight * 0.075,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: obscureText,
                  controller: passwordController,
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
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  validator: (password) {
                    if (password!.length >= 8) {
                      return null;
                    } else {
                      return ' password must be at least 8 characters ';
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(' Confirm Password'),
              ),
              Container(
                width: Screenwidth * 0.8,
                height: Screenheight * 0.075,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: obscureText1,
                  controller: CpasswordController,
                  decoration: InputDecoration(
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText1 = !obscureText1;
                            });
                          },
                          icon: Icon(obscureText1
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      hintText: 'Enter your password again',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  validator: (confirmpass) {
                    if (CpasswordController.text == passwordController.text) {
                      return null;
                    } else {
                      return 'please confirm your password';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: RaisedButton(
              color: Color.fromRGBO(84, 140, 129, 1),
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (formData!.validate()) {
                  register();
                }
              }),
        ),
        Container(
          width: Screenwidth * 0.6,
          height: 0.5,
          color: Colors.black87,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('if you  have Account'),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: RaisedButton(
            color: Color.fromRGBO(84, 140, 129, 1),
            onPressed: () {
              Navigator.of(context).pushNamed('login');
            },
            child: Text(
              "login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
