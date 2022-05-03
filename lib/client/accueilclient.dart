import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:projet_fin_etud_l3_flutter/client/detail_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class accueilclient extends StatefulWidget {
  const accueilclient({Key? key}) : super(key: key);

  @override
  State<accueilclient> createState() => _accueilclientState();
}

class _accueilclientState extends State<accueilclient> {
  @override
  @override
  ScrollController listcontroller = ScrollController();
  var is_favR = 236;
  var is_favG = 18;
  var is_favB = 18;
  var not_favR = 0;
  var not_favG = 0;
  var not_favB = 0;
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
            automaticallyImplyLeading: false,
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
                  : maps(),
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
              controller: listcontroller,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: offers!.length,
              itemBuilder: (context, index) {
                final offer = offers[index];

                return Offer(
                  offer,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: const CircularProgressIndicator());
        }));
  }

  Widget Offer(
    OfferInfo offer,
  ) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    var is_fav;
    return FutureBuilder(
      future: exsistfavorite(offer.id),
      builder: (context, snapshot) {
        var fav = snapshot.data;
        if (fav == 1) {
          var is_fav = true;
        } else {
          var is_fav = false;
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                addvue(offer.id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => detailoffer(
                            id: offer.id,
                            description: offer.description,
                            prix: offer.prix,
                            surface: offer.surface,
                            categorie: offer.categorie,
                            created_at: offer.created_at,
                            num_image: offer.num_image,
                            agenceName: offer.agenceName)));
              },
              child: Container(
                  height: ScreenHeight * 0.42,
                  width: ScrrenWidth * 0.8,
                  child: LayoutBuilder(builder: ((context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          height: ScreenHeight * 0.42,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                                ),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return CarouselSlider.builder(
                                      options: CarouselOptions(
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 5),
                                          viewportFraction: 1),
                                      itemCount: offer.num_image,
                                      itemBuilder: (context, index, realindex) {
                                        final urlimage =
                                            'http://192.168.1.62:8000/storage/images/' +
                                                offer.id.toString() +
                                                '_' +
                                                index.toString() +
                                                '.png';

                                        return Container(
                                          width: constraints.maxWidth,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  urlimage,
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                        );
                                      });
                                }),
                              ),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 1, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                formatter
                                                    .format(DateTime.tryParse(
                                                            offer.created_at)
                                                        as DateTime)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              SizedBox(width: ScrrenWidth*0.02,),
                                              FutureBuilder(
                                          future: getvues(offer.id),
                                          builder: (context, snapshot) {
                                            var vues = snapshot.data;

                                            if (snapshot.hasData) {
                                              return Row(

                                                
                                                children: [
                                                  Icon(Icons.remove_red_eye,size: 12,color: Colors.black54,),
                                                  Text(vues.toString(),style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 11,
                                                ),),
                                                ],
                                              );
                                            } else
                                              return Text('');
                                          },
                                        )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                2, 4, 0, 0),
                                            child: Text(
                                              offer.categorie,
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w400),
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
                                                color: Color.fromRGBO(
                                                    84, 140, 129, 0.5),
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
                                            height: ScreenHeight * 0.007,
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.person_outline,
                                                  size: ScrrenWidth * 0.035,
                                                  color: Colors.orangeAccent),
                                              Text(
                                                offer.agenceName,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                3, 0, 0, 0),
                                            child: Text(
                                                offer.surface.toString() +
                                                    ' m²'),
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
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: ScreenHeight*0.04,
                                        ),
                                        
                                      ],
                                    )
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                        Positioned(
                          top: constraints.maxHeight * 0.58,
                          right: constraints.maxWidth * 0.05,
                          child: GestureDetector(
                            onTap: () {
                              addfav(offer.id);
                              if (fav == 1) {
                                setState(() {
                                  var is_fav = false;
                                });
                              } else {
                                setState(() {
                                  var is_fav = true;
                                });
                              }
                            },
                            child: new Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: constraints.maxWidth * 0.1,
                                  height: constraints.maxHeight * 0.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(2, 4))
                                      ]),
                                  child: fav == 1 || is_fav == true
                                      ? Icon(
                                          Icons.favorite_sharp,
                                          color: Color.fromRGBO(
                                              is_favR, is_favG, is_favB, 100),
                                          size: 25,
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          color: Color.fromRGBO(not_favR,
                                              not_favG, not_favB, 100),
                                          size: 25,
                                        ),
                                )),
                          ),
                        )
                      ],
                    );
                  }))),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return Container();
      },
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

  addfav(var id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().addfavorite(token, 'addfavorite/${id}');
  }

  Future exsistfavorite(var id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response =
        await offerApi().exsistfavorite(token, 'existefavorite/${id}');

    return response;
  }

  Future getvues(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().getoffervues('getvues/${id}', token);
    print(response);
    return response;
  }

  addvue(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().addvue('addvue/${id}', token);
  }

  Widget maps() {
    return Container(
      width: 300,
      height: 300,
      child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition:
              CameraPosition(zoom: 4, target: LatLng(35.430995, 7.146707))),
    );
  }
}
