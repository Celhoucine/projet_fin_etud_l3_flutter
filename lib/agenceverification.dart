import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/login-register.dart';

class verification extends StatefulWidget {
  const verification({Key? key}) : super(key: key);

  @override
  State<verification> createState() => _verificationState();
}

class _verificationState extends State<verification> {
  @override
  void initState() {
    getprofiledata();

    super.initState();
  }

  Map<String, dynamic> userprofile = {
    'id': '',
    'lname': '',
    'fname': '',
    'email': '',
    'agenceName': '',
    'address': '',
    'phone': ''
  };
  var agenceinfo = [];
  @override
  Widget build(BuildContext context) {
    final Screenwidth = MediaQuery.of(context).size.width;
    final Screenheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Screenheight * 0.1,
              color: Color.fromRGBO(84, 140, 129, 1),
              width: Screenwidth,
            ),
            Container(
              color: Color.fromRGBO(84, 140, 129, 1),
              width: Screenwidth,
              height: Screenheight * 0.15,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Welcome',
                    style: TextStyle(
                        color: Color.fromARGB(221, 252, 252, 252),
                        fontSize: 45)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('Dear ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  Text(userprofile['fname'] + '  ',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  Text(userprofile['lname'],
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Container(
                height: 2,
                color: Colors.black,
                width: Screenwidth * 0.99,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Text('Your account will be verified after 24H',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('For more details please contact us ',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            SizedBox(
              height: Screenheight * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: FlatButton(
                  color: Color(0xFFF5F6F9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    calling();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.call),
                        SizedBox(
                          width: Screenwidth * 0.04,
                        ),
                        Expanded(child: Text('+213659298657')),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: Screenheight * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: FlatButton(
                  color: Color(0xFFF5F6F9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    email();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.mail),
                        SizedBox(
                          width: Screenwidth * 0.04,
                        ),
                        Expanded(child: Text('hyyugyhu@gmail.com')),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              height: Screenheight * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: FlatButton(
                  color: Color(0xFFF5F6F9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    logout();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(
                          width: Screenwidth * 0.04,
                        ),
                        Expanded(child: Text('Log Out')),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await auth().logout(token, 'logout');

    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('login');
    }
  }

  getprofiledata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().getprofile(token, 'agenceinfo');
    setState(() {
      agenceinfo = jsonDecode(response.body);
      agenceinfo = agenceinfo
          .map((e) => userprofile = {
                'id': e['id'],
                'lname': e['lname'],
                'fname': e['fname'],
                'email': e['email'],
                'agenceName': e['agenceName'],
                'address': e['address'],
                'phone': e['phone']
              })
          .toList();
    });
  }

  email() async {
    final toemail = 'hyyugyhu@gmail.com';
    final subj = '';
    final messa = '';
    var _emailurl =
        'mailto:$toemail?subject=${Uri.encodeFull(subj)}&body=${Uri.encodeFull(messa)}';
    if (await canLaunch(_emailurl.toString())) {
      await launch(_emailurl.toString());
    } else {
      throw 'Could not launch $_emailurl';
    }
  }

  calling() async {
    var url = 'tel:+213659298657';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
