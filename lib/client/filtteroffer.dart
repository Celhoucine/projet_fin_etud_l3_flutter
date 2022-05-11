import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/api/login-register.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:projet_fin_etud_l3_flutter/client/search_results.dart';
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
    'surface_min': '',
    'surface_max': '',
    'prix_min': '',
    'prix_max': '',
    'categore': '1',
  };
  TextEditingController _surface_minController = new TextEditingController();
  TextEditingController _surface_maxController = new TextEditingController();
  TextEditingController _prix_minController = new TextEditingController();
  TextEditingController _prix_maxController = new TextEditingController();
  TextEditingController _categoreController = new TextEditingController();

  var categories = [];
  String category_id = "1";
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
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
                            data['categore'] = category_id;
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
                        controller: _prix_minController,
                        onChanged: (value) {
                          setState(() {
                            data['prix_min'] = _prix_minController.text;
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
                        controller: _prix_maxController,
                        onChanged: (value) {
                          setState(() {
                            data['prix_max'] = _prix_maxController.text;
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
                        controller: _surface_minController,
                        onChanged: (value) {
                          setState(() {
                            data['surface_min'] = _surface_minController.text;
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
                        controller: _surface_maxController,
                        onChanged: (value) {
                          setState(() {
                            data['surface_max'] = _surface_maxController.text;
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
                ),
                SizedBox(
                  height: ScreenHeight * 0.1,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      print(data);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => searchresults(
                                    data: data,
                                  )));
                    },
                    child: Container(
                        height: ScreenHeight * 0.045,
                        width: ScreenWidth * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Color.fromRGBO(84, 140, 129, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white60,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text('Search'),
                            ),
                          ],
                        )),
                  ),
                ),
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
