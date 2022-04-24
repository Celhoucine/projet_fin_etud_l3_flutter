import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/login-register.dart';

class accueilclient extends StatefulWidget {
  const accueilclient({Key? key}) : super(key: key);

  @override
  State<accueilclient> createState() => _accueilclientState();
}

class _accueilclientState extends State<accueilclient> {
  @override
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child:Scaffold(appBar: AppBar(
      toolbarHeight: ScreenHeight*0.1,
      flexibleSpace: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              
              Container(
                color: Colors.grey,
                width: ScrrenWidth*0.7,
                height: ScreenHeight*0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text('filtre'),
                ),
              )
            ],),
          ),
          Row(children: [
            Text('row2.1'),
            Text('row2.1')
          ],)
        ],
      )
      

      ),
      ),
      );
  }
}
