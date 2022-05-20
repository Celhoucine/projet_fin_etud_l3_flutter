import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/agence/changepassword.dart';
import 'package:projet_fin_etud_l3_flutter/api/login-register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/offer_api.dart';
import 'editprofile.dart';

class profileagence extends StatefulWidget {
  const profileagence({Key? key}) : super(key: key);

  @override
  State<profileagence> createState() => _profileagenceState();
}

class _profileagenceState extends State<profileagence> {
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
  var path = 'http://192.168.1.62:8000/storage/images/OIP.png';
  var agenceinfo = [];

  @override
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(84, 140, 129, 1),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: ScreenHeight * 0.25,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(84, 140, 129, 1),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: ScreenHeight * 0.08,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Text(userprofile['fname'] +
                                    ' ' +
                                    userprofile['lname']),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                  child: Text(
                                      'ID : ' + userprofile['id'].toString()),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenHeight * 0.035,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: FlatButton(
                                color: Color(0xFFF5F6F9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('editprofileagency');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person),
                                      SizedBox(
                                        width: ScrrenWidth * 0.04,
                                      ),
                                      Expanded(child: Text('My Account')),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: ScreenHeight * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: FlatButton(
                                color: Color(0xFFF5F6F9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('ChangePassword');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.lock_rounded),
                                      SizedBox(
                                        width: ScrrenWidth * 0.04,
                                      ),
                                      Expanded(child: Text('Change Password')),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: ScreenHeight * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: FlatButton(
                                color: Color(0xFFF5F6F9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.contact_support_sharp),
                                      SizedBox(
                                        width: ScrrenWidth * 0.04,
                                      ),
                                      Expanded(child: Text('Help Center')),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: ScreenHeight * 0.02,
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
                                        width: ScrrenWidth * 0.04,
                                      ),
                                      Expanded(child: Text('Log Out')),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: ScreenHeight * 0.18,
                left: ScrrenWidth * 0.35,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(6, 64, 64, 1),
                      radius: ScrrenWidth * 0.16,
                      child: CircleAvatar(
                        radius: ScrrenWidth * 0.15,
                        backgroundImage: NetworkImage(path),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
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
                'phone': e['phone'],
                'profile_image': e['profile_image']
              })
          .toList();
      if (userprofile['profile_image'] == 'NO_IMAGE') {
        path = 'http://192.168.1.62:8000/storage/images/OIP.png';
      } else {
        path = 'http://192.168.1.62:8000/storage/images/' +
            userprofile['id'].toString() +
            '.png';
      }
    });
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await auth().logout(token, 'logout');

    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('login');
    }
  }
}
