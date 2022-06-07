import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:projet_fin_etud_l3_flutter/client/search_resulta_map.dart';
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
    'all_categore': 'false',
    'wilaya': 'All',
    'distance': '0'
  };
  final Wilaya = [
    'All',
    'Adrar',
    'Aïn Defla',
    'Aïn Témouchent',
    'Algiers',
    'Annaba',
    'Batna',
    'Béchar',
    'Béjaïa',
    'Béni Abbès',
    'Biskra',
    'Blida',
    'Bordj Baji Mokhtar',
    'Bordj Bou Arréridj',
    'Bouïra',
    'Boumerdès',
    'Chlef',
    'Constantine',
    'Djanet',
    'Djelfa',
    'El Bayadh',
    'El M\'Ghair',
    'El Menia',
    'El Oued',
    'El Tarf',
    'Ghardaïa',
    'Guelma',
    'Guelma',
    'In Guezzam',
    'In Salah',
    'Jijel',
    'Khenchela',
    'Laghouat',
    'M\'Sila',
    'Mascara',
    'Médéa',
    'Mila',
    'Mostaganem',
    'Naâma',
    'Oran',
    'Ouargla',
    'Ouled Djellal',
    'Oum El Bouaghi',
    'Relizane',
    'Saïda',
    'Sétif',
    'Sidi Bel Abbès',
    'Skikda',
    'Souk Ahras',
    'Tamanrasset',
    'Tébessa',
    'Tiaret',
    'Timimoun',
    'Tindouf',
    'Tipaza',
    'Tissemsilt',
    'Tizi Ouzou',
    'Tlemcen',
    'Touggourt'
  ];

  String? selectwilaya = 'All';
  TextEditingController _surface_minController = new TextEditingController();
  TextEditingController _surface_maxController = new TextEditingController();
  TextEditingController _prix_minController = new TextEditingController();
  TextEditingController _prix_maxController = new TextEditingController();
  TextEditingController _categoreController = new TextEditingController();
  bool _val = false;
  var categories = [];
  String category_id = "1";
  double distance = 0;
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
        body: ListView(
          children: [
            Center(
              child: Container(
                width: ScreenWidth * 0.88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenHeight * 0.05,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: _val,
                            onChanged: (value) {
                              setState(() {
                                _val = !_val;
                                if (data['all_categore'] == 'true') {
                                  data['all_categore'] = 'false';
                                } else {
                                  data['all_categore'] = 'true';
                                }
                              });
                            }),
                        Text('Select all category')
                      ],
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
                                data['all_categore'] = 'false';
                                _val = false;
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
                      height: ScreenHeight * 0.01,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('Select a wilaya : '),
                          SizedBox(
                            width: ScreenWidth * 0.05,
                          ),
                          DropdownButton<String>(
                              menuMaxHeight: ScreenHeight * 0.4,
                              hint: Text('Select'),
                              value: selectwilaya,
                              items: Wilaya.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  selectwilaya = value;
                                  data['wilaya'] = selectwilaya!;
                                  print(selectwilaya);
                                });
                              })
                        ],
                      ),
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
                                data['surface_min'] =
                                    _surface_minController.text;
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
                                data['surface_max'] =
                                    _surface_maxController.text;
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
                      height: ScreenHeight * 0.05,
                    ),
                    Text('select distance:'),
                    Column(
                      children: [
                        Slider(
                          value: distance,
                          activeColor: Color.fromRGBO(6, 64, 64, 1),
                          inactiveColor: Color.fromRGBO(84, 140, 129, 100),
                          onChanged: (value) => setState(() {
                            this.distance = value;
                            data['distance'] = distance.toInt().toString();
                          }),
                          min: 0,
                          max: 200,
                          divisions: 200,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(distance.toInt().toString() + ' KM'),
                            Text('200 KM')
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenHeight * 0.05,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => search_results_map(
                                        data: data,
                                      )));
                        },
                        child: Container(
                            height: ScreenHeight * 0.045,
                            width: ScreenWidth * 0.3,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Color.fromRGBO(84, 140, 129, 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white60,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text('Map',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: Text("OR"),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Color.fromRGBO(84, 140, 129, 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white60,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text('List',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        print(categories);
      });
    }
  }
}
