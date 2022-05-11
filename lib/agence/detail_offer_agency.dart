import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class offer_detail_agency extends StatefulWidget {
  int id;
  String description;
  int prix;
  double surface;
  String categorie;
  String created_at;
  int num_image;
  String agenceName;
     String longitude;
  String latitude;
  offer_detail_agency({
    Key? key,
    required this.id,
    required this.surface,
    required this.description,
    required this.prix,
    required this.categorie,
    required this.created_at,
    required this.num_image,
    required this.agenceName,
      required this.latitude,
    required this.longitude
   
  }) : super(key: key);

  @override
  State<offer_detail_agency> createState() => _offer_detail_agencyState();
}

class _offer_detail_agencyState extends State<offer_detail_agency> {
  void initState() {
    getcomment(widget.id);
    super.initState();
  }

  @override
  TextEditingController _addcomment = new TextEditingController();
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
  var numberformatter = NumberFormat("#.###");
  bool isreadmore = false;
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed('home_agence');
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Color.fromARGB(255, 240, 240, 240),
              body: ListView(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              Stack(
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
                                                'http://192.168.126.32:8000/storage/images/' +
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
                                  Positioned(
                                      top: ScreenHeight * 0.01,
                                      right: ScrrenWidth * 0.05,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Text(
                                                            'Are you sure you want to delete this offer ?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancel')),
                                                          TextButton(
                                                              onPressed: () {
                                                                removeoffer(
                                                                    widget.id);
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        'home_agence');
                                                              },
                                                              child:
                                                                  Text('Yes')),
                                                        ],
                                                      );
                                                    });
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              )),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 7, 0, 0),
                                          child: Container(
                                            width: ScrrenWidth * 0.55,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          6, 64, 64, 1),
                                                      Color.fromRGBO(
                                                          84, 140, 129, 1),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end:
                                                        Alignment.bottomRight)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 0, 5),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 5, 0, 0),
                                                    child: Text(
                                                      widget.categorie,
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              166,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              ScrrenWidth *
                                                                  0.055),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          ScrrenWidth * 0.005),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 9, 0, 0),
                                                    child: Text(
                                                      '(' +
                                                          widget.surface
                                                              .toString() +
                                                          ' m²' +
                                                          ')',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
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
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              size: ScrrenWidth * 0.050,
                                              color: Color.fromARGB(
                                                  197, 84, 140, 129),
                                            ),
                                            Text(
                                              ' Khenchela',
                                              style: TextStyle(
                                                fontSize: 13.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: ScreenHeight * 0.007,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.person,
                                                size: ScrrenWidth * 0.050,
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
                                      padding: const EdgeInsets.fromLTRB(
                                          2, 40, 0, 3),
                                      child: Text(
                                        widget.prix.toString() + ' DZ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Container(
                                  width: ScrrenWidth * 0.88,
                                  child: Row(
                                    children: [
                                      Text(
                                        formatter
                                            .format(DateTime.tryParse(
                                                widget.created_at) as DateTime)
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                child: Center(
                                  child: Container(
                                    width: ScrrenWidth * 0.88,
                                    height: 1,
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          width: ScrrenWidth * 0.88,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Text(
                                  'Description',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              BuildText(widget.description),
                              InkWell(
                                child: Row(
                                  children: [
                                    Text(
                                      isreadmore ? 'Read less' : 'Read more',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(84, 140, 129, 1)),
                                    ),
                                    Icon(
                                      isreadmore
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color.fromRGBO(84, 140, 129, 1),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Comments',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)))),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        var data = {
                                          'text': _addcomment.text,
                                          'offers_id': widget.id.toString()
                                        };
                                        addcomment(data);
                                        _addcomment.text = '';
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Color.fromRGBO(84, 140, 129, 1),
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
              ))),
    );
  }

  Widget BuildText(String text) {
    final maxline = isreadmore ? null : 5;
    return Text(
      text,
      maxLines: maxline,
    );
  }

  Widget Listcomments() {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getcomment(widget.id),
        builder: ((context, AsyncSnapshot snapshot) {
          final comments = snapshot.data;
     
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: comments!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('assets/profile.jfif'),
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
                          ),
                        )),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        
          return Center(child: const CircularProgressIndicator());
        }
        )
        );
  }

  addcomment(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().addcomment(token, data, 'addcomment');
  }

  removeoffer(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().deleteoffer(token, 'deleteoffer/${id}');
  }

  getcomment(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().getoffercomment('getcomments/${id}', token);
    
    return jsonDecode(response.body);
  }
}
