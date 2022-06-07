import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_offer.dart';

class search_results_map extends StatefulWidget {
  var data = {
    'surface_min': '',
    'surface_max': '',
    'prix_min': '',
    'prix_max': '',
    'categore': '1',
    'distance': ''
  };

  search_results_map({Key? key, required this.data}) : super(key: key);

  @override
  State<search_results_map> createState() => _search_results_mapState();
}

class _search_results_mapState extends State<search_results_map> {
  @override
  void initState() {
    setIconMarke();
    getPosition();

    super.initState();
  }

  ////utilise @ip de serveur
  var IP = '192.168.1.62';

  @override
  GoogleMapController? mapController;
  Set<Marker> offersmarker = {};
  late BitmapDescriptor iconMarkeA;
  late BitmapDescriptor iconMarkeV;
  late BitmapDescriptor iconMarkeS;
  late BitmapDescriptor iconMarkeP;
  late BitmapDescriptor iconMarkeSF;
  late Position cl;
  var lat = 0.0;
  var long = 0.0;

  final ListviewController = ScrollController();

  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(84, 140, 129, 1),
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text('Search Result'),
            ),
            body: Container(
                width: ScrrenWidth,
                height: ScreenHeight * 0.98,
                child: maps(IP))));
  }

  Widget maps(String IP) {
    

    Set<Circle> circle = Set.from([
      Circle(
        fillColor: Color.fromRGBO(180, 212, 243, 0.40),
        strokeWidth: 1,
        strokeColor: Colors.blue,
        circleId: CircleId("2"),
        center: LatLng(lat, long),
        radius: double.parse(widget.data['distance'].toString()) * 1000,
      )
    ]);
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<OfferInfo>>(
        future: searchData(widget.data),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final offers = snapshot.data;
            if (widget.data['distance'] == '0') {
              for (var i = 0; i < offers!.length; i++) {
                addoffertomap(offers[i]);
              }
            } else {
              for (var i = 0; i < offers!.length; i++) {
                OfferInfo offer = offers[i];
                var latO = double.parse(offer.lat);
                var longO = double.parse(offer.long);

                var p = 0.017453292519943295;
                var a = 0.5 -
                    cos((latO - lat) * p) / 2 +
                    cos(lat * p) *
                        cos(latO * p) *
                        (1 - cos((longO - long) * p)) /
                        2;
                double dis = 12742 * asin(sqrt(a));
                if (dis <= double.parse(widget.data['distance'].toString())) {
                  addoffertomap(offers[i]);
                }
                 mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: getZoomLevel(double.parse(widget.data['distance'].toString())))));
              }
              
            }
            return Stack(
              children: [
                GoogleMap(
                  circles: circle,
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

  addoffertomap(offers) {
    OfferInfo offer = offers;
    offersmarker.add(Marker(
      icon: offer.categorie == 'Villa'
          ? iconMarkeV
          : offer.categorie == 'Land'
              ? iconMarkeP
              : offer.categorie == 'Apartments'
                  ? iconMarkeA
                  : iconMarkeSF,
      markerId: MarkerId(offer.id.toString()),
      position: LatLng(double.parse(offer.lat), double.parse(offer.long)),
      onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            mapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(
                        double.parse(offer.lat), double.parse(offer.long)),
                    zoom: 10)));
            return BuildSheetMap(offer, IP);
          }),
    ));
  }

  Future<List<OfferInfo>> searchData(data) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    
    var url = '';
    if (data['all_categore'] == 'true') {
      if (data['wilaya'] == 'All') {
        url =
            'search?surface_min=${data['surface_min']}&surface_max=${data['surface_max']}&prix_max=${data['prix_max']}&prix_min=${data['prix_min']}';
      } else {
        url =
            'search?surface_min=${data['surface_min']}&surface_max=${data['surface_max']}&prix_max=${data['prix_max']}&prix_min=${data['prix_min']}&wilaya=${data['wilaya']}';
      }
    } else {
      if (data['wilaya'] == 'All') {
        url =
            'search?surface_min=${data['surface_min']}&surface_max=${data['surface_max']}&prix_max=${data['prix_max']}&prix_min=${data['prix_min']}&categore=${data['categore']}';
      } else {
        url =
            'search?surface_min=${data['surface_min']}&surface_max=${data['surface_max']}&prix_max=${data['prix_max']}&prix_min=${data['prix_min']}&categore=${data['categore']}&wilaya=${data['wilaya']}';
      }
    }
    var response = await offerApi().searchdata(url, token);
    Iterable list = await json.decode(response.body);
    return list.map<OfferInfo>(OfferInfo.toObject).toList();
  }

  addvue(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().addvue('addvue/${id}', token);
  }

  Widget BuildSheetMap(OfferInfo offer, String IP1) {
    var IP = IP1;

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
                      image: NetworkImage('http://' +
                          IP +
                          ':8000/storage/images/' +
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

  getPosition() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    setState(() {
      lat = cl.latitude;
      long = cl.longitude;
    });
  }
  double getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
     
      zoomLevel = 15 - log(radiusElevated) / log(2);
    }
    zoomLevel = double.parse(zoomLevel.toStringAsFixed(2));
    return zoomLevel;
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
}
