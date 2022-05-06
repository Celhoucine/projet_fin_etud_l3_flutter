import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltterOffer extends StatefulWidget {
  const FiltterOffer({Key? key}) : super(key: key);

  @override
  State<FiltterOffer> createState() => _FiltterOfferState();
}

class _FiltterOfferState extends State<FiltterOffer> {
  @override
  void initState() {
    _loadCategories();
    super.initState();
  }

  var data = {
    'description': '',
    'min_surface': '',
    'max_surface': '',
    'min_price': '',
    'max_price': '',
    'categorie': '1',
  };
  var categories = [];
  String category_id = "1";
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Search for offer',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Container(
            width: ScreenWidth * 0.88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenHeight * 0.15,
                ),
                Row(
                  children: [
                    Text('Select category  : '),
                    SizedBox(
                      width: ScreenWidth * 0.05,
                    ),
                    Container(
                      width: ScreenWidth * 0.3,
                      child: DropdownButton(
                        hint: Text('Select'),
                        items: categories.map((item) {
                          return new DropdownMenuItem(
                            child: Text(item['name']),
                            value: item['id'].toString(),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            category_id = value.toString();
                            data['categorie'] = category_id;
                          });
                        },
                        value: category_id,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenHeight * 0.05,
                ),
                Text('Price range :'),
                SizedBox(
                  height: ScreenHeight * 0.01,
                ),
                Row(
                  children: [
                    Text('Min : '),
                    Container(
                      width: ScreenWidth * 0.23,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            data['min_price'] = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          suffix: Text('DA'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenWidth * 0.15,
                    ),
                    Text('Max : '),
                    Container(
                      width: ScreenWidth * 0.23,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            data['Max_price'] = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          suffix: Text('DA'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenHeight * 0.05,
                ),
                Text('Surface :'),
                SizedBox(
                  height: ScreenHeight * 0.01,
                ),
                Row(
                  children: [
                    Text('Min : '),
                    Container(
                      width: ScreenWidth * 0.23,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            data['min_surface'] = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          suffix: Text('m²'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenWidth * 0.15,
                    ),
                    Text('Max : '),
                    Container(
                      width: ScreenWidth * 0.23,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            data['max_surface'] = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          suffix: Text('m²'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await offerApi().getcategory('getCategories', token);
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    }
  }
}
