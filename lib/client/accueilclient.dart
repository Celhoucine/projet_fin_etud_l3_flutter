import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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
  void initState() {
    _loadCategories();
    getOffer(sort);
    setIconMarke();
    super.initState();
  }

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
  var categories = [];
  String category_id = "1";
  var data = {
    'description': '',
    'surface': '',
    'prix': '',
    'categorie': '1',
  };
  GoogleMapController? mapController;
  Set<Marker> offersmarker = {};
  late BitmapDescriptor iconMarkeA;
  late BitmapDescriptor iconMarkeV;
  late BitmapDescriptor iconMarkeS;
  late BitmapDescriptor iconMarkeP;
  late BitmapDescriptor iconMarkeSF;
  late Position cl;
  var lat;
  var long;

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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('filtteroffer');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(
                                  width: 0.5,
                                  color: Color.fromRGBO(84, 140, 129, 1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          width: ScrrenWidth * 0.7,
                          height: ScreenHeight * 0.05,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(84, 140, 129, 1),
                                ),
                                SizedBox(
                                  width: ScrrenWidth * 0.01,
                                ),
                                Text('Search....')
                              ],
                            ),
                          ),
                        ),
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
                    : Container(
                        width: ScrrenWidth,
                        height: ScreenHeight * 0.76,
                        child: maps())),
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

                return Offer(offer);
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString(),
                style: TextStyle(fontSize: 24));
          }
          return Center(child: const CircularProgressIndicator());
        }));
  }

  Widget Offer(OfferInfo offer) {
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
                              agenceName: offer.agenceName,
                              email: offer.email,
                              phone: offer.phone,
                              willaya: offer.willaya,
                              baladiya: offer.baladiya,
                              lat: offer.lat,
                              long: offer.long,
                              bathroom: offer.bathroom,
                              bedroom: offer.bedroom,
                              livingroom: offer.livingroom,
                              garage: offer.garage,
                              kitchen: offer.kitchen,
                            )));
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
                                              SizedBox(
                                                width: ScrrenWidth * 0.02,
                                              ),
                                              vues(offer.id),
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
                                          Container(
                                            width: ScrrenWidth * 0.4,
                                            child: Row(
                                              children: [
                                                offer.categorie == 'Villa'
                                                    ? ImageIcon(
                                                        AssetImage(
                                                            'assets/villa.png'),
                                                        size:
                                                            ScrrenWidth * 0.035,
                                                        color: Color.fromRGBO(
                                                            15, 189, 25, 50),
                                                      )
                                                    : offer.categorie == 'Land'
                                                        ? ImageIcon(
                                                            AssetImage(
                                                                'assets/land.png'),
                                                            size: ScrrenWidth *
                                                                0.035,
                                                            color:
                                                                Color.fromRGBO(
                                                                    251,
                                                                    126,
                                                                    55,
                                                                    50),
                                                          )
                                                        : offer.categorie ==
                                                                'Single family'
                                                            ? ImageIcon(
                                                                AssetImage(
                                                                    'assets/singleF.png'),
                                                                size:
                                                                    ScrrenWidth *
                                                                        0.035,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        251,
                                                                        126,
                                                                        55,
                                                                        50),
                                                              )
                                                            : ImageIcon(
                                                                AssetImage(
                                                                    "assets/Apartments.png"),
                                                                size:
                                                                    ScrrenWidth *
                                                                        0.035,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        38,
                                                                        90,
                                                                        144,
                                                                        50),
                                                              ),
                                                Expanded(
                                                  child: Text(
                                                    ' ' +
                                                        offer.willaya +
                                                        ',' +
                                                        offer.baladiya,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
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
                                          height: ScreenHeight * 0.04,
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
          return Text('');
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

  addvue(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().addvue('addvue/${id}', token);
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

  Future getvues(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().getoffervues('getvues/${id}', token);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return '';
    }
  }

  Widget vues(id) {
    return FutureBuilder(
      future: getvues(id),
      builder: (context, snapshot) {
        var vues = snapshot.data;
        print(vues);

        if (snapshot.hasData) {
          return Row(
            children: [
              Icon(
                Icons.remove_red_eye,
                size: 12,
                color: Colors.black54,
              ),
              Text(
                vues.toString(),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        }
        return Container();
      },
    );
  }

  Widget maps() {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<OfferInfo>>(
        future: getOffer(sort),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final offers = snapshot.data;
            for (var i = 0; i < offers!.length; i++) {
              OfferInfo offer = offers[i];
              offersmarker.add(Marker(
                icon: offer.categorie == 'Villa'
                    ? iconMarkeV
                    : offer.categorie == 'Land'
                        ? iconMarkeP
                        : offer.categorie == 'Apartments'
                            ? iconMarkeA
                            : iconMarkeSF,
                markerId: MarkerId(offer.id.toString()),
                position:
                    LatLng(double.parse(offer.lat), double.parse(offer.long)),
                onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(double.parse(offer.lat),
                                  double.parse(offer.long)),
                              zoom: 10)));
                      return BuildSheetMap(offer);
                    }),
              ));
            }
            return Stack(
              children: [
                GoogleMap(
               
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  rotateGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  markers: offersmarker,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(28.033886, 1.659626),
                    zoom: 5,
                  ),
                ),
                Positioned(
                    left: ScreenWidth * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: IconButton(
                              onPressed: () {
                                getcurrentPosition();
                              },
                              icon: Icon(Icons.gps_fixed))),
                    ))
              ],
            );
          } else if (snapshot.hasError) {
            return Text('error on server please come back later',
                style: TextStyle(fontSize: 24));
          }
          return Center(child: const CircularProgressIndicator());
        }));
  }

  Widget BuildSheetMap(OfferInfo offer) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
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
                      agenceName: offer.agenceName,
                      email: offer.email,
                      phone: offer.phone,
                      willaya: offer.willaya,
                      baladiya: offer.baladiya,
                      lat: offer.lat,
                      long: offer.long,
                      bathroom: offer.bathroom,
                      bedroom: offer.bedroom,
                      livingroom: offer.livingroom,
                      garage: offer.garage,
                      kitchen: offer.kitchen,
                    )));
      },
      child: Container(
        height: ScreenHeight * 0.36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: ScreenHeight * 0.20,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'http://192.168.1.62:8000/storage/images/' +
                              offer.id.toString() +
                              '_' +
                              0.toString() +
                              '.png'))),
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
                        Row(
                          children: [
                            Text(
                              formatter
                                  .format(DateTime.tryParse(offer.created_at)
                                      as DateTime)
                                  .toString(),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(
                              width: ScrrenWidth * 0.02,
                            ),
                            vues(offer.id),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 4, 0, 0),
                          child: Text(
                            offer.categorie,
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: ScreenHeight * 0.007,
                        ),
                        Container(
                          width: ScrrenWidth * 0.4,
                          child: Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                size: ScrrenWidth * 0.035,
                                color: Color.fromRGBO(84, 140, 129, 0.5),
                              ),
                              Expanded(
                                child: Text(
                                  ' ' + offer.willaya + ',' + offer.baladiya,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenHeight * 0.001,
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
                          padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
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
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: ScreenHeight * 0.04,
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void setIconMarke() async {
    iconMarkeA = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/Apartments.png');
    iconMarkeSF = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/singleF.png');
    iconMarkeP = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/land.png');
    iconMarkeS = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/garag.png');
    iconMarkeV = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/villa.png');
  }

  Future<void> getcurrentPosition() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    long = cl.longitude;

    setState(() {
      offersmarker.add(Marker(
        markerId: MarkerId('0'),
        position: LatLng(lat, long),
      ));

      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 20)));
    });
  }
}
