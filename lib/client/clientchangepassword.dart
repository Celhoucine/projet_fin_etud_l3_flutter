import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:projet_fin_etud_l3_flutter/api/offer_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class changeClientpassword extends StatefulWidget {
  const changeClientpassword({Key? key}) : super(key: key);

  @override
  State<changeClientpassword> createState() => _changeClientpasswordState();
}

class _changeClientpasswordState extends State<changeClientpassword> {
  @override
  TextEditingController _CurrentPasswordController =
      new TextEditingController();
  TextEditingController _NewPasswordController = new TextEditingController();
  TextEditingController _ConfNewPasswordController =
      new TextEditingController();

  var data = {'old_password': '', 'new_password': ''};
  final _Form = new GlobalKey<FormState>();
  late var FormData = _Form.currentState;
  Widget build(BuildContext context) {
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
            'Change Passowrd',
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
            child: Form(
          key: _Form,
          child: Container(
            width: ScrrenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: ScreenHeight * 0.1,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: ScrrenWidth * 0.75,
                  height: ScreenHeight * 0.055,
                  child: TextFormField(
                    controller: _CurrentPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Current Password'),
                    onSaved: (v) {
                      setState(() {
                        data['old_password'] = _CurrentPasswordController.text;
                        print(data);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenHeight * 0.04,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: ScrrenWidth * 0.75,
                  height: ScreenHeight * 0.055,
                  child: TextFormField(
                    controller: _NewPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'New Password'),
                    validator: (password) {
                      if (password!.length >= 8) {
                        return null;
                      } else {
                        return ' password must be at least 8 characters ';
                      }
                    },
                    onSaved: (v) {
                      setState(() {
                        data['new_password'] = _NewPasswordController.text;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenHeight * 0.04,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: ScrrenWidth * 0.75,
                  height: ScreenHeight * 0.055,
                  child: TextFormField(
                      controller: _ConfNewPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'Confirme New Password'),
                      validator: (confirmpass) {
                        if (_ConfNewPasswordController.text ==
                            _NewPasswordController.text) {
                          return null;
                        } else {
                          return 'please confirm your password';
                        }
                      }),
                ),
                SizedBox(
                  height: ScreenHeight * 0.1,
                ),
                Container(
                  width: ScrrenWidth * 0.35,
                  child: NeumorphicButton(
                    onPressed: () {
                      print(data);
                      if (FormData!.validate()) {
                        FormData!.save();
                        changepassword();
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
        )),
      ),
    );
  }

  Future changepassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = await preferences.getString('token');
    var response =
        await offerApi().changepassword(token, data, 'updatepassword');
   if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('profileclientsuccess');
    } else {
      Navigator.of(context).pushNamed('failedClient');
    }
  }
}
