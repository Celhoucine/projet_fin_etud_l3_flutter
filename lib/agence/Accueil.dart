import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';

class accueil extends StatefulWidget {
  const accueil({Key? key}) : super(key: key);

  @override
  State<accueil> createState() => _accueilState();
}

class _accueilState extends State<accueil> {
  @override
  void initState() {
    getOffer();
    super.initState();
  }

  

  Future<List<OfferInfo>> getOffer() async {
    var response = await offerApi().getofferdata('show');
    Iterable list = await json.decode(response.body);

    return list.map<OfferInfo>(OfferInfo.toObject).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.green,
          title: Text('heellooo'),
        ),
        body: ListView(
          children: [
            Center(
              child: Container(
                width: ScrrenWidth ,
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
                return Offer( offer);
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
          Navigator.of(context).pushNamed('login');
        },
        child: Container(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
            Container(
              width: ScrrenWidth,
              height: ScreenHeight*0.25,
              child: Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/OIP.jfif')),
            ),
            Text(offer.email)
          ],),
          height: ScreenHeight * 0.40,
          color: Colors.red,
          
        ),
      ),
    );
  }
}
