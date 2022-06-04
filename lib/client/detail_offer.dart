import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:community_material_icon/community_material_icon.dart';

class detailoffer extends StatefulWidget {
  int id;
  String description;
  int prix;
  double surface;
  String categorie;
  String created_at;
  int num_image;
  String agenceName;
  int phone;
  String email;
  String willaya;
  String baladiya;
  String lat;
  String long;
  int bathroom;
  int garage;
  int bedroom;
  int livingroom;
  int kitchen;
  detailoffer(
      {Key? key,
      required this.id,
      required this.surface,
      required this.description,
      required this.prix,
      required this.categorie,
      required this.created_at,
      required this.num_image,
      required this.agenceName,
      required this.email,
      required this.phone,
      required this.baladiya,
      required this.willaya,
      required this.lat,
      required this.long,
      required this.bathroom,
      required this.bedroom,
      required this.garage,
      required this.kitchen,
      required this.livingroom})
      : super(key: key);

  @override
  State<detailoffer> createState() => _detailofferState();
}

class _detailofferState extends State<detailoffer> {
  @override
  void initState() {
    getcomment(widget.id);
    super.initState();
  }
  ////utilise @ip de serveur
var IP = '192.168.1.62';

  Set<Marker> mymarker = {};
  late GoogleMapController mapController;
  TextEditingController _addcomment = new TextEditingController();
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
  var numberformatter = NumberFormat("#.###");
  late int exsistfavo;

  bool isreadmore = false;
  var is_fav = false;
  var fav;
  var is_favR = 236;
  var is_favG = 18;
  var is_favB = 18;
  var not_favR = 0;
  var not_favG = 0;
  var not_favB = 0;

