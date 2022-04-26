import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class detailoffer extends StatefulWidget {
  int id;
  detailoffer({Key? key, required this.id}) : super(key: key);

  @override
  State<detailoffer> createState() => _detailofferState();
}

class _detailofferState extends State<detailoffer> {
  @override
  void initState() {
    getoffer(widget.id);
    super.initState();
  }

  Map<String, dynamic> offerDetail = {
    'description': '',
    'surface': '',
    'prix': '',
    'email': '',
    'phone': '',
    'location': '',
    'categorie': '',
    'created_at': '',
    'agenceName': ''
  };
  var numberformatter = NumberFormat("#''###", "en_US");
  var info = [];
  @override
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Container(
                  width: ScrrenWidth,
                  height: ScreenHeight * 0.3,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: Text(
                          offerDetail['categorie'],
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: ScrrenWidth * 0.06),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: Text(
                          offerDetail['surface'].toString() + ' m²',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: Text(
                         numberformatter.format( 11111111),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  getoffer(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await offerApi().getofferdata('getDetailoffer/${id}', token);
    setState(() {
      info = jsonDecode(response.body);
      info = info
          .map((e) => offerDetail = {
                'description': e['description'],
                'surface': e['surface'],
                'prix': e['prix'],
                'email': e['email'],
                'phone': e['phone'],
                'location': e['location'],
                'categorie': e['name'],
                'created_at': e['created_at'],
                'agenceName': e['agenceName']
              })
          .toList();
    });
  }
}
