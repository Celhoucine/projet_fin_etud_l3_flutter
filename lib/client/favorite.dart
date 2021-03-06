import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:projet_fin_etud_l3_flutter/client/detail_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class favorite extends StatefulWidget {
  const favorite({Key? key}) : super(key: key);

  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  ////utilise @ip de serveur
  var IP = '192.168.1.62';
  @override
  var is_favR = 236;
  var is_favG = 18;
  var is_favB = 18;
  var not_favR = 0;
  var not_favG = 0;
  var not_favB = 0;
  final ListviewController = ScrollController();

  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(84, 140, 129, 1),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Favorite'),
        ),
        body: ListView(
          controller: ListviewController,
          children: [
            Center(child: OffersList()),
          ],
        ),
      ),
    );
  }

  Widget OffersList() {
    return FutureBuilder<List<OfferInfo>>(
        future: getOffer(),
        builder: ((context, snapshot) {
          final offers = snapshot.data;

          if (snapshot.hasData) {
            return ListView.builder(
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
                                        final urlimage = 'http://' +
                                            IP +
                                            ':8000/storage/images/' +
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
                                                    ' m??'),
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
          return Text('${snapshot.error}');
        }
        return Container();
      },
    );
  }

  Future<List<OfferInfo>> getOffer() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await offerApi().getofferdata('listfavorite', token);
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
}