  @override
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    mymarker.add(Marker(
      markerId: MarkerId('1'),
      visible: true,
      position: LatLng(double.parse(widget.lat), double.parse(widget.long)),
    ));
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed('home_client');
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              bottomNavigationBar: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          calling(widget.phone);
                        },
                        child: Container(
                            height: ScreenHeight * 0.045,
                            width: ScrrenWidth * 0.3,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(6, 64, 64, 1),
                                      Color.fromRGBO(84, 140, 129, 1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.white60,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text('Call'),
                                ),
                              ],
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          email(widget.email);
                        },
                        child: Container(
                            height: ScreenHeight * 0.045,
                            width: ScrrenWidth * 0.3,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(6, 64, 64, 1),
                                      Color.fromRGBO(84, 140, 129, 1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mail,
                                  color: Colors.white60,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text('Message'),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 240, 240, 240),
              body: FutureBuilder(
                  future: exsistfavorite(widget.id),
                  builder: (context, snapshot) {
                    var fav = snapshot.data;

                    if (fav == 1) {
                      var is_fav = true;
                    } else {
                      var is_fav = false;
                    }
                    if (snapshot.hasData) {
                      return ListView(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: ScrrenWidth,
                                        height: ScreenHeight * 0.26,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return CarouselSlider.builder(
                                              options: CarouselOptions(
                                                  autoPlay: true,
                                                  autoPlayInterval:
                                                      Duration(seconds: 5),
                                                  viewportFraction: 1),
                                              itemCount: widget.num_image,
                                              itemBuilder:
                                                  (context, index, realindex) {
                                                final urlimage =
                                                    'http://'+IP+':8000/storage/images/' +
                                                        widget.id.toString() +
                                                        '_' +
                                                        index.toString() +
                                                        '.png';

                                                return Container(
                                                  width: ScrrenWidth,
                                                  height: ScreenHeight * 0.26,
                                                  decoration: BoxDecoration(
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
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 7, 0, 0),
                                                  child: Container(
                                                    width: ScrrenWidth * 0.55,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15)),
                                                        gradient: LinearGradient(
                                                            colors: [
                                                              Color.fromRGBO(
                                                                  6, 64, 64, 1),
                                                              Color.fromRGBO(84,
                                                                  140, 129, 1),
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 0, 5),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    2, 5, 0, 0),
                                                            child: Text(
                                                              widget.categorie,
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          166,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      ScrrenWidth *
                                                                          0.055),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  ScrrenWidth *
                                                                      0.005),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    2, 9, 0, 0),
                                                            child: Text(
                                                              '(' +
                                                                  widget.surface
                                                                      .toString() +
                                                                  ' m²' +
                                                                  ')',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          234,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: ScreenHeight * 0.007,
                                                ),
                                                Container(
                                                  width: ScrrenWidth * 0.5,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.place,
                                                        size:
                                                            ScrrenWidth * 0.050,
                                                        color: Color.fromARGB(
                                                            197, 84, 140, 129),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          widget.willaya +
                                                              ' ' +
                                                              widget.baladiya,
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: ScreenHeight * 0.007,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.person,
                                                        size:
                                                            ScrrenWidth * 0.050,
                                                        color: Color.fromARGB(
                                                            137, 255, 172, 64)),
                                                    Text(
                                                      widget.agenceName,
                                                      style: TextStyle(
                                                        fontSize: 13.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2, 35, 0, 3),
                                              child: Text(
                                                widget.prix.toString() + ' DZ',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        child: Container(
                                          width: ScrrenWidth * 0.88,
                                          child: Row(
                                            children: [
                                              Text(
                                                formatter
                                                    .format(DateTime.tryParse(
                                                            widget.created_at)
                                                        as DateTime)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: ScrrenWidth * 0.88,
                                          height: 1,
                                          color: Colors.black12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: ScreenHeight * 0.24,
                                    right: ScrrenWidth * 0.05,
                                    child: GestureDetector(
                                      onTap: () {
                                        addfav(widget.id);
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
                                            width: ScrrenWidth * 0.1,
                                            height: ScreenHeight * 0.05,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.shade300,
                                                      spreadRadius: 2,
                                                      blurRadius: 4,
                                                      offset: Offset(2, 4))
                                                ]),
                                            child: fav == 1 || is_fav
                                                ? Icon(
                                                    Icons.favorite_sharp,
                                                    color: Color.fromRGBO(
                                                        is_favR,
                                                        is_favG,
                                                        is_favB,
                                                        100),
                                                    size: 25,
                                                  )
                                                : Icon(
                                                    Icons.favorite_border,
                                                    color: Color.fromRGBO(
                                                        not_favR,
                                                        not_favG,
                                                        not_favB,
                                                        100),
                                                    size: 25,
                                                  ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Center(
                                  child: Container(
                                    width: ScrrenWidth * 0.88,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Property details',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Center(
                                  child: Container(
                                    width: ScrrenWidth * 0.88,
                                    child: Row(
                                      children: [
                                        Icon(
                                          CommunityMaterialIcons
                                              .sofa_single_outline,
                                          color:
                                              Color.fromRGBO(84, 140, 129, 0.7),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            widget.livingroom.toString() +
                                                ' ' +
                                                'Livingrooms',
                                            style: TextStyle(fontSize: 14.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Center(
                                  child: Container(
                                    width: ScrrenWidth * 0.88,
                                    child: Row(
                                      children: [
                                        Icon(
                                          CommunityMaterialIcons.bed_outline,
                                          color:
                                              Color.fromRGBO(84, 140, 129, 0.7),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            widget.bedroom.toString() +
                                                ' ' +
                                                'bedroom',
                                            style: TextStyle(fontSize: 14.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Center(
                                  child: Container(
                                    width: ScrrenWidth * 0.88,
                                    child: Row(
                                      children: [
                                        Icon(
                                          CommunityMaterialIcons.shower,
                                          color:
                                              Color.fromRGBO(84, 140, 129, 0.7),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            widget.bathroom.toString() +
                                                ' ' +
                                                'bathroom',
                                            style: TextStyle(fontSize: 14.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Center(
                                  child: Container(
                                    width: ScrrenWidth * 0.88,
                                    child: Row(
                                      children: [
                                        Icon(
                                          CommunityMaterialIcons
                                              .fridge_variant_outline,
                                          color:
                                              Color.fromRGBO(84, 140, 129, 0.7),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            widget.kitchen.toString() +
                                                ' ' +
                                                'kitchen',
                                            style: TextStyle(fontSize: 14.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Center(
                                  child: Container(
                                    width: ScrrenWidth * 0.88,
                                    child: Row(
                                      children: [
                                        Icon(
                                          CommunityMaterialIcons.garage_variant,
                                          color:
                                              Color.fromRGBO(84, 140, 129, 0.7),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            widget.garage.toString() +
                                                ' ' +
                                                'Garages',
                                            style: TextStyle(fontSize: 14.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: ScrrenWidth * 0.88,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 5),
                                        child: Text(
                                          'Description',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      BuildText(widget.description),
                                      InkWell(
                                        child: Row(
                                          children: [
                                            Text(
                                              isreadmore
                                                  ? 'Read less'
                                                  : 'Read more',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      84, 140, 129, 1)),
                                            ),
                                            Icon(
                                              isreadmore
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Color.fromRGBO(
                                                  84, 140, 129, 1),
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isreadmore = !isreadmore;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Center(
                                          child: Container(
                                            width: ScrrenWidth * 0.88,
                                            height: 1,
                                            color: Colors.black12,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 5),
                                        child: Text(
                                          'Property location',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 4),
                                        child: Container(
                                          width: ScrrenWidth * 0.88,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.place,
                                                size: ScrrenWidth * 0.045,
                                                color: Color.fromARGB(
                                                    197, 84, 140, 129),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  widget.willaya +
                                                      ' ' +
                                                      widget.baladiya,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.1,
                                              color: Color.fromRGBO(
                                                  84, 140, 129, 1)),
                                        ),
                                        width: ScrrenWidth,
                                        height: ScreenHeight * 0.20,
                                        child: GoogleMap(
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              mapController = controller;
                                            },
                                            zoomControlsEnabled: false,
                                            rotateGesturesEnabled: false,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                  double.parse(widget.lat),
                                                  double.parse(widget.long)),
                                              zoom: 16,
                                            ),
                                            markers: mymarker),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 8),
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: ScrrenWidth * 0.75,
                                            height: ScreenHeight * 0.075,
                                            child: TextFormField(
                                              controller: _addcomment,
                                              maxLength: 50,
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText: 'add a comment',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  25)))),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                var data = {
                                                  'text': _addcomment.text,
                                                  'offers_id':
                                                      widget.id.toString()
                                                };
                                                addcomment(data);
                                                _addcomment.text = '';
                                              },
                                              icon: Icon(
                                                Icons.send,
                                                color: Color.fromRGBO(
                                                    84, 140, 129, 1),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  height: ScreenHeight * 0.5,
                                  width: ScrrenWidth * 0.88,
                                  child: Listcomments()),
                            ],
                          )
                        ],
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return Container();
                    }
                  }))),
    );
  }

  Widget BuildText(String text) {
    final maxline = isreadmore ? null : 5;
    return Text(
      text,
      maxLines: maxline,
      style: TextStyle(color: Colors.black54),
    );
  }

  Widget Listcomments() {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    var path = '';
    return FutureBuilder(
        future: getcomment(widget.id),
        builder: ((context, AsyncSnapshot snapshot) {
          final comments = snapshot.data;

          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: comments!.length,
                itemBuilder: (context, index) {
                  if (comments[index]['profile_image'] == 'NO_IMAGE') {
                    path = 'http://'+IP+':8000/storage/images/OIP.png';
                  } else {
                    path = 'http://'+IP+':8000/storage/images/' +
                        comments[index]['id'].toString() +
                        '.png';
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(path),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(comments[index]['lname'] +
                                          ' ' +
                                          comments[index]['fname']),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: Text(
                                          formatter
                                              .format(DateTime.tryParse(
                                                      comments[index]
                                                          ['created_at'])
                                                  as DateTime)
                                              .toString(),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Container(
                                      width: ScrrenWidth * 0.6,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              comments[index]['text'],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: const CircularProgressIndicator());
        }));
  }

  Future exsistfavorite(var id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response =
        await offerApi().exsistfavorite(token, 'existefavorite/${id}');
    fav = response;
    return response;
  }

  addfav(var id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().addfavorite(token, 'addfavorite/${id}');
  }

  addcomment(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().addcomment(token, data, 'addcomment');
  }

  Future getcomment(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().getoffercomment('getcomments/${id}', token);

    return jsonDecode(response.body);
  }

  email(email) async {
    final toemail = email;
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

  calling(phone) async {
    var url = 'tel:+213' + phone.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
