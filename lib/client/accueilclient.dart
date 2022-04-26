import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:projet_fin_etud_l3_flutter/client/detail_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/login-register.dart';

class accueilclient extends StatefulWidget {
  const accueilclient({Key? key}) : super(key: key);

  @override
  State<accueilclient> createState() => _accueilclientState();
}

class _accueilclientState extends State<accueilclient> {
  @override
  bool offerList = true;
  bool offerCart = false;
  var sort = 'getoffer';
  final ListviewController = ScrollController();

  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: ScreenHeight * 0.13,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.grey[300],
                        width: ScrrenWidth * 0.7,
                        height: ScreenHeight * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: InkWell(
                          onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => BuildSheet()),
                          child: Row(
                            children: [
                              Text('Sort',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Icon(Icons.sort),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              offerList = true;
                              offerCart = false;
                            });
                          },
                          child: Text(
                            'List',
                            style: TextStyle(
                                color: offerList
                                    ? Color.fromRGBO(84, 140, 129, 1)
                                    : Colors.black45,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                          height: ScreenHeight * 0.035,
                          width: 2,
                          color: Colors.grey[300],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              offerList = false;
                              offerCart = true;
                            });
                          },
                          child: Text('Map',
                              style: TextStyle(
                                  color: offerCart
                                      ? Color.fromRGBO(84, 140, 129, 1)
                                      : Colors.black45,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))
                    ],
                  ),
                )
              ],
            )),
        body: ListView(
          controller: ListviewController,
          children: [
            Center(
              child: offerList
                  ? Container(width: ScrrenWidth * 0.95, child: OffersList())
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget OffersList() {
    return FutureBuilder<List<OfferInfo>>(
        future: getOffer(sort),
        builder: ((context, snapshot) {
          final offers = snapshot.data;

          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: offers!.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Offer(offer);
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: const CircularProgressIndicator());
        }));
  }

  Widget Offer(OfferInfo offer) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => detailoffer(id: offer.id)));
        },
        child: Container(
          height: ScreenHeight * 0.42,
          decoration: BoxDecoration(
              color: Colors.white,
  
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 6,
                    blurRadius: 8,
                    offset: Offset(0, 4))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ScreenHeight * 0.26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                      image: AssetImage('assets/oip2.jfif'), fit: BoxFit.cover),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 1, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                             Text(
                          formatter
                              .format(DateTime.tryParse(offer.created_at)
                                  as DateTime)
                              .toString(),
                          style: TextStyle(
                            color:Colors.black54,
                              fontSize: 11, ),
                        ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 4, 0,0),
                            child: Text(
                              offer.categorie,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight:FontWeight.w400                            ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenHeight * 0.007,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                size: ScrrenWidth * 0.035,
                                color: Color.fromRGBO(84, 140, 129, 0.5),
                              ),
                              Text(
                                ' Khenchela',
                                style: TextStyle(
                                  fontSize: 13,
                                  
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: ScreenHeight * 0.008,
                            ),
                            Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: ScrrenWidth * 0.035,
                                color: Colors.orangeAccent[100],
                              ),
                              Text(
                                ' hacen',
                                style: TextStyle(
                                  fontSize: 13,
                                  
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: ScreenHeight * 0.008,
                            ),
                         
                          Padding(
                            padding: const EdgeInsets.fromLTRB(3, 0, 0,0),
                            child: Text(offer.surface.toString() + ' m²'),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: ScreenHeight * 0.055,
                        ),
                        Text(
                          offer.prix.toString() + ' DA',
                          style: TextStyle(
                            letterSpacing: 1,
                              fontSize: 22, 
                              color: Colors.black,fontWeight: FontWeight.w400),
                        ),
                     
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildSheet() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    ListviewController.jumpTo(0);
                    sort = 'getoffer';
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'None',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    ListviewController.jumpTo(0);
                    setState(() {
                      sort = 'Highprice';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'High price',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    ListviewController.jumpTo(0);
                    setState(() {
                      sort = 'Lowprice';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Low price',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    ListviewController.jumpTo(0);
                    setState(() {
                      sort = 'Highsurface';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'High surface',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    ListviewController.jumpTo(0);
                    setState(() {
                      sort = 'Lowsurface';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Low surface',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    ListviewController.jumpTo(0);
                    setState(() {
                      sort = 'Newoffer';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'New offer',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    ListviewController.jumpTo(0);
                    setState(() {
                      sort = 'Oldoffer';
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Old offer',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<OfferInfo>> getOffer(sort) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await offerApi().getofferdata(sort, token);
    Iterable list = await json.decode(response.body);

    return list.map<OfferInfo>(OfferInfo.toObject).toList();
  }
}
