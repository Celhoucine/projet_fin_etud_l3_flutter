import 'dart:convert';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/offer_api.dart';

class editprofile extends StatefulWidget {
  const editprofile({Key? key}) : super(key: key);

  @override
  State<editprofile> createState() => editprofileState();
}

class editprofileState extends State<editprofile> {
  @override
  void initState() {
    getprofiledata();
    super.initState();
  }

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _fnameController = new TextEditingController();
  TextEditingController _lnameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _AgenceNameController = new TextEditingController();
  TextEditingController _AddressController = new TextEditingController();

  GlobalKey<FormState> formdata = GlobalKey<FormState>();
  bool edit = false;
  bool nonedit = true;
  bool editform = false;
  Map<String, dynamic> userprofile = {
    'id': '',
    'lname': '',
    'fname': '',
    'email': '',
    'agenceName': '',
    'address': '',
    'phone': ''
  };
  var agenceinfo = [];

  var data = {
    'fname': '',
    'lname': '',
    'email': '',
    'agenceName': '',
    'address': '',
    'phone': ''
  };

  @override
  Widget build(BuildContext context) {
    setState(() {
      _fnameController.text = userprofile['fname'];
      _lnameController.text = userprofile['lname'];
      _emailController.text = userprofile['email'];
      _phoneController.text = userprofile['phone'].toString();
      _AgenceNameController.text = userprofile['agenceName'];
      _AddressController.text = userprofile['address'];
    });

    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            if (edit) Edite(),
            if (nonedit) NonEdite(),
          ],
        )),
      ),
    ));
  }

  Widget Edite() {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return Form(
        key: formdata,
        child: Column(children: [
          SizedBox(
            height: ScreenHeight * 0.08,
          ),
          Container(
            width: ScrrenWidth * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: Text('First Name'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      width: ScrrenWidth * 0.35,
                      height: ScreenHeight * 0.055,
                      child: TextFormField(
                        initialValue: _fnameController.text,
                        onSaved: (Value) {
                          setState(() {
                            data['fname'] = Value!;
                          });
                        },
                            onFieldSubmitted: (val) {
                    editform = true;
                  },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'First Name'),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                      child: Text('Last Name'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      width: ScrrenWidth * 0.35,
                      height: ScreenHeight * 0.055,
                      child: TextFormField(
                        initialValue: _lnameController.text,
                        onSaved: (Value) {
                          setState(() {
                            data['lname'] = Value!;
                          });
                        },
                            onFieldSubmitted: (val) {
                    editform = true;
                  },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Last Name'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenHeight * 0.03,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Text('Email'),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: ScrrenWidth * 0.8,
                height: ScreenHeight * 0.055,
                child: TextFormField(
                  initialValue: _emailController.text,
                  onSaved: (Value) {
                    setState(() {
                      data['email'] = Value!;
                    });
                  },
                      onFieldSubmitted: (val) {
                    editform = true;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Email'),
                  validator: (email) {
                    if (GetUtils.isEmail(email!)) {
                      return null;
                    } else {
                      return 'this is wrong email';
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenHeight * 0.03,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Text('Phone'),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: ScrrenWidth * 0.8,
                height: ScreenHeight * 0.055,
                child: TextFormField(

                  initialValue: _phoneController.text,
                  onSaved: (Value) {
                    setState(() {
                      data['phone'] = Value!;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Phone Number'),
                  validator: (phone) {
                    if (GetUtils.isPhoneNumber(phone!) &&
                        phone.length == 10 &&
                        !phone.contains('-') &&
                        !phone.contains('.')) {
                      return null;
                    } else {
                      return 'this is wrong phone';
                    }
                  },
                     onFieldSubmitted: (val) {
                    editform = true;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenHeight * 0.03,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Text('Agency Name'),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: ScrrenWidth * 0.8,
                height: ScreenHeight * 0.055,
                child: TextFormField(
                  initialValue: _AgenceNameController.text,
                  onSaved: (Value) {
                    setState(() {
                      data['agenceName'] = Value!;
                    });
                  },
                      onFieldSubmitted: (val) {
                    editform = true;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Agence Name'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenHeight * 0.03,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Text('Address'),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: ScrrenWidth * 0.8,
                height: ScreenHeight * 0.055,
                child: TextFormField(
                  initialValue: _AddressController.text,
                  onSaved: (Value) {
                    setState(() {
                      data['address'] = Value!;
                    });
                  },
                      onFieldSubmitted: (val) {
                    editform = true;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Address'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenHeight * 0.05,
          ),
          Container(
            width: ScrrenWidth * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        edit = false;
                        nonedit = true;
                      });
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Cannel',
                          style: TextStyle(fontSize: 15, color: Colors.black))
                    ]))),
                Container(
                  width: ScrrenWidth * 0.35,
                  child: NeumorphicButton(
                    onPressed: () {
                      if (editform==true) {
                        var formstate = formdata.currentState;
                        formstate!.save();
                        editeprofile();
                      } else {
                        print('ok');
                      }
                    },
                    child: Center(
                      child: Text(
                        'save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    style: NeumorphicStyle(
                        color: Color.fromRGBO(84, 140, 129, 1),
                        shape: NeumorphicShape.convex,
                        depth: 10),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  Widget NonEdite() {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return Column(children: [
      SizedBox(
        height: ScreenHeight * 0.08,
      ),
      Container(
        width: ScrrenWidth * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Text('First Name'),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: ScrrenWidth * 0.35,
                  height: ScreenHeight * 0.055,
                  child: TextFormField(
                    enabled: false,
                    controller: _fnameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Text('Last Name'),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: ScrrenWidth * 0.35,
                  height: ScreenHeight * 0.055,
                  child: TextFormField(
                    enabled: false,
                    controller: _lnameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: ScreenHeight * 0.03,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Text('Email'),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            width: ScrrenWidth * 0.8,
            height: ScreenHeight * 0.055,
            child: TextFormField(
              enabled: false,
              controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: ScreenHeight * 0.03,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Text('Phone'),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            width: ScrrenWidth * 0.8,
            height: ScreenHeight * 0.055,
            child: TextFormField(
              enabled: false,
              controller: _phoneController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: ScreenHeight * 0.03,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Text('Agency Name'),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            width: ScrrenWidth * 0.8,
            height: ScreenHeight * 0.055,
            child: TextFormField(
              enabled: false,
              controller: _AgenceNameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: ScreenHeight * 0.03,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Text('Address'),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            width: ScrrenWidth * 0.8,
            height: ScreenHeight * 0.055,
            child: TextFormField(
              enabled: false,
              controller: _AddressController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: ScreenHeight * 0.05,
      ),
      Center(
        child: Container(
          width: ScrrenWidth * 0.35,
          child: NeumorphicButton(
            onPressed: () {
              setState(() {
                edit = true;
                nonedit = false;
              });
            },
            child: Center(
              child: Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              ),
            ),
            style: NeumorphicStyle(
                color: Color.fromRGBO(84, 140, 129, 1),
                shape: NeumorphicShape.convex,
                depth: 10),
          ),
        ),
      ),
    ]);
  }

  getprofiledata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi().getprofile(token, 'agenceinfo');
    setState(() {
      agenceinfo = jsonDecode(response.body);
      agenceinfo = agenceinfo
          .map((e) => userprofile = {
                'id': e['id'],
                'lname': e['lname'],
                'fname': e['fname'],
                'email': e['email'],
                'agenceName': e['agenceName'],
                'address': e['address'],
                'phone': e['phone']
              })
          .toList();
    });
    print(userprofile);
  }

  editeprofile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response = await offerApi()
        .updateprofile(token, 'updateagence/${_emailController.text}', data);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('success');
    }else{
      Navigator.of(context).pushNamed('failed');
    }
  }
}