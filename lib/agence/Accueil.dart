import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/agence/detail_offer_agency.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:projet_fin_etud_l3_flutter/client/detail_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class accueil extends StatefulWidget {
  const accueil({Key? key}) : super(key: key);

  @override
  State<accueil> createState() => _accueilState();
}

class _accueilState extends State<accueil>
    with AutomaticKeepAliveClientMixin<accueil> {
  Future<List<OfferInfo>> getOffer() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await offerApi().getofferdata('getagenceoffer', token);
    Iterable list = await json.decode(response.body);

    return list.map<OfferInfo>(OfferInfo.toObject).toList();
  }

  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: ScreenHeight * 0.08,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Your Offer', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(6, 64, 64, 1),
                  Color.fromRGBO(84, 140, 129, 1),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: Container(
                width: ScrrenWidth * 0.95,
                child: OffersList(),
              ),
            ),
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
                  builder: (context) => offer_detail_agency(
                      id: offer.id,
                      description: offer.description,
                      prix: offer.prix,
                      surface: offer.surface,
                      categorie: offer.categorie,
                      created_at: offer.created_at,
                      num_image: offer.num_image,
                      agenceName: offer.agenceName,
                      )));
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
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return CarouselSlider.builder(
                      options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
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
                                  topRight: Radius.circular(10)),
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
  Future getvues(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().getoffervues('getvues/${id}', token);
    print(response);
    return response;
  }

  @override
  bool get wantKeepAlive => true;
}
