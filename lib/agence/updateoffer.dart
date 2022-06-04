import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateOffer extends StatefulWidget {
  int id;
  String description;
  int prix;
  double surface;
  String categorie;
  String created_at;
  int num_image;
  String agenceName;

  String willaya;
  String baladiya;
  String lat;
  String long;
  int bathroom;
  int garage;
  int bedroom;
  int livingroom;
  int kitchen;
  UpdateOffer(
      {Key? key,
      required this.id,
      required this.surface,
      required this.description,
      required this.prix,
      required this.categorie,
      required this.created_at,
      required this.num_image,
      required this.agenceName,
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
  State<UpdateOffer> createState() => _UpdateOfferState();
}

class _UpdateOfferState extends State<UpdateOffer> {
  @override
  void initState() {
    setState(() {
      _loadCategories();
      garage = widget.garage;
      bathroom = widget.bathroom;
      bedroom = widget.bedroom;
      livingroom = widget.livingroom;
      kitchen = widget.kitchen;
      if (widget.categorie == 'Apartments') {
        category_id = "1";
      }
      if (widget.categorie == 'Land') {
        category_id = "2";
      }
      if (widget.categorie == 'Studio') {
        category_id = "3";
      }
      if (widget.categorie == 'Villa') {
        category_id = "4";
      }
      if (widget.categorie == 'Single family') {
        category_id = "5";
      }
      newinfo = {
        'description': widget.description,
        'surface': widget.surface.toString(),
        'prix': widget.prix.toString(),
        'categorie': category_id,
        'longitude': widget.long,
        'latitude': widget.lat,
        'willaya': widget.willaya,
        'baladiya': widget.baladiya,
        'bathroom': widget.bathroom,
        'garage': widget.garage,
        'bedroom': widget.bedroom,
        'livingroom': widget.livingroom,
        'kitchen': widget.kitchen,
      };
    });
    super.initState();
  }

  @override
  Set<Marker> mymarker = {
    Marker(
      markerId: MarkerId('1'),
      visible: true,
      position: LatLng(28.033886, 1.659626),
    )
  };
  GoogleMapController? mapController;
  late Position cl;
  var lat;
  var long;
  late int garage;
  late int bathroom;
  late int bedroom;
  late int livingroom;
  late int kitchen;
  File? imagecam;
  var cameraimage = ImagePicker();
  var multimage = ImagePicker();
  List<XFile>? images = [];
  bool imagenotvide = false;
  bool _value = false;
  var categories = [];
  String category_id = "1";

  var newinfo = {
    'description': '',
    'surface': '',
    'prix': '',
    'categorie': '1',
    'longitude': '1.659626',
    'latitude': '28.033886',
    'willaya': '',
    'baladiya': '',
    'bathroom': 0,
    'garage': 0,
    'bedroom': 0,
    'livingroom': 0,
    'kitchen': '',
  };
  PageController pageController = PageController(initialPage: 0);
  Widget build(BuildContext context) {
    imageCache?.clear();
    imageCache?.clearLiveImages();
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [update_info(), OfferPosition()],
      ),
    ));
  }

  Widget update_info() {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return ListView(children: [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: ScreenWidth * 0.080,
                ),
                Text('Type : '),
                Container(
                  width: ScreenWidth * 0.3,
                  child: DropdownButton(
                    elevation: 16,
                    underline: Container(
                      height: 1,
                      color: Colors.black26,
                    ),
                    hint: Text('Select'),
                    items: categories.map((item) {
                      return new DropdownMenuItem(
                        child: Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        category_id = value.toString();
                        newinfo['categorie'] = category_id;
                      });
                    },
                    value: category_id,
                  ),
                ),
                SizedBox(
                  width: ScreenWidth * 0.05,
                ),
                Text('Surface :'),
                Container(
                  width: ScreenWidth * 0.28,
                  child: TextFormField(
                    initialValue: widget.surface.toString(),
                    onChanged: (value) {
                      setState(() {
                        newinfo['surface'] = value;
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
            child: Row(
              children: [
                SizedBox(
                  width: ScreenWidth * 0.080,
                ),
                Text('Price :'),
                Container(
                  width: ScreenWidth * 0.28,
                  child: TextFormField(
                    initialValue: widget.prix.toString(),
                    onChanged: (value) {
                      setState(() {
                        newinfo['prix'] = value;
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
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenWidth * 0.080,
              ),
              Image.asset('assets/kitchen.png'),
              Container(width: ScreenWidth * 0.3, child: Text(' Kitchen : ')),
              IconButton(
                  onPressed: () {
                    if (kitchen > 0) {
                      setState(() {
                        kitchen = kitchen - 1;
                        newinfo['kitchen'] = kitchen;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                  )),
              Text(kitchen.toString()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      kitchen = kitchen + 1;
                      newinfo['kitchen'] = kitchen;
                    });
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 20,
                  )),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenWidth * 0.080,
              ),
              Image.asset('assets/toilets.png'),
              Container(width: ScreenWidth * 0.3, child: Text(' Bathroom : ')),
              IconButton(
                  onPressed: () {
                    if (bathroom > 0) {
                      setState(() {
                        bathroom = bathroom - 1;
                        newinfo['bathroom'] = bathroom;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                  )),
              Text(bathroom.toString()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      bathroom = bathroom + 1;
                      newinfo['bathroom'] = bathroom;
                    });
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 20,
                  )),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenWidth * 0.080,
              ),
              Image.asset('assets/sofa.png'),
              Container(
                  width: ScreenWidth * 0.3, child: Text(' Livingroom : ')),
              IconButton(
                  onPressed: () {
                    if (livingroom > 0) {
                      setState(() {
                        livingroom = livingroom - 1;
                        newinfo['livingroom'] = livingroom;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                  )),
              Text(livingroom.toString()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      livingroom = livingroom + 1;
                      newinfo['livingroom'] = livingroom;
                    });
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 20,
                  )),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenWidth * 0.080,
              ),
              Image.asset('assets/sleep.png'),
              Container(width: ScreenWidth * 0.3, child: Text(' Bedroom : ')),
              IconButton(
                  onPressed: () {
                    if (bedroom > 0) {
                      setState(() {
                        bedroom = bedroom - 1;
                        newinfo['bedroom'] = bedroom;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                  )),
              Text(bedroom.toString()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      bedroom = bedroom + 1;
                      newinfo['bedroom'] = bedroom;
                    });
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 20,
                  )),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenWidth * 0.080,
              ),
              Image.asset('assets/garag.png'),
              Container(width: ScreenWidth * 0.3, child: Text(' Garage : ')),
              IconButton(
                  onPressed: () {
                    if (garage > 0) {
                      setState(() {
                        garage = garage - 1;
                        newinfo['garage'] = garage;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                  )),
              Text(garage.toString()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      garage = garage + 1;
                      newinfo['garage'] = garage;
                    });
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 20,
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: ScreenWidth * 0.080,
                ),
                Text('Description :'),
              ],
            ),
          ),
          Container(
            width: ScreenWidth * 0.85,
            child: TextFormField(
              initialValue: widget.description,
              onChanged: (value) {
                setState(() {
                  newinfo['description'] = value;
                });
              },
              maxLength: 300,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'write at least 4 line',
                  border: OutlineInputBorder()),
              maxLines: 10,
            ),
          ),
          Row(
            children: [
              Checkbox(
                  value: _value,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    if (_value) {
                      setState(() {
                        _value = !_value;
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('The old images will be removed'),
                              title:
                                  Text('Alert the old images will be removed'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {Navigator.of(context).pop();}, child: Text('Cancel')),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _value = !_value;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Yes')),
                              ],
                            );
                          });
                    }
                  }),
              Text('check the box if you want to change image '),
            ],
          ),
          ElevatedButton(
            onPressed: _value
                ? () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      pickeImageFromCamera();
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: Color.fromRGBO(6, 64, 64, 1),
                                      size: ScreenHeight * 0.07,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pickeImageFromGallery();
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.image_rounded,
                                      size: ScreenHeight * 0.07,
                                      color: Color.fromRGBO(6, 64, 64, 1),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        });
                  }
                : null,
            child: Text('Change images'),
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(84, 140, 129, 1),
            ),
          ),
          if (imagenotvide == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                  height: ScreenHeight * 0.45, child: ShowSlectedImages()),
            ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              width: ScreenWidth * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NeumorphicButton(
                    onPressed: () {
                      if (_value == true) {
                        if (images!.length == 0) {
                          showSnackBar(context);
                        } else {
                          pageController.nextPage(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.ease);
                        }
                      } else {
                        pageController.nextPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease);
                      }

                      setState(() {
                        newinfo['withimage'] = _value.toString();
                        mymarker = {
                          Marker(
                              markerId: MarkerId('1'),
                              visible: true,
                              position: LatLng(
                                  double.parse(newinfo['latitude'].toString()),
                                  double.parse(
                                      newinfo['longitude'].toString())))
                        };
                      });
                      print('////////////////');
                      print(newinfo);
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: NeumorphicStyle(
                        color: Color.fromRGBO(84, 140, 129, 1),
                        shape: NeumorphicShape.convex,
                        depth: 10),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    ]);
  }

  Widget OfferPosition() {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenHeight * 0.08,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Select location on map',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(84, 140, 129, 1),
                  Color.fromRGBO(6, 64, 64, 1),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: ScreenWidth,
                height: ScreenHeight * 0.55,
                child: Stack(
                  children: [
                    GoogleMap(
                      markers: mymarker,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(28.033886, 1.659626),
                        zoom: 5,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      rotateGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      onLongPress: (latlng) async {
                        mymarker.remove(Marker(markerId: MarkerId('1')));
                        mymarker.add(Marker(
                          markerId: MarkerId('1'),
                          position: latlng,
                        ));
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                latlng.latitude, latlng.longitude,
                                localeIdentifier: 'en');
                        setState(() {
                          newinfo['latitude'] = latlng.latitude.toString();
                          newinfo['longitude'] = latlng.longitude.toString();
                          newinfo['willaya'] =
                              placemarks[0].administrativeArea.toString();
                          newinfo['baladiya'] =
                              placemarks[0].locality.toString();
                        });
                      },
                    ),
                    Positioned(
                        left: ScreenWidth * 0.7,
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(
                        width: 0.5, color: Color.fromRGBO(84, 140, 129, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                width: ScreenWidth * 0.85,
                height: ScreenHeight * 0.05,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                      child: Icon(
                        Icons.place_outlined,
                        color: Color.fromRGBO(84, 140, 129, 1),
                      ),
                    ),
                    Text('Location :'),
                    Expanded(
                      child: Text(
                        newinfo['willaya'].toString() +
                            ',' +
                            newinfo['baladiya'].toString(),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: ScreenWidth * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          pageController.previousPage(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.ease);
                          setState(() {});
                        },
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '< ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                          TextSpan(
                              text: 'Back',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black))
                        ]))),
                    NeumorphicButton(
                      onPressed: () {
                        print(newinfo);
                        update();
                      },
                      child: Text(
                        'edit',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: NeumorphicStyle(
                          color: Color.fromRGBO(84, 140, 129, 1),
                          shape: NeumorphicShape.convex,
                          depth: 10),
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

  Widget ShowSlectedImages() {
    return GridView.builder(
        itemCount: images!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: images!.isEmpty
                  ? Container()
                  : Stack(
                      children: [
                        LayoutBuilder(builder: ((context, constraints) {
                          return Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(images![index].path),
                                fit: BoxFit.fill,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        images!.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.multiply_circle_fill,
                                      color: Colors.grey,
                                    )),
                              ),
                            ],
                          );
                        })),
                      ],
                    ),
            ));
  }

  Future pickeImageFromCamera() async {
    final selectimages = await cameraimage.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 4000,
        maxWidth: 3000);
    if (selectimages != null) {
      imagecam = File(selectimages.path);
      setState(() {
        images!.add(selectimages);
        imagenotvide = true;
      });
    }
  }

  Future pickeImageFromGallery() async {
    final List<XFile>? selectimages = await multimage.pickMultiImage(
        imageQuality: 80, maxHeight: 4000, maxWidth: 3000);
    setState(() {
      if (selectimages!.isNotEmpty) {
        images!.addAll(selectimages);
        imagenotvide = true;
      }
    });
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

  update() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');

    var response = await offerApi()
        .adddata(token, 'editoffer/${widget.id}', newinfo, images!);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('success');
    } else {
      Navigator.of(context).pushNamed('failed');
    }
  }

  Future<void> getcurrentPosition() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);

    setState(() async {
      lat = cl.latitude;
      long = cl.longitude;

      mymarker.remove(Marker(markerId: MarkerId('1')));
      mymarker.add(Marker(
        markerId: MarkerId('1'),
        position: LatLng(lat, long),
      ));
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 20)));
      setState(() {
        newinfo['latitude'] = lat.toString();
        newinfo['longitude'] = long.toString();
        newinfo['willaya'] = placemarks[0].administrativeArea.toString();
        newinfo['baladiya'] = placemarks[0].locality.toString();
      });
    });
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('You must select one image at less'),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
