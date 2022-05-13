import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/src/places.dart';
import 'package:projet_fin_etud_l3_flutter/api/login-register.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';

class postadd extends StatefulWidget {
  const postadd({Key? key}) : super(key: key);

  @override
  State<postadd> createState() => _postaddState();
}

class _postaddState extends State<postadd> {
  @override
  void initState() {
    _loadCategories();
    getcurrentPosition();
    var _value = 1;

    super.initState();
  }

  @override
  String? dropdownValue;
  Set<Marker> mymarker = {
    Marker(
        markerId: MarkerId('1'),
        visible: true,
        position: LatLng(28.033886, 1.659626))
  };
  double _value = 1;
  late Position cl;
  var lat;
  var long;
  var categories = [];
  String category_id = "1";
  File? imagecam;
  var cameraimage = ImagePicker();
  var multimage = ImagePicker();
  List<XFile>? images = [];
  var data = {
    'description': '',
    'surface': '',
    'prix': '',
    'categorie': '1',
    'longitude': '',
    'latitude': '',
    'bathroom': 0,
    'garage': 0,
    'bedroom': 0,
    'livingroom': 0,
    'kitchen': 0,
  };
  List images_path = [];
  int garage = 0;
  int bathroom = 0;
  int bedroom = 0;
  int livingroom = 0;
  int kitchen = 0;
  bool hide = true;
  bool hide1 = false;
  PageController pageController = PageController(initialPage: 0);

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [FormOfAddPost(), OfferPosition(), UplodeImage()],
        ),
      ),
    );
  }

  Widget FormOfAddPost() {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;

    TextEditingController Type = new TextEditingController();
    TextEditingController Prix = new TextEditingController();
    TextEditingController Description = new TextEditingController();
    TextEditingController Surface = new TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: ScreenHeight * 0.08,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Add Your Property', style: TextStyle(color: Colors.white)),
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
      body: ListView(
        children: [
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
                            data['categorie'] = category_id;
                          });
                        },
                        value: category_id,
                      ),
                    ),
                    SizedBox(
                      width: ScreenWidth * 0.05,
                    ),
                    Text('F : '),
                    DropdownButton<String>(
                      elevation: 16,
                      underline: Container(
                        width: ScreenWidth * 0.28,
                        height: 1,
                        color: Colors.black26,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          print(newValue);
                        });
                      },
                      hint: Text('Choose'),
                      value: dropdownValue,
                      items: <String>['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
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
                        onChanged: (value) {
                          setState(() {
                            data['prix'] = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          suffix: Text('DA'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenWidth * 0.05,
                    ),
                    Text('Surface :'),
                    Container(
                      width: ScreenWidth * 0.28,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            data['surface'] = value;
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
              Row(
                children: [
                  SizedBox(
                    width: ScreenWidth * 0.080,
                  ),
                  Icon(Icons.kitchen),
                  Container(
                      width: ScreenWidth * 0.3, child: Text('Kitchen : ')),
                  IconButton(
                      onPressed: () {
                        if (kitchen > 0) {
                          setState(() {
                            kitchen = kitchen - 1;
                            data['kitchen'] = kitchen;
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
                          data['kitchen'] = kitchen;
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
                  Icon(Icons.bathroom),
                  Container(
                      width: ScreenWidth * 0.3, child: Text('bathroom : ')),
                  IconButton(
                      onPressed: () {
                        if (bathroom > 0) {
                          setState(() {
                            bathroom = bathroom - 1;
                            data['bathroom'] = bathroom;
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
                          data['bathroom'] = bathroom;
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
                  Icon(Icons.room),
                  Container(
                      width: ScreenWidth * 0.3, child: Text('livingroom : ')),
                  IconButton(
                      onPressed: () {
                        if (livingroom > 0) {
                          setState(() {
                            livingroom = livingroom - 1;
                            data['livingroom'] = livingroom;
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
                          data['livingroom'] = livingroom;
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
                  Icon(Icons.bedroom_parent_sharp),
                  Container(
                      width: ScreenWidth * 0.3, child: Text('bedroom : ')),
                  IconButton(
                      onPressed: () {
                        if (bedroom > 0) {
                          setState(() {
                            bedroom = bedroom - 1;
                            data['bedroom'] = bedroom;
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
                          data['bedroom'] = bedroom;
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
                  Icon(Icons.garage),
                  Container(width: ScreenWidth * 0.3, child: Text('garage : ')),
                  IconButton(
                      onPressed: () {
                        if (garage > 0) {
                          setState(() {
                            garage = garage - 1;
                            data['garage'] = garage;
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
                          data['garage'] = garage;
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
                  onChanged: (value) {
                    setState(() {
                      data['description'] = value;
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'write description',
                      border: OutlineInputBorder()),
                  maxLines: 10,
                ),
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
                          setState(() {
                            mymarker = {
                              Marker(
                                  markerId: MarkerId('1'),
                                  visible: true,
                                  position: LatLng(28.033886, 1.659626))
                            };
                          });
                          pageController.nextPage(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.ease);
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
          ),
        ],
      ),
    );
  }

  Widget UplodeImage() {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenHeight * 0.08,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Upload Images', style: TextStyle(color: Colors.white)),
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
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: ScreenHeight * 0.05,
                ),
                if (hide == true)
                  Container(
                    width: ScreenWidth,
                    height: ScreenHeight * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            pickeImageFromCamera();
                          },
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Color.fromRGBO(6, 64, 64, 1),
                            size: ScreenHeight * 0.1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pickeImageFromGallery();
                          },
                          child: Icon(
                            Icons.image_rounded,
                            size: ScreenHeight * 0.1,
                            color: Color.fromRGBO(6, 64, 64, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                if (hide1 == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          pickeImageFromCamera();
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
                        },
                        child: Icon(
                          Icons.image_rounded,
                          size: ScreenHeight * 0.07,
                          color: Color.fromRGBO(6, 64, 64, 1),
                        ),
                      )
                    ],
                  ),
                if (hide1 == true)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                        height: ScreenHeight * 0.45,
                        child: ShowSlectedImages()),
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
                              setState(() {
                                mymarker = {
                                  Marker(
                                      markerId: MarkerId('1'),
                                      visible: true,
                                      position: LatLng(28.033886, 1.659626))
                                };
                              });
                            },
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '< ',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              TextSpan(
                                  text: 'Back',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black))
                            ]))),
                        NeumorphicButton(
                          onPressed: () {
                            addannonce();
                          },
                          child: Text(
                            'Post',
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
          ],
        ));
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
                child: GoogleMap(
                  markers: mymarker,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(28.033886, 1.659626),
                    zoom: 5,
                  ),
                  rotateGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onLongPress: (latlng) async {
                    mymarker.remove(Marker(markerId: MarkerId('1')));
                    mymarker
                        .add(Marker(markerId: MarkerId('1'), position: latlng));
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        latlng.latitude, latlng.longitude,
                        localeIdentifier: 'en');
                    setState(() {
                      data['latitude'] = latlng.latitude.toString();
                      data['longitude'] = latlng.longitude.toString();
                      data['willaya'] =
                          placemarks[0].administrativeArea.toString();
                      data['baladiya'] = placemarks[0].locality.toString();
                      print(data);
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
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
                        pageController.nextPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease);
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
        ),
      ),
    );
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
        hide1 = true;
        hide = false;
      });
    }
  }

  Future pickeImageFromGallery() async {
    final List<XFile>? selectimages = await multimage.pickMultiImage(
        imageQuality: 80, maxHeight: 4000, maxWidth: 3000);
    setState(() {
      hide1 = true;
      hide = false;
      if (selectimages!.isNotEmpty) {
        images!.addAll(selectimages);
      } else {}
    });
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

  addannonce() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');

    var response = await offerApi().adddata(token, 'addoffer', data, images!);

    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('success');
    } else {
      Navigator.of(context).pushNamed('failed');
    }
  }

  Future<void> getcurrentPosition() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);

    setState(() {
      lat = cl.latitude;
      long = cl.longitude;
      print('lat' + lat.toString());
      print('long' + long.toString());
    });
  }
}
