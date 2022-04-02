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
    return FutureBuilder<List<OfferInfo>>(
        future: getOffer(),
        builder: ((context, snapshot) {
         final offers = snapshot.data;
          return ListView.builder(
            itemCount: offers!.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred!'));
                } else {
                  return Text(offer.email);;
                }
            }
              
            },
          );
        }));
  }
}








// ListView(
//       children: offers.map((offer) {
//         return Container(
//           color: Colors.red,
//           height: 100,
//           width: 100,
//           child: Text(offer.email),
//         );
//       }).toList(),
//     );